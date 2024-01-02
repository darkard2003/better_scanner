import 'package:better_scanner/models/qr_record_model.dart';
import 'package:flutter/material.dart';

class RecordCard extends StatelessWidget {
  final QrRecordModel record;
  final Function(QrRecordModel record) onTap;
  final Function(QrRecordModel record)? onLongPress;
  final Function(QrRecordModel record)? onOptions;
  const RecordCard(
      {super.key,
      required this.record,
      required this.onTap,
      this.onLongPress,
      this.onOptions});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        onTap: () => onTap(record),
        onLongPress: onLongPress == null ? null : () => onLongPress!(record),
        title: record.name.isEmpty ? null : Text(record.name),
        subtitle: Text(record.data),
        trailing: onOptions == null
            ? null
            : IconButton(
                icon: const Icon(Icons.more_vert),
                onPressed: () => onOptions!(record),
              ),
      ),
    );
  }
}
