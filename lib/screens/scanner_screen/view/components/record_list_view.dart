import 'package:better_scanner/models/qr_record_model.dart';
import 'package:better_scanner/screens/scanner_screen/view/components/record_card.dart';
import 'package:flutter/material.dart';

class RecordListViewSliver extends StatelessWidget {
  final List<QrRecordModel> records;
  final Function(QrRecordModel record) onTap;
  final Function(QrRecordModel record) onLongPress;
  final Function(QrRecordModel record) onRename;
  final Function(QrRecordModel record) onDelete;
  final Function(QrRecordModel record) onShare;

  const RecordListViewSliver({
    super.key,
    required this.records,
    required this.onTap,
    required this.onLongPress,
    required this.onRename,
    required this.onDelete,
    required this.onShare, 
  });

  @override
  Widget build(BuildContext context) {
    return SliverList.builder(
      itemBuilder: (context, i) => RecordCard(
        record: records[i],
        onTap: onTap,
        onLongPress: onLongPress,
        onDelete: onDelete,
        onRename: onRename,
        onShare: onShare,
      ),
      itemCount: records.length,
    );
  }
}
