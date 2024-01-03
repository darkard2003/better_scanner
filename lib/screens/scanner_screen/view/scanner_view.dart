import 'package:better_scanner/models/qr_record_model.dart';
import 'package:better_scanner/screens/scanner_screen/bloc/scanner_bloc.dart';
import 'package:better_scanner/screens/scanner_screen/view/components/record_list_view.dart';
import 'package:better_scanner/screens/scanner_screen/view/components/rename_dialog.dart';
import 'package:better_scanner/screens/shared/show_snackbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mobile_scanner/mobile_scanner.dart';

import 'components/scan_window.dart';

class ScannerView extends StatelessWidget {
  final ScannerScreenState state;
  const ScannerView({super.key, required this.state});

  void _onTap(QrRecordModel record, BuildContext context) async {
    BlocProvider.of<ScannerBloc>(context).add(ScannerEventOnTap(record));
  }

  void _onLongPress(QrRecordModel record, BuildContext context) async {
    BlocProvider.of<ScannerBloc>(context).add(ScannerEventOnLongPress(record));
    showSnackbar(context, 'Copied to clipboard');
  }

  void _onRename(QrRecordModel record, BuildContext context) async {
    var name = await showRenameDialog(context, record.name);
    if (name == null) return;
    if (!context.mounted) return;
    BlocProvider.of<ScannerBloc>(context).add(ScannerEventRename(record, name));
  }

  void _onDelete(QrRecordModel record, BuildContext context) async {
    BlocProvider.of<ScannerBloc>(context).add(ScannerEventDelete(record));
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Deleted ${record.data}'),
        action: SnackBarAction(
          label: 'Undo',
          onPressed: () {
            BlocProvider.of<ScannerBloc>(context).add(ScannerEventScan(record));
          },
        ),
      ),
    );
  }

  void _onShare(QrRecordModel record, BuildContext context) async {
    BlocProvider.of<ScannerBloc>(context).add(ScannerEventOnShare(record));
  }

  @override
  Widget build(BuildContext context) {
    var controller = MobileScannerController(
      detectionSpeed: DetectionSpeed.noDuplicates,
    );
    if (state.msg != null) {
      WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(state.msg!),
          ),
        );
      });
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Better Scanner'),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: ScanWindow(
              controller: controller,
              onDetect: (record) {
                BlocProvider.of<ScannerBloc>(context)
                    .add(ScannerEventScan(record));
              },
            ),
          ),
          Expanded(
              child: Container(
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.surfaceVariant,
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(16),
                topRight: Radius.circular(16),
              ),
            ),
            child: CustomScrollView(slivers: [
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    'History',
                    style: Theme.of(context).textTheme.headlineLarge,
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
              RecordListViewSliver(
                records: state.qrCodes,
                onTap: (record) {
                  _onTap(record, context);
                },
                onLongPress: (record) {
                  _onLongPress(record, context);
                },
                onDelete: (record) {
                  _onDelete(record, context);
                },
                onRename: (record) {
                  _onRename(record, context);
                },
                onShare: (record) {
                  _onShare(record, context);
                },
              ),
            ]),
          )),
        ],
      ),
    );
  }
}
