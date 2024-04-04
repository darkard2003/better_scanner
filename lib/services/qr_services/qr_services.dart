import 'dart:ui';

import 'package:better_scanner/models/qr_models.dart';
import 'package:better_scanner/models/qr_record_model.dart';
import 'package:better_scanner/models/qr_type.dart';
import 'package:pretty_qr_code/pretty_qr_code.dart';
import 'package:share_plus/share_plus.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:image/image.dart';

class QrServices {
  static Future<void> copyToClipboard(QrRecordModel qr) async {
    await Share.share(
      qr.copyData,
      subject: qr.displayName,
    );
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

  static Future<void> shareQrImage(QrRecordModel qr,
      {PrettyQrDecoration? decoration}) async {
    var qrCode = QrCode.fromData(
        data: qr.data, errorCorrectLevel: QrErrorCorrectLevel.H);

    var qrImage = QrImage(qrCode);
    var image = await qrImage.toImage(size: 800);
    var bytes = await image.toByteData(format: ImageByteFormat.png);
    if (bytes == null) {
      return;
    }
    var byteBuffer = bytes.buffer;
    var paddedImage = Image.fromBytes(
        width: image.width + 40, height: image.height + 40, bytes: byteBuffer);
    var xfile = XFile.fromData(paddedImage.getBytes());
    await Share.shareXFiles([xfile], text: qr.displayName);
  }
}

