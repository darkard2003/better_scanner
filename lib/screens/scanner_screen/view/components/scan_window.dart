import 'package:better_scanner/models/qr_record_model.dart';
import 'package:better_scanner/models/qr_type.dart';
import 'package:flutter/material.dart';
import 'package:mobile_scanner/mobile_scanner.dart';

class ScanWindow extends StatelessWidget {
  final Function(QrRecordModel record) onDetect;
  final MobileScannerController? controller;
  final double dimension;
  const ScanWindow(
      {super.key,
      required this.onDetect,
      this.controller,
      this.dimension = 300});

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
      onDetect(record);
    }
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox.square(
      dimension: dimension,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(10),
        child: MobileScanner(
          controller: controller,
          onDetect: (capture) => translate(capture, context),
          placeholderBuilder: (context, widget) =>
              widget ??
              Container(
                color: Colors.black.withOpacity(0.5),
                child: const Center(
                  child: CircularProgressIndicator(),
                ),
              ),
        ),
      ),
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
