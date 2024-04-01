import 'package:better_scanner/models/qr_record_model.dart';
import 'package:better_scanner/screens/components/decorated_text_field.dart';
import 'package:flutter/material.dart';

class PlainTextQr extends StatefulWidget {
  final Function(QrRecordModel) onQrGenerated;
  const PlainTextQr({super.key, required this.onQrGenerated});

  @override
  State<PlainTextQr> createState() => _PlainTextQrState();
}

class _PlainTextQrState extends State<PlainTextQr> {
  QrRecordModel _qrRecord = QrRecordModel.fromText('');

  @override
  Widget build(BuildContext context) {
    return DecoratedTextField(
      hintText: 'Enter Text',
      labelText: 'Text',
      onChanged: (text) {
        setState(() {
          _qrRecord = QrRecordModel.fromText(text);
          widget.onQrGenerated(_qrRecord);
        });
      },
    );
  }
}

