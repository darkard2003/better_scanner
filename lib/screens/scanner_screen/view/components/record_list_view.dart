import 'package:better_scanner/models/qr_record_model.dart';
import 'package:better_scanner/screens/scanner_screen/view/components/record_card.dart';
import 'package:flutter/material.dart';

class RecordListViewSliver extends StatelessWidget {
  final List<QrRecordModel> records;
  final Function(QrRecordModel) onTap;
  final Function(QrRecordModel) onEdit;
  final Function(QrRecordModel) onDelete;
  final Function(QrRecordModel) onShare;
  final Function(QrRecordModel) shortcutAction;

  const RecordListViewSliver({
    super.key,
    required this.records,
    required this.onTap,
    required this.onEdit,
    required this.onDelete,
    required this.onShare,
    required this.shortcutAction,
  });

  @override
  Widget build(BuildContext context) {
    return SliverList.builder(
      itemBuilder: (context, i) => RecordCard(
        record: records[i],
        onTap: onTap,
        onEdit: onEdit,
        onDelete: onDelete,
        onShare: onShare,
        shortcutAction: shortcutAction,
      ),
      itemCount: records.length,
    );
  }
}
