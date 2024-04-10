import 'package:better_scanner/models/qr_record_model.dart';
import 'package:better_scanner/models/qr_type.dart';
import 'package:better_scanner/screens/components/decorated_text_field.dart';
import 'package:flutter/material.dart';

class TextQrGenerator extends StatefulWidget {
  final QrRecordModel qr;
  final Function(String) onQrGenerated;
  const TextQrGenerator({
    super.key,
    required this.onQrGenerated,
    required this.qr,
  });

  @override
  State<TextQrGenerator> createState() => _TextQrGeneratorState();
}

class _TextQrGeneratorState extends State<TextQrGenerator> {
  late final TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: widget.qr.data);
  }

  @override
  Widget build(BuildContext context) {
    return DecoratedTextField(
      controller: _controller,
      hintText: 'Enter ${widget.qr.type.name} here',
      labelText: widget.qr.type.name,
      onChanged: (text) => widget.onQrGenerated(text),
    );
  }
}
