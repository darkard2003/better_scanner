import 'package:better_scanner/models/qr_record_model.dart';
import 'package:flutter/material.dart';

import '../screens/qr_generator_screen/qr_generator.dart';

Future<QrRecordModel?> showGeneratorDialog(
  BuildContext context, {
  bool fullScreen = false,
  QrRecordModel? record,
}) {
  return showDialog(
      context: context,
      builder: (context) {
        return fullScreen
            ? Dialog.fullscreen(
                child: QrGeneratorScreen(
                  qr: record,
                ),
              )
            : Dialog(
                child: QrGeneratorScreen(
                  qr: record,
                ),
              );
      });
}
