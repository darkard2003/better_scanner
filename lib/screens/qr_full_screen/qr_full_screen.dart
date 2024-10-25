import 'package:better_scanner/models/qr_record_model.dart';
import 'package:flutter/material.dart';
import 'package:pretty_qr_code/pretty_qr_code.dart';

class QrFullScreen extends StatelessWidget {
  final QrRecordModel qr;
  const QrFullScreen({
    super.key,
    required this.qr,
  });

  @override
  Widget build(BuildContext context) {
    var qrcode = QrCode.fromData(
        data: qr.data, errorCorrectLevel: QrErrorCorrectLevel.H);
    var image = QrImage(qrcode);

    return Scaffold(
      appBar: AppBar(
        title: Text(qr.name),
      ),
      body: Center(
        child: Hero(
          tag: qr.data,
          child: Container(
            padding: const EdgeInsets.all(20),
            margin: const EdgeInsets.all(30),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(10),
              border: Border.all(
                color: Theme.of(context).colorScheme.onSurface,
              ),
            ),
            child: PrettyQrView(qrImage: image),
          ),
        ),
      ),
    );
  }
}
