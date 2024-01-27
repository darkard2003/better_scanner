import 'package:better_scanner/models/qr_record_model.dart';
import 'package:better_scanner/models/qr_type.dart';
import 'package:flutter/material.dart';
import 'package:mobile_scanner/mobile_scanner.dart';

class ScanWindow extends StatefulWidget {
  final Function(QrRecordModel record) onDetect;
  final double dimension;
  const ScanWindow({super.key, required this.onDetect, this.dimension = 300});

  @override
  State<ScanWindow> createState() => _ScanWindowState();
}

class _ScanWindowState extends State<ScanWindow> {
  late final MobileScannerController _controller;
  bool _cameraEnabled = false;
  bool _hasTorch = false;

  Future<void> _start() async {
    var args = await _controller.start();
    if (args != null) {
      _hasTorch = args.hasTorch;
    }
    _cameraEnabled = true;
    setState(() {});
  }

  Future<void> _stop() async {
    await _controller.stop();
    _cameraEnabled = false;
    setState(() {});
  }

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

  Iterable<Widget> _buildActions() sync* {
    yield ValueListenableBuilder(
        valueListenable: _controller.torchState,
        builder: (context, value, child) {
          return IconButton(
            onPressed: _hasTorch
                ? () async {
                    await _controller.toggleTorch();
                  }
                : null,
            icon: value == TorchState.off
                ? const Icon(Icons.flash_on_outlined)
                : const Icon(Icons.flash_off_outlined),
          );
        });
    yield IconButton(
      onPressed: () async {
        if (!_cameraEnabled) {
          await _start();
        } else {
          await _stop();
        }
      },
      icon: _cameraEnabled
          ? const Icon(Icons.camera)
          : const Icon(
              Icons.camera_alt_outlined,
            ),
    );

    yield ValueListenableBuilder(
      valueListenable: _controller.cameraFacingState,
      builder: (context, value, child) {
        return IconButton(
          onPressed: () async {
            await _controller.switchCamera();
          },
          icon: value == CameraFacing.back
              ? const Icon(Icons.camera_front_outlined)
              : const Icon(Icons.camera_rear_outlined),
        );
      },
      child: IconButton(
        onPressed: () async {
          await _controller.switchCamera();
        },
        icon: const Icon(Icons.switch_camera_outlined),
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    _controller = MobileScannerController(
      useNewCameraSelector: true,
      detectionSpeed: DetectionSpeed.noDuplicates,
    );
  }

  @override
  void dispose() {
    _controller.stop();
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const SizedBox(width: 50),
        SizedBox.square(
          dimension: widget.dimension,
          child: Card(
            elevation: 10,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: Stack(
                children: [
                  MobileScanner(
                    controller: _controller,
                    startDelay: true,
                    onDetect: (capture) => translate(capture, context),
                    onScannerStarted: (arguments) => setState(() {
                      _cameraEnabled = true;
                      _hasTorch = arguments?.hasTorch ?? false;
                    }),
                  ),
                  if (!_cameraEnabled)
                    const Center(
                      child: Text(
                        "Camera disabled",
                      ),
                    ),
                ],
              ),
            ),
          ),
        ),
        SizedBox(
          width: 50,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: _buildActions().toList(),
          ),
        ),
      ],
    );
  }
}

extension on BarcodeType {
  QrType get qrType {
    switch (this) {
      case BarcodeType.text:
        return QrType.text;
      case BarcodeType.url:
        return QrType.url;
      case BarcodeType.wifi:
        return QrType.wifi;
      case BarcodeType.geo:
        return QrType.geo;
      case BarcodeType.phone:
        return QrType.phone;
      case BarcodeType.sms:
        return QrType.sms;
      case BarcodeType.email:
        return QrType.email;
      case BarcodeType.contactInfo:
        return QrType.contact;
      case BarcodeType.calendarEvent:
        return QrType.event;
      default:
        return QrType.unknown;
    }
  }
}
