import 'package:better_scanner/models/qr_models.dart';
import 'package:better_scanner/screens/components/copy_text_field.dart';
import 'package:flutter/material.dart';

class WifiDetailsField extends StatefulWidget {
  final WifiCredQr wifi;
  final VoidCallback? onCopySsid;
  final VoidCallback? onCopyPassword;

  const WifiDetailsField(
      {super.key, required this.wifi, this.onCopySsid, this.onCopyPassword});

  @override
  State<WifiDetailsField> createState() => _WifiDetailsFieldState();
}

class _WifiDetailsFieldState extends State<WifiDetailsField> {
  bool _visible = false;
  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        CopyTextField(
          title: 'SSID',
          text: widget.wifi.ssid,
          onCopy: widget.onCopySsid,
        ),
        const SizedBox(height: 8),
        CopyTextField(
          title: 'Password',
          obscureText: !_visible,
          text: widget.wifi.password,
          trailing: IconButton(
              onPressed: () {
                _visible = !_visible;
                setState(() {});
              },
              icon: Icon(_visible
                  ? Icons.visibility_off_outlined
                  : Icons.visibility_outlined)),
          onCopy: widget.onCopyPassword,
        ),
      ],
    );
  }
}
