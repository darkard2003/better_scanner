import 'package:better_scanner/screens/scanner_screen/scanner_screen_vm.dart';
import 'package:better_scanner/screens/scanner_screen/view/components/record_list_view.dart';
import 'package:better_scanner/shared/screen_breakpoints.dart';
import 'package:flutter/material.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:provider/provider.dart';

import 'components/scan_window.dart';

class ScannerView extends StatelessWidget {
  const ScannerView({super.key});

  @override
  Widget build(BuildContext context) {
    final vm = context.watch<ScannerScreenVM>();
    var size = MediaQuery.of(context).size;
    vm.changeScreenSize(size.width);
    var constraints = BoxConstraints(
      maxWidth: size.width,
      maxHeight: size.height,
    );

    List<Widget> buildActions() {
      return [
        IconButton(
          icon: Icon(
            vm.cameraEnabled ? Icons.camera_alt : Icons.camera_alt_outlined,
          ),
          onPressed: () {
            vm.cameraEnabled ? vm.controller.stop() : vm.controller.start();
          },
        ),
        IconButton(
          icon: Icon(
            vm.flashEnabled == TorchState.on ? Icons.flash_on : Icons.flash_off,
          ),
          onPressed: vm.flashEnabled != TorchState.unavailable
              ? () {
                  vm.controller.toggleTorch();
                }
              : null,
        ),
        IconButton(
          icon: Icon(
            vm.cameraFacing == CameraFacing.back
                ? Icons.camera_front
                : Icons.camera_rear,
          ),
          onPressed: () {
            vm.controller.switchCamera();
          },
        ),
      ];
    }

    switch (vm.screenSize) {
      case ScreenSize.small:
        return Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(
              maxWidth: 700,
            ),
            child: Column(
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
                Expanded(
                  child: SizedBox(
                    height: constraints.maxHeight * 0.5,
                    child: const HistoryView(),
                  ),
                ),
              ],
            ),
          ),
        );
      default:
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
    }
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
    final vm = context.watch<ScannerScreenVM>();
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
              onPressed: vm.onGenerate,
            ),
            IconButton(
              icon: const Icon(Icons.add_a_photo),
              onPressed: vm.onUpload,
            ),
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
