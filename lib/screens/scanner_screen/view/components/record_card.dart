import 'package:better_scanner/models/qr_record_model.dart';
import 'package:better_scanner/models/qr_type.dart';
import 'package:better_scanner/screens/scanner_screen/view/components/record_action.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

class RecordCard extends StatelessWidget {
  final QrRecordModel record;
  final Function(QrRecordModel) onTap;
  final Function(QrRecordModel) onEdit;
  final Function(QrRecordModel) onDelete;
  final Function(QrRecordModel) onShare;
  final Function(QrRecordModel) shortcutAction;

  const RecordCard({
    super.key,
    required this.record,
    required this.onTap,
    required this.onEdit,
    required this.onDelete,
    required this.onShare,
    required this.shortcutAction,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      elevation: 3,
      child: Slidable(
        key: ValueKey(record),
        startActionPane: ActionPane(
          motion: const BehindMotion(),
          children: [
            SlidableAction(
              onPressed: (context) => onEdit(record),
              icon: RecordAction.edit.icon,
              backgroundColor: Theme.of(context).colorScheme.primaryContainer,
              foregroundColor: RecordAction.edit.foregroundColor,
            ),
            SlidableAction(
              onPressed: (context) => onDelete(record),
              icon: RecordAction.delete.icon,
              backgroundColor: Theme.of(context).colorScheme.primaryContainer,
              foregroundColor: RecordAction.delete.foregroundColor,
            ),
            SlidableAction(
              onPressed: (context) => onShare(record),
              icon: RecordAction.share.icon,
              backgroundColor: Theme.of(context).colorScheme.primaryContainer,
              foregroundColor: RecordAction.share.foregroundColor,
            ),
          ],
        ),
        child: ListTile(
            leading: Icon(record.type.icon),
            onTap: () => onTap(record),
            title: Text(
              record.name.isEmpty ? record.displayName : record.name,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
            subtitle: Text(
              record.displayData,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
            trailing: IconButton(
              style: ButtonStyle(
                foregroundColor: WidgetStateProperty.all(
                  record.canOpen
                      ? Theme.of(context).colorScheme.primary
                      : Theme.of(context).colorScheme.onSurface,
                ),
                shape: WidgetStateProperty.all(
                  const RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(Radius.circular(8)),
                    // side: BorderSide(color: Colors.grey),
                  ),
                ),
                shadowColor: WidgetStateProperty.all(
                    Theme.of(context).colorScheme.shadow),
                elevation: WidgetStateProperty.all(3),
                backgroundColor: WidgetStateProperty.all(
                    Theme.of(context).colorScheme.primaryContainer),
              ),
              onPressed:()  => shortcutAction(record),
              icon: record.canOpen
                  ? const Icon(Icons.open_in_new)
                  : const Icon(Icons.copy),
            )),
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
      case QrType.geo:
        return Icons.location_on;
      case QrType.phone:
        return Icons.phone;
      case QrType.sms:
        return Icons.sms;
      case QrType.email:
        return Icons.email;
      case QrType.contact:
        return Icons.contact_page;
      case QrType.calendar:
        return Icons.calendar_today;
      case QrType.event:
        return Icons.event;
    }
  }
}
