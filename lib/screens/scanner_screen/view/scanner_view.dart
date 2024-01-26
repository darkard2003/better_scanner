import 'package:better_scanner/models/qr_record_model.dart';
import 'package:better_scanner/screens/scanner_screen/bloc/scanner_bloc.dart';
import 'package:better_scanner/screens/scanner_screen/view/components/record_list_view.dart';
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

  @override
  Widget build(BuildContext context) {
    var controller = MobileScannerController(
      detectionSpeed: DetectionSpeed.noDuplicates,
    );
    if (state.msg != null) {
      WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
        state.msg?.show(context);
      });
    }

    return Scaffold(
      appBar: AppBar(
        leading: Image.asset('assets/images/icon.png'),
        title: const Text('Better Scanner'),
        centerTitle: true,
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
              const SliverAppBar(
                title: Text(
                  'History',
                ),
                floating: true,
                snap: true,
                leading: Icon(Icons.history),
                actions: [
                  Padding(
                    padding: EdgeInsets.only(right: 16),
                    child: Icon(Icons.search),
                  ),
                ],
                backgroundColor: Colors.transparent,
                centerTitle: true,
              ),
              RecordListViewSliver(
                records: state.qrCodes,
                onTap: (record) {
                  _onTap(record, context);
                },
              ),
            ]),
          )),
        ],
      ),
    );
  }
}
