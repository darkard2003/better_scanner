import 'package:better_scanner/models/qr_record_model.dart';
import 'package:better_scanner/models/qr_type.dart';
import 'package:better_scanner/screens/scanner_screen/bloc/scanner_bloc.dart';
import 'package:better_scanner/screens/scanner_screen/view/components/rename_dialog.dart';
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
    var scannerBloc = BlocProvider.of<ScannerBloc>(context);
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
                        scannerBloc.add(ScannerEventEdit(record));
                        break;
                      case RecordAction.delete:
                        scannerBloc.add(ScannerEventDelete(record));
                        break;
                      case RecordAction.share:
                        scannerBloc.add(ScannerEventShare(record));
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
            onTap: () => context.read<ScannerBloc>().add(ScannerEventOnTap(record)),
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
                foregroundColor: MaterialStateProperty.all(
                  record.canOpen
                      ? Theme.of(context).colorScheme.primary
                      : Theme.of(context).colorScheme.onSurface,
                ),
                shape: MaterialStateProperty.all(
                  const RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(Radius.circular(8)),
                    // side: BorderSide(color: Colors.grey),
                  ),
                ),
                shadowColor: MaterialStateProperty.all(
                    Theme.of(context).colorScheme.shadow),
                elevation: MaterialStateProperty.all(3),
                backgroundColor: MaterialStateProperty.all(
                    Theme.of(context).colorScheme.primaryContainer),
              ),
              onPressed: () {
                if (record.canOpen) {
                  scannerBloc.add(ScannerEventOpenUrl(record));
                  return;
                }
                scannerBloc.add(ScannerEventCopy(record));
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
