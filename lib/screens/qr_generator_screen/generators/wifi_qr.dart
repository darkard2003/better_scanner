import 'package:better_scanner/models/qr_models.dart';
import 'package:better_scanner/models/wifi_security.dart';
import 'package:better_scanner/screens/components/decorated_text_field.dart';
import 'package:flutter/material.dart';

class WifiQrGenerator extends StatefulWidget {
  final Function(String) onQrGenerated;
  const WifiQrGenerator({super.key, required this.onQrGenerated});

  @override
  State<WifiQrGenerator> createState() => _WifiQrGeneratorState();
}

class _WifiQrGeneratorState extends State<WifiQrGenerator> {
  String _ssid = '';
  String _password = '';
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
                                _selectedSecurity = s;
                                var qrString = WifiCred.getWifiQrString(
                                    _ssid, _password,
                                    security: _selectedSecurity,
                                    hidden: _hidden);
                                widget.onQrGenerated(qrString);
                                setState(() {});
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
                _hidden = value!;
                var qrString = WifiCred.getWifiQrString(_ssid, _password,
                    security: _selectedSecurity, hidden: _hidden);
                widget.onQrGenerated(qrString);
                setState(() {});
              },
            ),
          ],
        ),
        const SizedBox(height: 8.0),
        DecoratedTextField(
          hintText: 'Enter SSID',
          labelText: 'SSID',
          onChanged: (text) {
            _ssid = text;
            var qrString = WifiCred.getWifiQrString(_ssid, _password,
                security: _selectedSecurity, hidden: _hidden);
            widget.onQrGenerated(qrString);
            setState(() {});
          },
        ),
        const SizedBox(height: 8.0),
        DecoratedTextField(
          hintText: 'Enter Password',
          labelText: 'Password',
          onChanged: (text) {
            _password = text;
            var qrString = WifiCred.getWifiQrString(_ssid, _password,
                security: _selectedSecurity, hidden: _hidden);
            widget.onQrGenerated(qrString);
            setState(() {});
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
