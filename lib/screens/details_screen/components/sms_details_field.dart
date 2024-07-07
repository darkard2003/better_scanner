import 'package:better_scanner/models/qr_models.dart';
import 'package:better_scanner/screens/components/copy_text_field.dart';
import 'package:flutter/material.dart';

class SmsDetailsField extends StatelessWidget {
  final SMSQr sms;
  final Function(String) onCopySms;
  final Function(String) onCopyPhone;

  const SmsDetailsField({
    super.key,
    required this.sms,
    required this.onCopySms,
    required this.onCopyPhone,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        CopyTextField(
          title: 'Phone',
          text: sms.number,
          onCopy: () => onCopyPhone(sms.number),
        ),
        const SizedBox(height: 8),
        CopyTextField(
          title: 'SMS',
          text: sms.message,
          onCopy: () => onCopySms(sms.message),
        ),
      ],
    );
  }
}
