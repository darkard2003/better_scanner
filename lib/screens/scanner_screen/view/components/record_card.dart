import 'package:better_scanner/models/qr_record_model.dart';
import 'package:better_scanner/models/qr_type.dart';
import 'package:better_scanner/screens/scanner_screen/bloc/scanner_bloc.dart';
import 'package:better_scanner/screens/scanner_screen/view/components/rename_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

enum RecordAction { rename, delete, share }

extension on RecordAction {
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
  const RecordCard({
    super.key,
    required this.record,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    var scannerBloc = BlocProvider.of<ScannerBloc>(context);
    return Slidable(
      key: ValueKey(record),
      startActionPane: ActionPane(
        motion: const ScrollMotion(),
        children: [
          SlidableAction(
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(8),
              bottomLeft: Radius.circular(8),
            ),
            onPressed: (context) async {
              var name = await showRenameDialog(context, record.name);
              if (name == null) return;
              scannerBloc.add(ScannerEventRename(record, name));
            },
            icon: RecordAction.rename.icon,
            backgroundColor: Colors.blue,
          ),
          SlidableAction(
            onPressed: (context) =>
                scannerBloc.add(ScannerEventOnShare(record)),
            icon: RecordAction.share.icon,
            backgroundColor: Colors.green,
          ),
          SlidableAction(
            borderRadius: const BorderRadius.only(
              topRight: Radius.circular(8),
              bottomRight: Radius.circular(8),
            ),
            onPressed: (context) => scannerBloc.add(ScannerEventDelete(record)),
            icon: RecordAction.delete.icon,
            backgroundColor: Colors.red,
          ),
        ],
      ),
      child: Card(
        child: ListTile(
          leading: Icon(record.type.icon),
          onTap: () => onTap(record),
          title: Text(record.name.isEmpty ? record.displayName : record.name),
          subtitle: Text(record.displayData),
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
