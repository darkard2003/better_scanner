import 'package:better_scanner/models/qr_record_model.dart';
import 'package:better_scanner/models/qr_type.dart';
import 'package:better_scanner/services/qr_parser.dart';

extension QRParsing on QrRecordModel {
  String get displayName {
    if (name.isNotEmpty) return name;
    var data = this.data;
    switch (type) {
      case QrType.url:
        data = QRParser.getDomain(data);
        break;
      case QrType.wifi:
        data = QRParser.parseWifi(data).ssid;
        break;
      default:
        data = 'No name';
        break;
    }
    return data;
  }

  String get displayData {
    var data = this.data;
    switch (type) {
      case QrType.url:
        data = QRParser.parseUri(data).toString();
        break;
      case QrType.wifi:
        data = QRParser.parseWifi(data).ssid;
        break;
      default:
        break;
    }
    return data;
  }

  String get copyData {
    var data = this.data;
    switch (type) {
      case QrType.url:
        data = QRParser.parseUri(data).toString();
        break;
      case QrType.wifi:
        data = QRParser.parseWifi(data).password;
        break;
      default:
        break;
    }
    return data;
  }
}
