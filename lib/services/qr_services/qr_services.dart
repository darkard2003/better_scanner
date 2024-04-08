import 'dart:typed_data';

import 'package:better_scanner/models/qr_models.dart';
import 'package:better_scanner/models/qr_record_model.dart';
import 'package:better_scanner/models/qr_type.dart';
import 'package:better_scanner/models/qr_type_extention.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/services.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:share_plus/share_plus.dart';
import 'package:url_launcher/url_launcher.dart';

class QrServices {
  static Future<void> copyQrToClipboard(QrRecordModel qr) async {
    var data = ClipboardData(text: qr.copyData);
    await Clipboard.setData(data);
  }

  static Future<void> copyTextToClipboard(String text) async {
    var data = ClipboardData(text: text);
    await Clipboard.setData(data);
  }

  static Future<bool> canLaunch(QrRecordModel qr) async {
    if (qr.type == QrType.url) {
      qr = qr as UrlQrModel;
      return await canLaunchUrl(qr.url);
    }
    return false;
  }

  static Future<void> launch(QrRecordModel qr) async {
    if (qr.type == QrType.url) {
      qr = qr as UrlQrModel;
      await launchUrl(qr.url);
    }
  }

  static Future<void> shareImage(ByteBuffer bytes, String name,
      {String mimeType = 'image/png'}) {
    var xfile = XFile.fromData(
      bytes.asUint8List(),
      mimeType: mimeType,
      name: name,
    );
    return Share.shareXFiles([xfile], text: name);
  }

  static Future<void> shareQrText(QrRecordModel qr) async {
    if (qr.runtimeType == UrlQrModel) {
      qr = qr as UrlQrModel;
      await Share.shareUri(qr.url);
      return;
    }
    await Share.share(qr.copyData, subject: qr.displayName);
  }

  static List<QrRecordModel> barcodeToQrList(BarcodeCapture barcode) {
    var qrList = <QrRecordModel>[];
    var codes = barcode.barcodes;
    for (var code in codes) {
      var rawValue = code.rawValue;
      if (rawValue == null) {
        continue;
      }
      var record =
          QrRecordModel.newEmpty(data: rawValue, type: code.type.qrType);
      qrList.add(record);
    }
    return qrList;
  }

  static Future<bool> scanQrFromFile(MobileScannerController controller) async {
    var file = await FilePicker.platform.pickFiles(
      type: FileType.image,
    );
    if (file == null) {
      return false;
    }
    var path = file.files.single.path;

    if (path == null) {
      return false;
    }

    return await controller.analyzeImage(path);
  }
}
