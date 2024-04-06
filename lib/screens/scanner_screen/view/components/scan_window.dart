import 'package:better_scanner/models/qr_record_model.dart';
import 'package:better_scanner/models/qr_type.dart';
import 'package:better_scanner/models/qr_type_extention.dart';
import 'package:flutter/material.dart';
import 'package:mobile_scanner/mobile_scanner.dart';

class ScanWindow extends StatefulWidget {
  final Function(QrRecordModel record) onDetect;
  final double size;
  final MobileScannerController? controller;
  const ScanWindow({
    super.key,
    required this.onDetect,
    this.size = 300,
    this.controller,
  });

  @override
  State<ScanWindow> createState() => _ScanWindowState();
}

class _ScanWindowState extends State<ScanWindow> {
  late MobileScannerController _controller;
  void translate(BarcodeCapture capture, BuildContext context) {
    var codes = capture.barcodes;
    for (var code in codes) {
      var rawValue = code.rawValue;
      if (rawValue == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Unknown QR code'),
          ),
        );
        return;
      }
      var record =
          QrRecordModel.newEmpty(data: rawValue, type: code.type.qrType);
      widget.onDetect(record);
    }
  }

  @override
  void initState() {
    super.initState();
    _controller = widget.controller ??
        MobileScannerController(
          detectionSpeed: DetectionSpeed.noDuplicates,
        );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox.square(
      dimension: widget.size,
      child: Card(
        elevation: 10,
        child: ClipRRect(
          borderRadius: BorderRadius.circular(10),
          child: Stack(
            children: [
              MobileScanner(
                // controller: widget.controller,
                // startDelay: true,
                controller: _controller,
                onDetect: (capture) => translate(capture, context),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

Iterable<Widget> buildActions(
    BuildContext context, MobileScannerController controller) sync* {
  yield ValueListenableBuilder(
      valueListenable: controller.cameraFacingState,
      builder: (context, value, child) {
        return IconButton(
          icon: Icon(value == CameraFacing.back
              ? Icons.camera_front
              : Icons.camera_rear),
          onPressed: () => controller.switchCamera(),
        );
      });
  yield ValueListenableBuilder(
    valueListenable: controller.torchState,
    builder: (context, value, child) {
      return IconButton(
        icon: Icon(value == TorchState.off ? Icons.flash_off : Icons.flash_on),
        onPressed: () => controller.hasTorch ? controller.toggleTorch() : null,
      );
    },
  );
}

