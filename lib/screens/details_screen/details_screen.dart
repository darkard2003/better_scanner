import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:pretty_qr_code/pretty_qr_code.dart';
import 'package:share_plus/share_plus.dart';

import '../../models/qr_record_model.dart';

class DetailsScreen extends StatelessWidget {
  const DetailsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    var args =
        ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;
    var qr = args['qr'] as QrRecordModel;

    var size = MediaQuery.of(context).size;

    var qrCode = QrCode.fromData(
      data: qr.data,
      errorCorrectLevel: QrErrorCorrectLevel.H,
    );

    var qrImage = QrImage(qrCode);

    var theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(qr.displayName),
      ),
      body: ListView(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        children: [
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 32),
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: theme.colorScheme.onSurface,
              borderRadius: BorderRadius.circular(16),
            ),
            child: Stack(
              children: [
                PrettyQrView(
                  qrImage: qrImage,
                ),
                Positioned(
                  bottom: 0,
                  right: 0,
                  child: DecoratedBox(
                    decoration: BoxDecoration(
                      color: theme.colorScheme.onSurface.withOpacity(0.5),
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: IconButton(
                      icon: Icon(
                        Icons.share,
                        color: theme.colorScheme.surface,
                      ),
                      onPressed: () async {
                        var image = await qrImage.toImage(
                          size: 800,
                          decoration: const PrettyQrDecoration(
                            background: Colors.white,
                            image: PrettyQrDecorationImage(
                              image: AssetImage('assets/images/icon.png'),
                            ),
                          ),
                        );
                        var byte = await image.toByteData(
                          format: ImageByteFormat.png,
                        );
                        var xFile = XFile.fromData(
                          byte!.buffer.asUint8List(),
                          mimeType: 'image/png',
                          name: '${qr.displayName}.png',
                        );
                        Share.shareXFiles(
                          [xFile],
                          subject: qr.displayName,
                        );
                      },
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          Container(
            decoration: BoxDecoration(
              border: Border.all(
                  width: 1,
                  color: Theme.of(context).colorScheme.onSurface,
                  style: BorderStyle.solid),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                qr.data,
                maxLines: 5,
                style: const TextStyle(
                  fontFamily: 'monospace',
                  fontSize: 16,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

