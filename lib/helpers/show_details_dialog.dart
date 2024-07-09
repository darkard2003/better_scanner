import 'package:better_scanner/models/qr_record_model.dart';
import 'package:better_scanner/screens/details_screen/details_screen.dart';
import 'package:flutter/material.dart';

Future<void> showDetailsDialog(
  BuildContext context, {
  required QrRecordModel record,
  bool fullScreen = false,
}) {
  return showDialog(
      context: context,
      builder: (context) {
        return fullScreen
            ? Dialog.fullscreen(
                child: DetailsScreen(
                  qr: record,
                ),
              )
            : Dialog(
                child: DetailsScreen(
                  qr: record,
                ),
              );
      });
}
