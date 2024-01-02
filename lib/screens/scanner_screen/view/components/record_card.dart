import 'package:better_scanner/models/qr_record_model.dart';
import 'package:better_scanner/models/qr_type.dart';
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
        leading: Icon(record.type.icon),
        onTap: () => onTap(record),
        onLongPress: onLongPress == null ? null : () => onLongPress!(record),
        title: Text(record.name.isEmpty ? 'No name' : record.name),
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

extension on QrType {
  IconData get icon {
    switch (this) {
      case QrType.url:
        return Icons.link;
      case QrType.text:
        return Icons.text_fields;
      case QrType.wifi:
        return Icons.wifi;
      case QrType.unknown:
        return Icons.text_fields;
      default:
        return Icons.text_fields;
    }
  }
}
