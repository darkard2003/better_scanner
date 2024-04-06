import 'package:better_scanner/models/qr_type.dart';
import 'package:better_scanner/screens/qr_generator_screen/generators/plain_text.dart';
import 'package:better_scanner/screens/qr_generator_screen/generators/wifi_qr.dart';
import 'package:flutter/material.dart';

class QrGeneratorField extends StatelessWidget {
  final QrType type;
  final Function(String) onGenerate;
  const QrGeneratorField({
    super.key,
    required this.type,
    required this.onGenerate,
  });

  @override
  Widget build(BuildContext context) {
    switch (type) {
      case QrType.wifi:
        return WifiQrGenerator(onQrGenerated: onGenerate);
      default:
        return TextQrGenerator(onQrGenerated: onGenerate, type: type);
    }
  }
}
