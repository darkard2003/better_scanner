import 'package:better_scanner/models/qr_type.dart';
import 'package:better_scanner/screens/components/decorated_text_field.dart';
import 'package:flutter/material.dart';

class TextQrGenerator extends StatelessWidget {
  final QrType type;
  final Function(String) onQrGenerated;
  const TextQrGenerator({
    super.key,
    required this.onQrGenerated,
    required this.type,
  });

  @override
  Widget build(BuildContext context) {
    return DecoratedTextField(
      hintText: 'Enter ${type.name} here',
      labelText: type.name,
      onChanged: (text) => onQrGenerated(text),
    );
  }
}
