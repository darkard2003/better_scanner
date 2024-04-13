import 'package:better_scanner/models/qr_type.dart';
import 'package:better_scanner/screens/qr_generator_screen/generators/email_qr_generator.dart';
import 'package:better_scanner/screens/qr_generator_screen/generators/geo_generator.dart';
import 'package:better_scanner/screens/qr_generator_screen/generators/phone_generator.dart';
import 'package:better_scanner/screens/qr_generator_screen/generators/plain_text.dart';
import 'package:better_scanner/screens/qr_generator_screen/generators/sms_generator.dart';
import 'package:better_scanner/screens/qr_generator_screen/generators/wifi_qr.dart';
import 'package:flutter/material.dart';

class QrGeneratorField extends StatelessWidget {
  final String qrStr;
  final QrType type;
  final Function(String) onGenerate;
  const QrGeneratorField({
    super.key,
    required this.qrStr,
    required this.type,
    required this.onGenerate,
  });

  @override
  Widget build(BuildContext context) {
    switch (type) {
      case QrType.wifi:
        return WifiQrGenerator(
          onQrGenerated: onGenerate,
          wifiQr: qrStr,
        );
      case QrType.geo:
        return GeoQrGenerator(
          onQrGenerated: onGenerate,
          qrData: qrStr,
        );
      case QrType.phone:
        return PhoneQrGenerator(
          onQrGenerated: onGenerate,
          phoneQr: qrStr,
        );
      case QrType.sms:
        return SMSQrGenerator(
          onQrGenerated: onGenerate,
          smsQr: qrStr,
        );
      case QrType.email:
        return EmailQrGenerator(
          onQrGenerated: onGenerate,
          qrString: qrStr,
        );
      default:
        return TextQrGenerator(
          onQrGenerated: onGenerate,
          qrStr: qrStr,
          type: type,
        );
    }
  }
}
