import 'package:better_scanner/screens/scanner_screen/bloc/scanner_event.dart';
import 'package:better_scanner/screens/scanner_screen/bloc/scanner_state.dart';
import 'package:better_scanner/services/database/database.dart';
import 'package:better_scanner/services/database/db_provider.dart';
import 'package:bloc/bloc.dart';

export 'package:better_scanner/screens/scanner_screen/bloc/scanner_event.dart';
export 'package:better_scanner/screens/scanner_screen/bloc/scanner_state.dart';

class ScannerBloc extends Bloc<ScannerEvent, ScannerState> {
  late Database db;
  ScannerBloc() : super(ScannerStateUninitialized()) {
    on<ScannerEventInit>(_onInit);
    on<ScannerEventScan>(_onScan);
  }

  void _onInit(ScannerEventInit event, Emitter<ScannerState> emit) async {
    db = await DBProvider.useDB(DBType.hive, 'user');
    try {
      var records = await db.getRecords();
      emit(ScannerScreenState(qrCodes: records));
    } catch (e) {
      emit(ScannerScreenState(qrCodes: [], msg: e.toString()));
    }
  }

  void _onScan(ScannerEventScan event, Emitter<ScannerState> emit) async {
    await db.addRecord(event.code);
    var records = await db.getRecords();
    emit(ScannerScreenState(qrCodes: records, msg: 'Added ${event.code.data}'));
  }
}
