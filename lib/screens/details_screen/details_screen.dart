import 'package:better_scanner/models/qr_models.dart';
import 'package:better_scanner/screens/components/copy_text_box.dart';
import 'package:better_scanner/screens/components/custom_icon_button.dart';
import 'package:better_scanner/screens/components/shareable_qr_preview.dart';
import 'package:better_scanner/screens/details_screen/maps_details_field.dart';
import 'package:better_scanner/screens/details_screen/wifi_details_field.dart';
import 'package:better_scanner/screens/shared/show_snackbar.dart';
import 'package:better_scanner/services/qr_services/qr_services.dart';
import 'package:flutter/material.dart';

import '../../models/qr_record_model.dart';

class DetailsScreen extends StatelessWidget {
  const DetailsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    var args =
        ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;
    var qr = args['qr'] as QrRecordModel;

    var theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(qr.displayName),
      ),
      body: ListView(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        children: [
          Padding(
            padding: const EdgeInsets.all(20),
            child: SharableQrPreview(
                qr: qr,
                onShare: (bytes) async {
                  await QrServices.shareImage(bytes, qr.displayName);
                }),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CustomIconButton(
                icon: Icon(
                  Icons.copy,
                  color: theme.colorScheme.onPrimary,
                ),
                onPressed: () async {
                  await QrServices.copyTextToClipboard(qr.copyData);
                  if (!context.mounted) return;
                  showSnackbar(context, "Qr Copied to clipboard");
                },
              ),
              const SizedBox(width: 16),
              if (qr.canOpen) ...[
                CustomIconButton(
                  icon: Icon(
                    Icons.launch,
                    color: theme.colorScheme.onPrimary,
                  ),
                  onPressed: () async {
                    await QrServices.launch(qr);
                  },
                ),
                const SizedBox(width: 16),
              ],
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
          const SizedBox(
            height: 20,
          ),
          if (qr.runtimeType == WifiCredQr)
            Padding(
              padding: const EdgeInsets.only(bottom: 20),
              child: WifiDetailsField(
                wifi: qr as WifiCredQr,
                onCopySsid: () async {
                  await QrServices.copyTextToClipboard(qr.ssid);
                  if (!context.mounted) return;
                  showSnackbar(context, "SSID copied to clipbard");
                },
                onCopyPassword: () async {
                  await QrServices.copyTextToClipboard(qr.password);
                  if (!context.mounted) return;
                  showSnackbar(context, "Password copied to clipbard");
                },
              ),
            )
          else if (qr.runtimeType == GeoLocationQr)
            Padding(
              padding: const EdgeInsets.only(bottom: 20),
              child: GeoDetailsField(
                geo: qr as GeoLocationQr,
                onCopyLat: (lat) async {
                  await QrServices.copyTextToClipboard(lat);
                  if (!context.mounted) return;
                  showSnackbar(context, "Latitude copied to clipbard");
                },
                onCopyLong: (long) async {
                  await QrServices.copyTextToClipboard(long);
                  if (!context.mounted) return;
                  showSnackbar(context, "Longitude copied to clipbard");
                },
                onCopyLatLong: (latLong) async {
                  await QrServices.copyTextToClipboard(latLong);
                  if (!context.mounted) return;
                  showSnackbar(
                      context, "Latitude and Longitude copied to clipbard");
                },
              ),
            ),
          CopyTextBox(
            text: qr.data,
            onCopy: () async {
              await QrServices.copyTextToClipboard(qr.data);
              if (!context.mounted) return;
              showSnackbar(context, "Qr Copied to clipboard");
            },
          ),
        ],
      ),
    );
  }
}
