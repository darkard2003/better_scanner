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
          const SizedBox(height: 16),
          Flexible(
            flex: 1,
            child: ScanWindow(
              onDetect: (record) {
                BlocProvider.of<ScannerBloc>(context)
                    .add(ScannerEventScan(record));
              },
            ),
          ),
          const SizedBox(height: 16),
          Flexible(
              flex: 2,
              child: CustomScrollView(slivers: [
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      'Scanned codes: ${state.qrCodes.length}',
                      style: Theme.of(context).textTheme.headlineLarge,
                    ),
                  ),
                ),
                RecordListViewSliver(records: state.qrCodes, onTap: (_) {}),
              ])),
        ],
      ),
    );
  }
}
