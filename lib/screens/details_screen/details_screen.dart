import 'package:better_scanner/models/qr_models.dart';
import 'package:better_scanner/screens/components/copy_text_box.dart';
import 'package:better_scanner/screens/components/custom_icon_button.dart';
import 'package:better_scanner/screens/components/shareable_qr_preview.dart';
import 'package:better_scanner/screens/details_screen/components/email_details_screen.dart';
import 'package:better_scanner/screens/details_screen/components/maps_details_field.dart';
import 'package:better_scanner/screens/details_screen/components/phone_details_field.dart';
import 'package:better_scanner/screens/details_screen/components/sms_details_field.dart';
import 'package:better_scanner/screens/details_screen/components/wifi_details_field.dart';
import 'package:better_scanner/screens/shared/show_snackbar.dart';
import 'package:better_scanner/services/qr_services/qr_services.dart';
import 'package:flutter/material.dart';

import '../../models/qr_record_model.dart';

class DetailsScreen extends StatelessWidget {
  final QrRecordModel? qr;

  const DetailsScreen({
    super.key,
    this.qr,
  });

  @override
  Widget build(BuildContext context) {
    var args =
        ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>?;
    var qr = this.qr ?? args?['qr'] as QrRecordModel;

    var size = MediaQuery.of(context).size;
    var isSmallScreen = size.width < 700;

    var qrView = Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        SizedBox(
          width: 300,
          height: 300,
          child: SharableQrPreview(
              qr: qr,
              onShare: (bytes) async {
                await QrServices.shareImage(bytes, qr.displayName);
              }),
        ),
        const SizedBox(height: 16),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CustomIconButton(
              icon: const Icon(
                Icons.copy,
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
                icon: const Icon(
                  Icons.launch,
                ),
                onPressed: () async {
                  await QrServices.launch(qr);
                },
              ),
              const SizedBox(width: 16),
            ],
            CustomIconButton(
              icon: const Icon(
                Icons.share,
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
      ],
    );

    var detailsField = Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Builder(builder: (context) {
          if (qr.runtimeType == WifiCredQr) {
            return WifiDetailsField(
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
            );
          } else if (qr.runtimeType == GeoLocationQr) {
            return GeoDetailsField(
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
            );
          } else if (qr.runtimeType == PhoneQr) {
            return PhoneDetailsField(
              phone: qr as PhoneQr,
              onCopyPhone: (phone) async {
                await QrServices.copyTextToClipboard(phone);
                if (!context.mounted) return;
                showSnackbar(context, "Phone copied to clipbard");
              },
            );
          } else if (qr.runtimeType == SMSQr) {
            return SmsDetailsField(
              sms: qr as SMSQr,
              onCopySms: (sms) async {
                await QrServices.copyTextToClipboard(sms);
                if (!context.mounted) return;
                showSnackbar(context, "SMS copied to clipbard");
              },
              onCopyPhone: (phone) async {
                await QrServices.copyTextToClipboard(phone);
                if (!context.mounted) return;
                showSnackbar(context, "Phone copied to clipbard");
              },
            );
          } else if (qr.runtimeType == EmailQr) {
            return EmailDetailsField(
              email: qr as EmailQr,
              onCopyEmail: (email) async {
                await QrServices.copyTextToClipboard(email);
                if (!context.mounted) return;
                showSnackbar(context, "Email copied to clipbard");
              },
              onCopySubject: (subject) async {
                await QrServices.copyTextToClipboard(subject);
                if (!context.mounted) return;
                showSnackbar(context, "Subject copied to clipbard");
              },
              onCopyBody: (body) async {
                await QrServices.copyTextToClipboard(body);
                if (!context.mounted) return;
                showSnackbar(context, "Body copied to clipbard");
              },
            );
          } else {
            return const SizedBox();
          }
        }),
        if (qr.runtimeType != QrRecordModel) const SizedBox(height: 16),
        CopyTextBox(
          text: qr.data,
          onCopy: () async {
            await QrServices.copyTextToClipboard(qr.data);
            if (!context.mounted) return;
            showSnackbar(context, "Qr Copied to clipboard");
          },
        )
      ],
    );

    return ConstrainedBox(
      constraints: const BoxConstraints(
        maxWidth: 700,
      ),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const SizedBox(width: 10),
                Text(
                  qr.displayName,
                  style: Theme.of(context).textTheme.headlineSmall,
                ),
                const Spacer(),
                IconButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  icon: const Icon(Icons.close),
                ),
                const SizedBox(width: 10),
              ],
            ),
            const SizedBox(height: 16),
            isSmallScreen
                ? Expanded(
                    child: SingleChildScrollView(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          qrView,
                          detailsField,
                          const SizedBox(
                            height: 50,
                          ),
                        ],
                      ),
                    ),
                  )
                : Row(
                    children: [
                      qrView,
                      const SizedBox(width: 16),
                      Expanded(
                        child: SingleChildScrollView(
                          child: detailsField,
                        ),
                      ),
                    ],
                  ),
          ],
        ),
      ),
    );
  }
}
