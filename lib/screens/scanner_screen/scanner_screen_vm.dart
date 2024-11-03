import 'dart:async';

import 'package:better_scanner/helpers/show_details_dialog.dart';
import 'package:better_scanner/helpers/show_generator_dialog.dart';
import 'package:better_scanner/models/qr_record_model.dart';
import 'package:better_scanner/screens/scanner_screen/view/components/record_action.dart';
import 'package:better_scanner/screens/shared/show_snackbar.dart';
import 'package:better_scanner/services/database/database.dart';
import 'package:better_scanner/services/database/db_provider.dart';
import 'package:better_scanner/services/qr_services/qr_services.dart';
import 'package:better_scanner/shared/base_vm.dart';
import 'package:better_scanner/shared/screen_breakpoints.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mobile_scanner/mobile_scanner.dart';

import '../../helpers/show_search_dialog.dart';

class ScannerScreenVM extends BaseVM with WidgetsBindingObserver {
  bool cameraEnabled = false;
  TorchState flashEnabled = TorchState.unavailable;
  CameraFacing cameraFacing = CameraFacing.back;
  ScreenSize screenSize = ScreenSize.small;
  final imagePicker = ImagePicker();
  double previousScale = 1.0;
  double scale = 1.0;
  double zoom = 1.0; // Add zoom variable to retain zoom level
  final Duration debounceDuration = const Duration(milliseconds: 50);
  Timer? _debounce;

  final max_zoom = 4.0;
  final min_zoom = 1.0;

  ScannerScreenVM(super.context) {
    controller = MobileScannerController(
      autoStart: false,
      facing: CameraFacing.back,
      detectionSpeed: DetectionSpeed.noDuplicates,
    );
    WidgetsBinding.instance.addObserver(this);
    controller.addListener(() {
      var state = controller.value;
      cameraEnabled = state.isRunning;
      flashEnabled = state.torchState;
      cameraFacing = state.cameraDirection;
      safeNotifyListeners();
    });
    controller.barcodes.listen(_handleBarcode);
    unawaited(controller.start());
    init();
  }

  bool isLoading = true;
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

  void changeScreenSize(double width) {
    screenSize = screenSizeFromSize(width);
  }

  void onDelete(QrRecordModel record) async {
    await db.deleteRecord(record);
    records.removeWhere((element) => element.id == record.id);
    safeShowSnackBar('Deleted ${record.name}');
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

  void onGenerate() async {
    unawaited(controller.stop());
    var record = await showGeneratorDialog(
      context,
      fullScreen: screenSize == ScreenSize.small,
    );
    unawaited(controller.start());
    if (record == null) return;
    onScan(record);
  }

  void onUpload() async {
    final img = await imagePicker.pickImage(source: ImageSource.gallery);
    if (img == null) return;
    final capture = await controller.analyzeImage(img.path);
    if (capture == null) {
      if (!context.mounted) return;
      showSnackbar(context, "No barcodes found", type: SnackbarType.error);
      return;
    }
    _handleBarcode(capture);
    safeNotifyListeners();
  }

  Future<void> onTap(QrRecordModel record) async {
    unawaited(controller.stop());
    var _ = await showDetailsDialog(
      context,
      record: record,
      fullScreen: screenSize == ScreenSize.small,
    );
    safeNotifyListeners();
    unawaited(controller.start());
  }

  Future<void> onEdit(QrRecordModel record) async {
    unawaited(controller.stop());
    var newRecord = await showGeneratorDialog(
      context,
      fullScreen: screenSize == ScreenSize.small,
      record: record,
    );
    unawaited(controller.start());
    if (newRecord == null) return;
    await db.updateRecord(newRecord);
    records = await db.getRecords();
    safeNotifyListeners();
  }

  Future<void> openUrl(QrRecordModel record) async {
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

  void shortcutAction(QrRecordModel record) {
    if (record.canOpen) {
      openUrl(record);
    } else {
      onCopy(record);
    }
  }

  void onSearch() async {
    var intent = await showSearchDialog(
      context,
      records: records,
      fullScreen: screenSize == ScreenSize.small,
    );
    if (intent == null) {
      return;
    }
    await Future.delayed(const Duration(milliseconds: 100));
    switch (intent.action) {
      case RecordAction.tap:
        await onTap(intent.record);
        break;
      case RecordAction.edit:
        onEdit(intent.record);
        break;
      case RecordAction.delete:
        onDelete(intent.record);
        break;
      case RecordAction.share:
        onShare(intent.record);
        break;
      case RecordAction.shortcut:
        shortcutAction(intent.record);
    }
  }

  void initScale() {
    previousScale = scale;
  }

  Future<void> updateScale(double scale) async {
    if (_debounce?.isActive ?? false) return;
    _debounce = Timer(debounceDuration, () async {
      this.scale = (previousScale * scale).clamp(min_zoom, max_zoom);
      zoom = this.scale;

      double normalizedZoom = (zoom - min_zoom) / (max_zoom - min_zoom);

      await controller.setZoomScale(normalizedZoom);
      debugPrint('Zoom: $zoom');
      debugPrint('Normalized Zoom: $normalizedZoom');
      safeNotifyListeners();
    });
  }

  void onScaleEnd() {
    previousScale = 1.0;
  }

  Future<void> onDoubleTap() async {
    if (zoom == 1.0) {
      zoom = 2.0;
    } else {
      zoom = 1.0;
    }
    double normalizedZoom = (zoom - min_zoom) / (max_zoom - min_zoom);
    await controller.setZoomScale(normalizedZoom);
    safeNotifyListeners();
  }
}
