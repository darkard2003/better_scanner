import 'dart:typed_data';
import 'dart:ui';

import 'package:better_scanner/models/qr_record_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:pretty_qr_code/pretty_qr_code.dart';

class SharableQrPreview extends StatefulWidget {
  final QrRecordModel qr;
  final Function(ByteBuffer byteBuffer) onShare;
  const SharableQrPreview({super.key, required this.qr, required this.onShare});

  @override
  State<SharableQrPreview> createState() => _SharableQrPreviewState();
}

class _SharableQrPreviewState extends State<SharableQrPreview> {
  static GlobalKey qrKey = GlobalKey();
  Future<void> takeScreenShot() async {
    RenderRepaintBoundary boundary =
        qrKey.currentContext!.findRenderObject() as RenderRepaintBoundary;
    var image = await boundary.toImage();
    ByteData? byteData = await image.toByteData(format: ImageByteFormat.png);
    Uint8List pngBytes = byteData!.buffer.asUint8List();
    widget.onShare(pngBytes.buffer);
  }

  @override
  Widget build(BuildContext context) {
    var qrCode = QrCode.fromData(
        data: widget.qr.data, errorCorrectLevel: QrErrorCorrectLevel.H);
    var qrImage = QrImage(qrCode);
    return Stack(
      children: [
        RepaintBoundary(
          key: qrKey,
          child: Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(10),
              border:
                  Border.all(color: Theme.of(context).colorScheme.onSurface),
            ),
            padding: const EdgeInsets.all(20),
            child: PrettyQrView(
              qrImage: qrImage,
            ),
          ),
        ),
        Positioned(
          bottom: 20,
          right: 20,
          child: DecoratedBox(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(10),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.2),
                  blurRadius: 10,
                  spreadRadius: 2,
                )
              ],
            ),
            child: IconButton(
              onPressed: takeScreenShot,
              icon: const Icon(
                Icons.share,
                color: Colors.black,
              ),
            ),
          ),
        )
      ],
    );
  }
}
