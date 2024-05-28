import 'dart:async';

import 'package:better_scanner/models/qr_record_model.dart';
import 'package:better_scanner/screens/scanner_screen/bloc/scanner_bloc.dart';
import 'package:better_scanner/screens/scanner_screen/view/components/record_list_view.dart';
import 'package:better_scanner/screens/shared/show_snackbar.dart';
import 'package:better_scanner/services/qr_services/qr_services.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mobile_scanner/mobile_scanner.dart';

import 'components/scan_window.dart';

class ScannerView extends StatefulWidget {
  final ScannerScreenState state;
  const ScannerView({super.key, required this.state});

  @override
  State<ScannerView> createState() => _ScannerViewState();
}

class _ScannerViewState extends State<ScannerView> with WidgetsBindingObserver {
  late final MobileScannerController _controller;
  StreamSubscription<Object?>? _subscription;
  bool _cameraEnabled = true;

  void _handleBarcode(BarcodeCapture record) {
    var qrCodes = QrServices.barcodeToQrList(record);
    for (var code in qrCodes) {
      BlocProvider.of<ScannerBloc>(context).add(ScannerEventScan(code));
    }
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);
    switch (state) {
      case AppLifecycleState.resumed:
        _subscription = _controller.barcodes.listen(_handleBarcode);
        unawaited(_controller.start());
        break;
      case AppLifecycleState.inactive:
        unawaited(_subscription?.cancel());
        _subscription = null;
        unawaited(_controller.stop());
      default:
        return;
    }
  }

  @override
  Future<void> didChangeDependencies() async {
    await _controller.stop();
    super.didChangeDependencies();
    await _controller.start();
  }

  @override
  void initState() {
    super.initState();
    SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
    _controller = context.read<ScannerBloc>().controller;
    WidgetsBinding.instance.addObserver(this);
    _subscription = _controller.barcodes.listen(_handleBarcode);
    unawaited(_controller.start());
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    unawaited(_subscription?.cancel());
    super.dispose();
  }

  List<Widget> _buildActions() {
    return [
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
      ValueListenableBuilder(
        valueListenable: _controller,
        builder: (context, state, widget) {
          bool torchEnabled = state.torchState == TorchState.on;
          return IconButton(
            icon: Icon(
              torchEnabled ? Icons.flash_on : Icons.flash_off,
            ),
            onPressed: state.torchState != TorchState.unavailable
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
          valueListenable: _controller,
          builder: (context, state, widget) {
            bool cameraFacingBack = state.cameraDirection == CameraFacing.back;
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
                child: HistoryView(
                  state: widget.state,
                  controller: _controller,
                ),
              ),
            ],
          );
        }
        return Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const SizedBox(width: 10),
            ScanView(
              controller: _controller,
              dimentions: constraints.maxWidth * 0.4 - 60,
              // controller: widget.state.controller,
            ),
            SizedBox(
              width: 50,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: _buildActions(),
              ),
            ),
            SizedBox(
              width: constraints.maxWidth * 0.5,
              child: HistoryView(
                state: widget.state,
                controller: _controller,
              ),
            ),
          ],
        );
      }),
    );
  }
}

class ScanView extends StatelessWidget {
  final MobileScannerController controller;

  final double dimentions;
  const ScanView({
    super.key,
    required this.controller,
    required this.dimentions,
  });

  @override
  Widget build(BuildContext context) {
    return ScanWindow(
      controller: controller,
      size: dimentions,
    );
  }
}

class HistoryView extends StatelessWidget {
  final MobileScannerController controller;
  const HistoryView({
    super.key,
    required this.state,
    required this.controller,
  });

  final ScannerScreenState state;

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: const BoxConstraints(maxWidth: 600),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surfaceContainerHighest,
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(16),
          topRight: Radius.circular(16),
        ),
      ),
      child: CustomScrollView(slivers: [
        SliverAppBar(
          title: const Text(
            'History',
          ),
          floating: true,
          snap: true,
          leading: const Icon(Icons.history),
          actions: [
            IconButton(
              icon: const Icon(Icons.qr_code),
              onPressed: () async {
                unawaited(controller.stop());
                var record =
                    await Navigator.of(context).pushNamed('/generator');
                unawaited(controller.start());
                if (record == null) return;
                if (!context.mounted) return;
                BlocProvider.of<ScannerBloc>(context)
                    .add(ScannerEventScan(record as QrRecordModel));
              },
            ),
            IconButton(
                icon: const Icon(Icons.add_a_photo),
                onPressed: () async {
                  var scanned = await QrServices.scanQrFromFile(controller);
                  if (!context.mounted) return;
                  if (!scanned) showSnackbar(context, "Faild to Scan QR");
                }),
            IconButton(
              icon: const Icon(Icons.search),
              onPressed: () {},
            ),
          ],
          backgroundColor: Colors.transparent,
          // centerTitle: true,
        ),
        RecordListViewSliver(
          records: state.qrCodes,
        ),
      ]),
    );
  }
}
