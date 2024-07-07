import 'package:better_scanner/models/qr_models.dart';
import 'package:better_scanner/screens/components/copy_text_field.dart';
import 'package:flutter/material.dart';

class PhoneDetailsField extends StatelessWidget {
  final PhoneQr phone;
  final Function(String) onCopyPhone;
  const PhoneDetailsField({
    super.key,
    required this.phone,
    required this.onCopyPhone,
  });

  @override
  Widget build(BuildContext context) {
    return CopyTextField(
      title: 'Phone',
      text: phone.number,
      onCopy: () => onCopyPhone(phone.number),
    );
  }
}
