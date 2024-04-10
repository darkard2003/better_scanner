import 'package:better_scanner/models/qr_models.dart';
import 'package:better_scanner/models/qr_record_model.dart';
import 'package:better_scanner/models/qr_type.dart';
import 'package:better_scanner/screens/qr_generator_screen/generators/plain_text.dart';
import 'package:better_scanner/screens/qr_generator_screen/generators/wifi_qr.dart';
import 'package:flutter/material.dart';

class QrGeneratorField extends StatelessWidget {
  final QrRecordModel qr;
  final Function(String) onGenerate;
  const QrGeneratorField({
    super.key,
    required this.qr,
    required this.onGenerate,
  });

  @override
  Widget build(BuildContext context) {
    switch (qr.type) {
      case QrType.wifi:
        return WifiQrGenerator(
          onQrGenerated: onGenerate,
          wifiQr: qr as WifiCred,
        );
      default:
        return TextQrGenerator(onQrGenerated: onGenerate, qr: qr);
    }
  }
}
