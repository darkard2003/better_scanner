import 'package:better_scanner/screens/scanner_screen/bloc/scanner_bloc.dart';
import 'package:better_scanner/screens/scanner_screen/view/components/record_list_view.dart';
import 'package:better_scanner/screens/shared/show_snackbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'components/scan_window.dart';

class ScannerView extends StatefulWidget {
  final ScannerScreenState state;
  const ScannerView({super.key, required this.state});

  @override
  State<ScannerView> createState() => _ScannerViewState();
}

class _ScannerViewState extends State<ScannerView> {
  @override
  void initState() {
    super.initState();
    if (widget.state.msg != null) {
      WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
        widget.state.msg?.show(context);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        return Scaffold(
          appBar: AppBar(
            leading: Image.asset('assets/images/icon.png'),
            title: const Text('Better Scanner'),
            centerTitle: true,
          ),
          body: constraints.maxWidth < 700
              ? Column(
                  children: [
                    const ScanView(),
                    Expanded(child: HistoryView(state: widget.state)),
                  ],
                )
              : Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const ScanView(),
                    Expanded(child: HistoryView(state: widget.state)),
                  ],
                ),
        );
      },
    );
  }
}

class ScanView extends StatelessWidget {
  const ScanView({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: ScanWindow(
        onDetect: (record) {
          BlocProvider.of<ScannerBloc>(context).add(ScannerEventScan(record));
        },
      ),
    );
  }
}

class HistoryView extends StatelessWidget {
  const HistoryView({
    super.key,
    required this.state,
  });

  final ScannerScreenState state;

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: const BoxConstraints(maxWidth: 700),
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
            // _onTap(record, context);
          },
        ),
      ]),
    );
  }
}
