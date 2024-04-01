import 'package:better_scanner/models/qr_models.dart';
import 'package:better_scanner/models/qr_record_model.dart';
import 'package:better_scanner/screens/components/decorated_text_field.dart';
import 'package:flutter/material.dart';

class WifiQrGenerator extends StatefulWidget {
  final Function(QrRecordModel) onQrGenerated;
  const WifiQrGenerator({super.key, required this.onQrGenerated});

  @override
  State<WifiQrGenerator> createState() => _WifiQrGeneratorState();
}

class _WifiQrGeneratorState extends State<WifiQrGenerator> {
  WifiCred _qrRecord = WifiCred.fromSSIDPassword('', '');
  bool _showPassword = false;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        DecoratedTextField(
          hintText: 'Enter SSID',
          labelText: 'SSID',
          onChanged: (text) {
            setState(() {
              _qrRecord = WifiCred.fromSSIDPassword(text, _qrRecord.password);
              widget.onQrGenerated(_qrRecord);
            });
          },
        ),
        const SizedBox(height: 8.0),
        DecoratedTextField(
          hintText: 'Enter Password',
          labelText: 'Password',
          onChanged: (text) {
            setState(() {
              _qrRecord = WifiCred.fromSSIDPassword(_qrRecord.ssid, text);
              widget.onQrGenerated(_qrRecord);
            });
          },
          obscureText: !_showPassword,
          suffix: IconButton(
            icon: Icon(
              _showPassword ? Icons.visibility : Icons.visibility_off,
            ),
            onPressed: () {
              setState(() {
                _showPassword = !_showPassword;
              });
            },
          ),
        ),
      ],
    );
  }
}
