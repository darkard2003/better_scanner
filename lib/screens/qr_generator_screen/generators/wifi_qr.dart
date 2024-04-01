import 'package:better_scanner/models/qr_models.dart';
import 'package:better_scanner/models/qr_record_model.dart';
import 'package:better_scanner/models/wifi_security.dart';
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
  WifiSecurity _selectedSecurity = WifiSecurity.WPA;
  bool _hidden = false;
  bool _showPassword = false;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Row(
          children: [
            Expanded(
              child: Row(
                children: WifiSecurity.values
                    .map((s) => Padding(
                      padding: const EdgeInsets.only(right: 8),
                      child: ChoiceChip(
                            label: Text(s.name),
                            selected: _selectedSecurity == s,
                            onSelected: (selected) {
                              if (selected) {
                                setState(() {
                                  _selectedSecurity = s;
                                  _qrRecord = WifiCred.fromSSIDPassword(
                                    _qrRecord.ssid,
                                    _qrRecord.password,
                                    hidden: _hidden,
                                    security: s,
                                  );
                                  widget.onQrGenerated(_qrRecord);
                                });
                              }
                            },
                          ),
                    ))
                    .toList(),
              ),
            ),
            const Text('Hidden'),
            Checkbox(
              value: _hidden,
              onChanged: (value) {
                setState(() {
                  _hidden = value!;
                  _qrRecord = WifiCred.fromSSIDPassword(
                    _qrRecord.ssid,
                    _qrRecord.password,
                    security: _selectedSecurity,
                    hidden: _hidden,
                  );
                  widget.onQrGenerated(_qrRecord);
                });
              },
            ),
          ],
        ),
        const SizedBox(height: 8.0),
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
            visualDensity: VisualDensity.compact,
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
