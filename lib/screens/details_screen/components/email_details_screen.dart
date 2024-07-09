import 'package:better_scanner/models/qr_models.dart';
import 'package:better_scanner/screens/components/copy_text_field.dart';
import 'package:flutter/material.dart';

class EmailDetailsField extends StatelessWidget {
  final EmailQr email;
  final Function(String) onCopyEmail;
  final Function(String) onCopySubject;
  final Function(String) onCopyBody;

  const EmailDetailsField({
    super.key,
    required this.email,
    required this.onCopyEmail,
    required this.onCopySubject,
    required this.onCopyBody,
  });

  @override
  Widget build(BuildContext context) {
    return Column(mainAxisSize: MainAxisSize.min, children: [
      CopyTextField(
        title: "Email",
        text: email.address,
        onCopy: () => onCopyEmail(email.address),
      ),
      const SizedBox(height: 8),
      CopyTextField(
        title: "Subject",
        text: email.subject,
        onCopy: () => onCopySubject(email.subject),
      ),
      const SizedBox(height: 8),
      CopyTextField(
        title: "Body",
        text: email.body,
        onCopy: () => onCopyBody(email.body),
      ),
    ]);
  }
}
