import 'package:better_scanner/models/qr_models.dart';
import 'package:better_scanner/screens/components/decorated_text_field.dart';
import 'package:flutter/material.dart';

class EmailQrGenerator extends StatefulWidget {
  final String qrString;
  final Function(String) onQrGenerated;
  const EmailQrGenerator({
    super.key,
    required this.qrString,
    required this.onQrGenerated,
  });

  @override
  State<EmailQrGenerator> createState() => _EmailQrGeneratorState();
}

class _EmailQrGeneratorState extends State<EmailQrGenerator> {
  late TextEditingController _emailController;
  late TextEditingController _subjectController;
  late TextEditingController _bodyController;

  @override
  void initState() {
    super.initState();
    var parts = EmailQr.parseEmailQrString(widget.qrString);
    _emailController = TextEditingController(
      text: parts.$1,
    );
    _subjectController = TextEditingController(
      text: parts.$2,
    );
    _bodyController = TextEditingController(
      text: parts.$3,
    );
  }

  void onChanged() {
    widget.onQrGenerated(EmailQr.getEmailQrString(
      _emailController.text,
      _subjectController.text,
      _bodyController.text,
    ));
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        DecoratedTextField(
          labelText: "Email",
          hintText: "Email",
          controller: _emailController,
          onChanged: (_) {
            onChanged();
          },
        ),
        const SizedBox(height: 8),
        DecoratedTextField(
          labelText: "Subject",
          hintText: "Subject",
          controller: _subjectController,
          onChanged: (_) {
            onChanged();
          },
        ),
        const SizedBox(height: 8),
        DecoratedTextField(
          labelText: "Body",
          hintText: "Body",
          controller: _bodyController,
          onChanged: (_) {
            onChanged();
          },
        ),
      ],
    );
  }
}
