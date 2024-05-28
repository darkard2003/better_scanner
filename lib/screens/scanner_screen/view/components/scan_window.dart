import 'package:flutter/material.dart';
import 'package:mobile_scanner/mobile_scanner.dart';

class ScanWindow extends StatelessWidget {
  final double size;
  final MobileScannerController controller;
  const ScanWindow({
    super.key,
    required this.controller,
    this.size = 300,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox.square(
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
    );
  }
}

// Iterable<Widget> buildActions(
//     BuildContext context, MobileScannerController controller) sync* {
//   yield IconButton(
//     icon: Icon(controller.facing == CameraFacing.back
//         ? Icons.camera_front
//         : Icons.camera_rear),
//     onPressed: () => controller.switchCamera(),
//   );
//   yield IconButton(
//     icon: Icon(controller== TorchState.off ? Icons.flash_off : Icons.flash_on),
//     onPressed: () => controller.hasTorch ? controller.toggleTorch() : null,
//   );
// }
