import 'dart:async';

import 'package:better_scanner/models/qr_record_model.dart';
import 'package:better_scanner/screens/scanner_screen/scanner_screen_vm.dart';
import 'package:better_scanner/screens/scanner_screen/view/components/record_list_view.dart';
import 'package:better_scanner/services/qr_services/qr_services.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mobile_scanner/mobile_scanner.dart';

import 'components/scan_window.dart';

class ScannerView extends StatelessWidget {
  const ScannerView({super.key});

  @override
  Widget build(BuildContext context) {
    final vm = context.watch<ScannerScreenVM>();
    List<Widget> buildActions() {
      return [
        ValueListenableBuilder(
            valueListenable: vm.controller,
            builder: (context, state, widget) {
              bool cameraEnabled = state.isRunning;
              return IconButton(
                icon: Icon(
                  cameraEnabled ? Icons.camera_alt : Icons.camera_alt_outlined,
                ),
                onPressed: () {
                  cameraEnabled ? vm.controller.stop() : vm.controller.start();
                },
              );
            }),
        ValueListenableBuilder(
          valueListenable: vm.controller,
          builder: (context, state, widget) {
            bool torchEnabled = state.torchState == TorchState.on;
            return IconButton(
              icon: Icon(
                torchEnabled ? Icons.flash_on : Icons.flash_off,
              ),
              onPressed: state.torchState != TorchState.unavailable
                  ? () {
                      torchEnabled
                          ? vm.controller.toggleTorch()
                          : vm.controller.toggleTorch();
                    }
                  : null,
            );
          },
        ),
        ValueListenableBuilder(
            valueListenable: vm.controller,
            builder: (context, state, widget) {
              bool cameraFacingBack =
                  state.cameraDirection == CameraFacing.back;
              return IconButton(
                icon: Icon(
                  cameraFacingBack ? Icons.camera_front : Icons.camera_rear,
                ),
                onPressed: () {
                  vm.controller.switchCamera();
                },
              );
            }),
      ];
    }

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
                controller: vm.controller,
              ),
              SizedBox(
                height: 50,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: buildActions(),
                ),
              ),
              SizedBox(
                height: constraints.maxHeight * 0.5,
                child: const HistoryView(),
              ),
            ],
          );
        }
        return Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const SizedBox(width: 10),
            ScanView(
              controller: vm.controller,
              dimentions: constraints.maxWidth * 0.4 - 60,
              // controller: widget.state.controller,
            ),
            SizedBox(
              width: 50,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: buildActions(),
              ),
            ),
            SizedBox(
              width: constraints.maxWidth * 0.5,
              child: const HistoryView(),
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
  const HistoryView({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final vm = context.read<ScannerScreenVM>();
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
                unawaited(vm.controller.stop());
                var record = await Navigator.of(context).pushNamed('/generator')
                    as QrRecordModel?;
                unawaited(vm.controller.start());
                if (record == null) return;
                if (!context.mounted) return;
                vm.onScan(record);
              },
            ),
            IconButton(
                icon: const Icon(Icons.add_a_photo),
                onPressed: () async {
                  var scanned = await QrServices.scanQrFromFile(vm.controller);
                  if (!context.mounted) return;
                  if (!scanned) vm.safeShowSnackBar("Faild to Scan QR");
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
          records: vm.records,
        ),
      ]),
    );
  }
}
