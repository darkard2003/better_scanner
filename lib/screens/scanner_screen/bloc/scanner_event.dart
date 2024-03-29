import 'package:better_scanner/models/qr_record_model.dart';
import 'package:flutter/widgets.dart';

abstract class ScannerEvent {
  const ScannerEvent();
}

class ScannerEventInit extends ScannerEvent {}

class ScannerEventScan extends ScannerEvent {
  final QrRecordModel record;
  const ScannerEventScan(this.record);
}

class ScannerEventDelete extends ScannerEvent {
  final QrRecordModel record;
  const ScannerEventDelete(this.record);
}

class ScannerEventUpdate extends ScannerEvent {
  final QrRecordModel record;
  const ScannerEventUpdate(this.record);
}

class ScannerEventOnTap extends ScannerEvent {
  final QrRecordModel record;
  final BuildContext context;
  const ScannerEventOnTap(this.record, this.context);
}

class ScannerEventOnLongPress extends ScannerEvent {
  final QrRecordModel record;
  const ScannerEventOnLongPress(this.record);
}

class ScannerEventRename extends ScannerEvent {
  final QrRecordModel record;
  final String name;
  const ScannerEventRename(this.record, this.name);
}

class ScannerEventShare extends ScannerEvent {
  final QrRecordModel record;
  const ScannerEventShare(this.record);
}

class ScannerEventCopy extends ScannerEvent {
  final QrRecordModel record;
  const ScannerEventCopy(this.record);
}

class ScannerEventOpenUrl extends ScannerEvent {
  final QrRecordModel record;
  const ScannerEventOpenUrl(this.record);
}

