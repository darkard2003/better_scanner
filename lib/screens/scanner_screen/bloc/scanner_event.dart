import 'package:better_scanner/models/qr_record_model.dart';

abstract class ScannerEvent {
  const ScannerEvent();
}

class ScannerEventInit extends ScannerEvent {}

class ScannerEventScan extends ScannerEvent {
  final QrRecordModel code;
  const ScannerEventScan(this.code);
}

class ScannerEventDelete extends ScannerEvent {
  final QrRecordModel code;
  const ScannerEventDelete(this.code);
}

class ScannerEventUpdate extends ScannerEvent {
  final QrRecordModel code;
  const ScannerEventUpdate(this.code);
}