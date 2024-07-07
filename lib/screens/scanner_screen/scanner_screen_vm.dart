import 'dart:async';

import 'package:better_scanner/models/qr_record_model.dart';
import 'package:better_scanner/services/database/database.dart';
import 'package:better_scanner/services/database/db_provider.dart';
import 'package:better_scanner/services/qr_services/qr_services.dart';
import 'package:better_scanner/shared/base_vm.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:mobile_scanner/mobile_scanner.dart';

class ScannerScreenVM extends BaseVM with WidgetsBindingObserver {
  ScannerScreenVM(super.context) {
    controller = MobileScannerController(
      autoStart: false,
      facing: CameraFacing.back,
      detectionSpeed: DetectionSpeed.noDuplicates,
    );
    WidgetsBinding.instance.addObserver(this);
    _subscription = controller.barcodes.listen(_handleBarcode);
    unawaited(controller.start());
    init();
  }
  bool isLoading = true;
  bool cameraEnabled = false;
  late Database db;
  late MobileScannerController controller;
  StreamSubscription<Object?>? _subscription;
  List<QrRecordModel> records = [];

  void _handleBarcode(BarcodeCapture record) {
    var qrCodes = QrServices.barcodeToQrList(record);
    for (var code in qrCodes) {
      onScan(code);
    }
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);
    switch (state) {
      case AppLifecycleState.resumed:
        _subscription = controller.barcodes.listen(_handleBarcode);
        unawaited(controller.start());
        break;
      case AppLifecycleState.inactive:
        unawaited(_subscription?.cancel());
        _subscription = null;
        unawaited(controller.stop());
      default:
        return;
    }
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    unawaited(_subscription?.cancel());
    super.dispose();
  }

  Future<void> init() async {
    db = await DBProvider.useDB(DBType.hive, 'user');
    try {
      records = await db.getRecords();
    } catch (e) {
      safeShowSnackBar('Error: Faild to load records', isError: true);
    }
    isLoading = false;
    safeNotifyListeners();
  }

  Future<void> onCopy(QrRecordModel record) async {
    await Clipboard.setData(ClipboardData(text: record.copyData));
    safeShowSnackBar('${record.name} Copied to clipboard');
    safeNotifyListeners();
  }

  void onDelete(QrRecordModel record) async {
    await db.deleteRecord(record);
    records.removeWhere((element) => element.id == record.id);
    safeShowSnackBar('Deleted ${record.name}');
    safeNotifyListeners();
  }

  void onEdit(QrRecordModel record) async {
    final newRecord = await Navigator.pushNamed(context, '/generator',
        arguments: {'qr': record}) as QrRecordModel?;

    if (newRecord == null) return;
    await db.updateRecord(newRecord);
    records = await db.getRecords();
    safeNotifyListeners();
  }

  void onScan(QrRecordModel record) async {
    if (records.any((element) => element.data == record.data)) {
      var exrecord =
          records.firstWhere((element) => element.data == record.data);
      records.remove(exrecord);
      await db.deleteRecord(exrecord);
      records.insert(0, record);
      await db.addRecord(record);
    } else {
      records.insert(0, record);
      await db.addRecord(record);
    }
    safeNotifyListeners();
  }

  void onTap(QrRecordModel record) async {
    unawaited(controller.stop());
    var _ = await Navigator.pushNamed(context, '/generator',
        arguments: {'qr': record}) as QrRecordModel?;
    safeNotifyListeners();
    unawaited(controller.start());
  }

  void openUrl(QrRecordModel record) async {
    if (!record.canOpen) {
      safeShowSnackBar('Can not open this url', isError: true);
      return;
    }
    if (!await QrServices.canLaunch(record)) {
      safeShowSnackBar('Can not open this url', isError: true);
      return;
    }
    await QrServices.launch(record);
    safeNotifyListeners();
  }

  Future<void> onShare(QrRecordModel record) async {
    await QrServices.shareQrText(record);
    safeNotifyListeners();
  }
}
