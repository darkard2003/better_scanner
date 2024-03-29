import 'package:better_scanner/models/qr_record_model.dart';
import 'package:better_scanner/screens/scanner_screen/view/components/record_card.dart';
import 'package:flutter/material.dart';

class RecordListViewSliver extends StatelessWidget {
  final List<QrRecordModel> records;
  final Function(QrRecordModel record) onTap;

  const RecordListViewSliver({
    super.key,
    required this.records,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return SliverList.builder(
      itemBuilder: (context, i) => RecordCard(
        record: records[i],
        onTap: onTap,
      ),
      itemCount: records.length,
    );
  }
}
