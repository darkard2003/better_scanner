import 'package:better_scanner/screens/scanner_screen/bloc/scanner_bloc.dart';
import 'package:better_scanner/screens/scanner_screen/view/components/record_list_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'components/scan_window.dart';

class ScannerView extends StatelessWidget {
  final ScannerScreenState state;
  const ScannerView({super.key, required this.state});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Better Scanner'),
      ),
      body: Flex(
        direction: Axis.vertical,
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: ScanWindow(
              onDetect: (record) {
                BlocProvider.of<ScannerBloc>(context)
                    .add(ScannerEventScan(record));
              },
            ),
          ),
          Flexible(
              flex: 2,
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
                  RecordListViewSliver(records: state.qrCodes, onTap: (_) {}),
                ]),
              )),
        ],
      ),
    );
  }
}
