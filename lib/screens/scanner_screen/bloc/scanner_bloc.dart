import 'package:better_scanner/models/qr_record_model.dart';
import 'package:better_scanner/screens/scanner_screen/bloc/scanner_event.dart';
import 'package:better_scanner/screens/scanner_screen/bloc/scanner_state.dart';
import 'package:better_scanner/services/database/database.dart';
import 'package:better_scanner/services/database/db_provider.dart';
import 'package:better_scanner/services/qr_model_open.dart';
import 'package:bloc/bloc.dart';
import 'package:share_plus/share_plus.dart';

export 'package:better_scanner/screens/scanner_screen/bloc/scanner_event.dart';
export 'package:better_scanner/screens/scanner_screen/bloc/scanner_state.dart';

class ScannerBloc extends Bloc<ScannerEvent, ScannerState> {
  late Database db;
  var records = <QrRecordModel>[];

  ScannerBloc() : super(ScannerStateUninitialized()) {
    on<ScannerEventInit>(_onInit);
    on<ScannerEventScan>(_onScan);
    on<ScannerEventRename>(_onRename);
    on<ScannerEventDelete>(_onDelete);
    on<ScannerEventOnTap>(_onTap);
    on<ScannerEventOnLongPress>(_onLongPress);
    on<ScannerEventOnShare>(_onShare);
  }

  void _onInit(ScannerEventInit event, Emitter<ScannerState> emit) async {
    db = await DBProvider.useDB(DBType.hive, 'user');
    try {
      records = await db.getRecords();
      emit(ScannerScreenState(qrCodes: records));
    } catch (e) {
      emit(ScannerScreenState(qrCodes: [], msg: e.toString()));
    }
  }

  void _onScan(ScannerEventScan event, Emitter<ScannerState> emit) async {
    await db.addRecord(event.record);
    records = await db.getRecords();
    emit(ScannerScreenState(
        qrCodes: records, msg: 'Added ${event.record.data}'));
  }

  void _onRename(ScannerEventRename event, Emitter<ScannerState> emit) async {
    var record = event.record;
    record.name = event.name;
    await db.updateRecord(record);
    records = await db.getRecords();
    emit(ScannerScreenState(
      qrCodes: records,
      msg: 'Renamed ${event.record.data} to ${event.name}',
    ));
  }

  void _onDelete(ScannerEventDelete event, Emitter<ScannerState> emit) async {
    await db.deleteRecord(event.record);
    records = await db.getRecords();
    emit(ScannerScreenState(
      qrCodes: records,
    ));
  }

  void _onTap(ScannerEventOnTap event, Emitter<ScannerState> emit) async {
    var record = event.record;
    if (await record.canOpen()) {
      await record.open();
    } else {
      record.copy();
      emit(ScannerScreenState(
        qrCodes: records,
        msg: 'Cannot open ${record.data}, copied to clipboard',
      ));
    }
  }

  void _onLongPress(ScannerEventOnLongPress event, Emitter<ScannerState> emit) {
    var record = event.record;
    record.copy();
    emit(ScannerScreenState(
      qrCodes: records,
      msg: 'Copied to clipboard',
    ));
  }

  void _onShare(ScannerEventOnShare event, Emitter<ScannerState> emit) {
    var record = event.record;
    Share.share(record.data, subject: record.name);
  }
}
