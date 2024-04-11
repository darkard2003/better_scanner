import 'package:better_scanner/models/qr_type.dart';
import 'package:better_scanner/screens/components/decorated_text_field.dart';
import 'package:flutter/material.dart';

class TextQrGenerator extends StatefulWidget {
  final String qrStr;
  final QrType type;
  final Function(String) onQrGenerated;
  const TextQrGenerator({
    super.key,
    required this.onQrGenerated,
    required this.qrStr,
    required this.type,
  });

  @override
  State<TextQrGenerator> createState() => _TextQrGeneratorState();
}

class _TextQrGeneratorState extends State<TextQrGenerator> {
  late final TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: widget.qrStr);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (widget.qrStr != _controller.text) {
      _controller.text = widget.qrStr;
    }
    return DecoratedTextField(
      controller: _controller,
      hintText: 'Enter ${widget.type.name} here',
      labelText: widget.type.name,
      onChanged: (text) => widget.onQrGenerated(text),
    );
  }
}
