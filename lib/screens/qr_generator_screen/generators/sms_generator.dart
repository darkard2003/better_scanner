import 'package:better_scanner/models/qr_models.dart';
import 'package:better_scanner/screens/components/decorated_text_field.dart';
import 'package:better_scanner/screens/shared/show_snackbar.dart';
import 'package:flutter/material.dart';

class SMSQrGenerator extends StatefulWidget {
  final Function(String) onQrGenerated;
  final String smsQr;
  const SMSQrGenerator({
    super.key,
    required this.onQrGenerated,
    required this.smsQr,
  });

  @override
  State<SMSQrGenerator> createState() => _SMSQrGeneratorState();
}

class _SMSQrGeneratorState extends State<SMSQrGenerator> {
  late TextEditingController smsController;
  late TextEditingController phoneController;

  @override
  void initState() {
    super.initState();
    var sms = '';
    var phone = '';
    try {
      var parts = SMSQr.parseSmsQrString(widget.smsQr);
      sms = parts.$2;
      phone = parts.$1;
    } catch (e) {
      showSnackbar(context, "Faild to parse qr", type: SnackbarType.error);
    }
    smsController = TextEditingController(text: sms);
    phoneController = TextEditingController(text: phone);
  }

  @override
  void dispose() {
    smsController.dispose();
    phoneController.dispose();
    super.dispose();
  }

  void onChanged() {
    widget.onQrGenerated(SMSQr.getSmsQrString(
      phoneController.text,
      smsController.text,
    ));
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        DecoratedTextField(
          controller: phoneController,
          keyboardType: TextInputType.phone,
          hintText: '+121234',
          labelText: 'Phone',
          onChanged: (_) => onChanged(),
        ),
        const SizedBox(height: 8),
        DecoratedTextField(
          controller: smsController,
          hintText: 'SMS',
          labelText: 'SMS',
          onChanged: (_) => onChanged(),
        ),
      ],
    );
  }
}
