import 'package:better_scanner/models/qr_record_model.dart';
import 'package:better_scanner/models/qr_type.dart';
import 'package:better_scanner/screens/scanner_screen/scanner_screen_vm.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

enum RecordAction {
  rename,
  share,
  delete,
}

extension on RecordAction {
  Color? get foregroundColor {
    if (this == RecordAction.delete) {
      return Colors.red;
    }
    return null;
  }

  IconData get icon {
    switch (this) {
      case RecordAction.rename:
        return Icons.edit_outlined;
      case RecordAction.delete:
        return Icons.delete_outlined;
      case RecordAction.share:
        return Icons.share_outlined;
      default:
        return Icons.edit;
    }
  }
}

class RecordCard extends StatelessWidget {
  final QrRecordModel record;
  const RecordCard({
    super.key,
    required this.record,
  });

  @override
  Widget build(BuildContext context) {
    var vm = context.read<ScannerScreenVM>();
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      elevation: 3,
      child: Slidable(
        key: ValueKey(record),
        startActionPane: ActionPane(
          motion: const BehindMotion(),
          children: RecordAction.values
              .map(
                (action) => SlidableAction(
                  onPressed: (context) {
                    switch (action) {
                      case RecordAction.rename:
                        vm.onEdit(record);
                        break;
                      case RecordAction.delete:
                        vm.onDelete(record);
                        break;
                      case RecordAction.share:
                        vm.onShare(record);
                        break;
                    }
                  },
                  icon: action.icon,
                  backgroundColor:
                      Theme.of(context).colorScheme.primaryContainer,
                  foregroundColor: action.foregroundColor,
                ),
              )
              .toList(),
        ),
        child: ListTile(
            leading: Icon(record.type.icon),
            onTap: () => vm.onTap(record),
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
              onPressed: () {
                if (record.canOpen) {
                  vm.openUrl(record);
                  return;
                }
                vm.onCopy(record);
              },
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
      default:
        return Icons.text_fields;
    }
  }
}
