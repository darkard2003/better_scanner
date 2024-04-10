import 'package:better_scanner/models/qr_models.dart';
import 'package:better_scanner/models/wifi_security.dart';
import 'package:better_scanner/screens/components/decorated_text_field.dart';
import 'package:flutter/material.dart';

class WifiQrGenerator extends StatefulWidget {
  final Function(String) onQrGenerated;
  final WifiCred wifiQr;
  const WifiQrGenerator({
    super.key,
    required this.onQrGenerated,
    required this.wifiQr,
  });

  @override
  State<WifiQrGenerator> createState() => _WifiQrGeneratorState();
}

class _WifiQrGeneratorState extends State<WifiQrGenerator> {
  late TextEditingController ssidController;
  late TextEditingController passwordController;
  late WifiSecurity selectedSecurity;
  late bool hidden;
  bool _showPassword = false;

  @override
  void initState() {
    super.initState();
    ssidController = TextEditingController(text: widget.wifiQr.ssid);
    passwordController = TextEditingController(text: widget.wifiQr.password);
    selectedSecurity = widget.wifiQr.security;
    hidden = widget.wifiQr.hidden;
  }

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
                            selected: selectedSecurity == s,
                            onSelected: (selected) {
                              if (selected) {
                                selectedSecurity = s;
                                var qrString = WifiCred.getWifiQrString(
                                    ssidController.text,
                                    passwordController.text,
                                    security: selectedSecurity,
                                    hidden: hidden);
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
              value: hidden,
              onChanged: (value) {
                hidden = value!;
                var qrString = WifiCred.getWifiQrString(
                  ssidController.text,
                  passwordController.text,
                  security: selectedSecurity,
                  hidden: hidden,
                );
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
            var qrString = WifiCred.getWifiQrString(
              ssidController.text,
              passwordController.text,
              security: selectedSecurity,
              hidden: hidden,
            );
            widget.onQrGenerated(qrString);
            setState(() {});
          },
        ),
        const SizedBox(height: 8.0),
        DecoratedTextField(
          hintText: 'Enter Password',
          labelText: 'Password',
          onChanged: (text) {
            var qrString = WifiCred.getWifiQrString(
              ssidController.text,
              passwordController.text,
              security: selectedSecurity,
              hidden: hidden,
            );
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
