import 'package:better_scanner/models/qr_record_model.dart';
import 'package:better_scanner/models/qr_type.dart';
import 'package:better_scanner/services/qr_extraction_service.dart';
import 'package:flutter/material.dart';

enum RecordAction { rename, delete, share }

extension on RecordAction {
  String get label {
    switch (this) {
      case RecordAction.rename:
        return 'Rename';
      case RecordAction.delete:
        return 'Delete';
      case RecordAction.share:
        return 'Share';
      default:
        return '';
    }
  }

  IconData get icon {
    switch (this) {
      case RecordAction.rename:
        return Icons.edit;
      case RecordAction.delete:
        return Icons.delete;
      case RecordAction.share:
        return Icons.share;
      default:
        return Icons.edit;
    }
  }
}

class RecordCard extends StatelessWidget {
  final QrRecordModel record;
  final Function(QrRecordModel record) onTap;
  final Function(QrRecordModel record) onLongPress;
  final Function(QrRecordModel record) onDelete;
  final Function(QrRecordModel record) onRename;
  final Function(QrRecordModel record) onShare;
  const RecordCard({
    super.key,
    required this.record,
    required this.onTap,
    required this.onLongPress,
    required this.onDelete,
    required this.onRename,
    required this.onShare,
  });

  @override
  Widget build(BuildContext context) {
    return Dismissible(
      key: ValueKey(record),
      onDismissed: (_) => onDelete(record),
      child: Card(
        child: ListTile(
          leading: Icon(record.type.icon),
          onTap: () => onTap(record),
          onLongPress: () => onLongPress(record),
          title: Text(record.name.isEmpty ? record.displayName : record.name),
          subtitle: Text(record.displayData),
          trailing: PopupMenuButton<RecordAction>(
            onSelected: (action) {
              switch (action) {
                case RecordAction.rename:
                  onRename(record);
                  break;
                case RecordAction.delete:
                  onDelete(record);
                  break;
                case RecordAction.share:
                  onShare(record);
                  break;
                default:
                  break;
              }
            },
            itemBuilder: (context) {
              return RecordAction.values.map((action) {
                return PopupMenuItem<RecordAction>(
                  value: action,
                  child: Row(
                    children: [
                      Icon(action.icon),
                      const SizedBox(width: 8),
                      Text(action.label),
                    ],
                  ),
                );
              }).toList();
            },
          ),
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
