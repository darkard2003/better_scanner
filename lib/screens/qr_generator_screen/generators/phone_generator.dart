import 'package:better_scanner/models/qr_models.dart';
import 'package:better_scanner/screens/components/decorated_text_field.dart';
import 'package:better_scanner/screens/shared/show_snackbar.dart';
import 'package:flutter/material.dart';

class PhoneQrGenerator extends StatefulWidget {
  final Function(String) onQrGenerated;
  final String phoneQr;
  const PhoneQrGenerator({
    super.key,
    required this.onQrGenerated,
    required this.phoneQr,
  });

  @override
  State<PhoneQrGenerator> createState() => _PhoneQrGeneratorState();
}

class _PhoneQrGeneratorState extends State<PhoneQrGenerator> {
  late TextEditingController phoneController;

  @override
  void initState() {
    super.initState();
    var phone = '';
    try {
      phone = PhoneQr.parsePhoneQrString(widget.phoneQr);
    } catch (e) {
      showSnackbar(context, "Faild to parse qr", type: SnackbarType.error);
    }
    phoneController = TextEditingController(text: phone);
  }

  @override
  void dispose() {
    phoneController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return DecoratedTextField(
      controller: phoneController,
      keyboardType: TextInputType.phone,
      hintText: "+121234",
      labelText: "Phone",
      onChanged: (_) {
        widget.onQrGenerated(PhoneQr.getPhoneQrString(phoneController.text));
      },
    );
  }
}
