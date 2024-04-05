import 'package:better_scanner/screens/components/custom_icon_button.dart';
import 'package:better_scanner/screens/shared/show_snackbar.dart';
import 'package:better_scanner/services/qr_services/qr_services.dart';
import 'package:flutter/material.dart';
import 'package:pretty_qr_code/pretty_qr_code.dart';

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
              color: Colors.white,
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
                        await QrServices.shareQrImage(qr);
                      },
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              CustomIconButton(
                icon: Icon(
                  Icons.copy,
                  color: theme.colorScheme.onPrimary,
                ),
                onPressed: () async {
                  await QrServices.copyToClipboard(qr);
                  if (!context.mounted) return;
                  showSnackbar(context, "Qr Copied to clipboard");
                },
              ),
              if (qr.canOpen)
                CustomIconButton(
                  icon: Icon(
                    Icons.launch,
                    color: theme.colorScheme.onPrimary,
                  ),
                  onPressed: () async {
                    await QrServices.launch(qr);
                  },
                ),
              CustomIconButton(
                icon: Icon(
                  Icons.share,
                  color: theme.colorScheme.onPrimary,
                ),
                onPressed: () async {
                  await QrServices.shareQrText(qr);
                },
              ),
            ],
          ),
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
