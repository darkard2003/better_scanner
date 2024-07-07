import 'package:better_scanner/models/qr_models.dart';
import 'package:better_scanner/models/wifi_security.dart';
import 'package:better_scanner/screens/components/decorated_text_field.dart';
import 'package:better_scanner/screens/shared/show_snackbar.dart';
import 'package:flutter/material.dart';

class WifiQrGenerator extends StatefulWidget {
  final Function(String) onQrGenerated;
  final String wifiQr;
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
    var ssid = '';
    var password = '';
    hidden = false;
    selectedSecurity = WifiSecurity.wpa;

    try {
      var parts = WifiCredQr.parseWifiQrString(widget.wifiQr);
      ssid = parts.$1;
      password = parts.$2;
      selectedSecurity = parts.$3;
      hidden = parts.$4;
    } catch (e) {
      showSnackbar(context, "Faild to parse qr", type: SnackbarType.error);
    }
    ssidController = TextEditingController(text: ssid);
    passwordController = TextEditingController(text: password);
  }

  @override
  void dispose() {
    ssidController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  void onChanged() {
    widget.onQrGenerated(WifiCredQr.getWifiQrString(
      ssidController.text,
      passwordController.text,
      security: selectedSecurity,
      hidden: hidden,
    ));
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
                                onChanged();
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
                onChanged();
              },
            ),
          ],
        ),
        const SizedBox(height: 8.0),
        DecoratedTextField(
          controller: ssidController,
          hintText: 'Enter SSID',
          labelText: 'SSID',
          onChanged: (text) {
            onChanged();
          },
        ),
        const SizedBox(height: 8.0),
        DecoratedTextField(
          controller: passwordController,
          hintText: 'Enter Password',
          labelText: 'Password',
          onChanged: (text) {
            onChanged();
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
