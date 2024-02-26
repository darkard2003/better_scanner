import 'package:better_scanner/screens/scanner_screen/bloc/scanner_bloc.dart';
import 'package:better_scanner/screens/scanner_screen/view/components/record_list_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mobile_scanner/mobile_scanner.dart';

import 'components/scan_window.dart';

class ScannerView extends StatefulWidget {
  final ScannerScreenState state;
  const ScannerView({super.key, required this.state});

  @override
  State<ScannerView> createState() => _ScannerViewState();
}

class _ScannerViewState extends State<ScannerView> {
  late MobileScannerController _controller;
  bool _cameraEnabled = true;

  @override
  void initState() {
    super.initState();
    _controller = MobileScannerController(
      facing: CameraFacing.back,
    );
  }

  List<Widget> _buildActions() {
    return [
      // Camera enable/disable
      IconButton(
        icon: Icon(
          _cameraEnabled ? Icons.camera_alt : Icons.camera_alt_outlined,
        ),
        onPressed: () {
          _cameraEnabled ? _controller.stop() : _controller.start();
          _cameraEnabled = !_cameraEnabled;
          setState(() {});
        },
      ),
      // Flash enable/disable
      ValueListenableBuilder(
        valueListenable: _controller.torchState,
        builder: (context, value, widget) {
          bool torchEnabled = value == TorchState.on;
          return IconButton(
            icon: Icon(
              torchEnabled ? Icons.flash_on : Icons.flash_off,
            ),
            onPressed: _controller.hasTorch
                ? () {
                    torchEnabled
                        ? _controller.toggleTorch()
                        : _controller.toggleTorch();
                  }
                : null,
          );
        },
      ),

      ValueListenableBuilder(
          valueListenable: _controller.cameraFacingState,
          builder: (context, value, widget) {
            bool cameraFacingBack = value == CameraFacing.back;
            return IconButton(
              icon: Icon(
                cameraFacingBack ? Icons.camera_front : Icons.camera_rear,
              ),
              onPressed: () {
                _controller.switchCamera();
              },
            );
          }),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: Image.asset('assets/images/icon.png'),
        title: const Text('Better Scanner'),
        centerTitle: true,
      ),
      body: LayoutBuilder(builder: (context, constraints) {
        if (constraints.maxWidth < 700) {
          return Column(
            children: [
              ScanView(
                dimentions: constraints.maxHeight * 0.5 - 50,
                controller: _controller,
              ),
              SizedBox(
                height: 50,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: _buildActions(),
                ),
              ),
              SizedBox(
                height: constraints.maxHeight * 0.5,
                child: HistoryView(state: widget.state),
              ),
            ],
          );
        }
        return Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const SizedBox(width: 10),
            ScanView(
              dimentions: constraints.maxWidth * 0.4 - 60,
              // controller: widget.state.controller,
            ),
            const SizedBox(
              width: 50,
              child: Column(
                  mainAxisAlignment: MainAxisAlignment.center, children: []
                  // buildActions(context, widget.state.controller).toList(),
                  ),
            ),
            SizedBox(
              width: constraints.maxWidth * 0.5,
              child: HistoryView(state: widget.state),
            ),
          ],
        );
      }),
    );
  }
}

class ScanView extends StatelessWidget {
  final MobileScannerController? controller;

  final double dimentions;
  const ScanView({
    super.key,
    this.controller,
    required this.dimentions,
  });

  @override
  Widget build(BuildContext context) {
    return ScanWindow(
      controller: controller,
      size: dimentions,
      onDetect: (record) {
        BlocProvider.of<ScannerBloc>(context).add(ScannerEventScan(record));
      },
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
      constraints: const BoxConstraints(maxWidth: 600),
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
