import 'package:better_scanner/models/qr_models.dart';
import 'package:better_scanner/screens/components/copy_text_field.dart';
import 'package:flutter/material.dart';

class WifiDetailsField extends StatelessWidget {
  final WifiCred wifi;
  const WifiDetailsField({super.key, required this.wifi});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        CopyTextField(title: 'SSID', text: wifi.ssid),
        const SizedBox(height: 8),
        CopyTextField(title: 'Password', text: wifi.password),
      ],
    );
  }
}
