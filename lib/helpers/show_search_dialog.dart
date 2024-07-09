import 'package:better_scanner/models/qr_record_model.dart';
import 'package:better_scanner/screens/search_screen/search_screen_view.dart';
import 'package:flutter/material.dart';

Future<RecordSearchIntent?> showSearchDialog(BuildContext context,
    {required List<QrRecordModel> records, bool fullScreen = false}) {
  return showDialog(
    context: context,
    builder: (context) {
      return fullScreen
          ? Dialog.fullscreen(
              child: SearchScreenView(
                records: records,
              ),
            )
          : Dialog(
              child: SearchScreenView(
                records: records,
              ),
            );
    },
  );
}
