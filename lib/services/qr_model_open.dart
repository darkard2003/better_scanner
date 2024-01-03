import 'package:better_scanner/models/qr_record_model.dart';
import 'package:better_scanner/models/qr_type.dart';
import 'package:better_scanner/services/qr_parser.dart';
import 'package:flutter/services.dart';
import 'package:url_launcher/url_launcher.dart';

extension QRMethods on QrRecordModel {
  Future<bool> canOpen() async {
    switch (type) {
      case QrType.url:
        var uri = QRParser.parseUri(data);
        return await canLaunchUrl(uri);
      default:
        return false;
    }
  }

  Future<void> open() async {
    switch (type) {
      case QrType.url:
        var uri = QRParser.parseUri(data);
        await launchUrl(uri);
        break;
      default:
        break;
    }
  }

  void copy() {
    var data = '';
    switch (type) {
      case QrType.url:
        data = QRParser.parseUri(this.data).toString();
        break;
      case QrType.wifi:
        data = QRParser.parseWifi(this.data).password;
        break;
      default:
        data = this.data;
        break;
    }
    Clipboard.setData(ClipboardData(text: data));
  }
}
