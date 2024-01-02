import 'package:better_scanner/models/qr_record_model.dart';

abstract class ScannerEvent {
  const ScannerEvent();
}

class ScannerEventInit extends ScannerEvent {}

class ScannerEventScan extends ScannerEvent {
  final QrRecordModel record;
  const ScannerEventScan(this.record);
}

class ScannerEventDelete extends ScannerEvent {
  final QrRecordModel code;
  const ScannerEventDelete(this.code);
}

class ScannerEventUpdate extends ScannerEvent {
  final QrRecordModel code;
  const ScannerEventUpdate(this.code);
}

class ScannerEventOnTap extends ScannerEvent {
  final QrRecordModel record;
  const ScannerEventOnTap(this.record);
}

class ScannerEventOnLongPress extends ScannerEvent {
  final QrRecordModel code;
  const ScannerEventOnLongPress(this.code);
}

class ScannerEventRename extends ScannerEvent {
  final QrRecordModel record;
  final String name;
  const ScannerEventRename(this.record, this.name);
}

class ScannerEventOnShare extends ScannerEvent {
  final QrRecordModel record;
  const ScannerEventOnShare(this.record);
}
