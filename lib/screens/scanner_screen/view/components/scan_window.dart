import 'package:better_scanner/screens/scanner_screen/scanner_screen_vm.dart';
import 'package:flutter/material.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:provider/provider.dart';

class ScanWindow extends StatelessWidget {
  final double size;

  const ScanWindow({
    super.key,
    this.size = 300,
  });

  @override
  Widget build(BuildContext context) {
    final vm = context.watch<ScannerScreenVM>();
    final controller = vm.controller;
    return GestureDetector(
      onScaleStart: (details) {
        vm.initScale();
      },
      onScaleUpdate: (details) async {
        await vm.updateScale(details.scale);
      },
      child: SizedBox.square(
        dimension: size,
        child: Card(
          elevation: 10,
          child: ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: Stack(
              children: [
                MobileScanner(
                  controller: controller,
                  onDetect: (record) {},
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
