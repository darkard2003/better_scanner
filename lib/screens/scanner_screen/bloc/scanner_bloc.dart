import 'package:better_scanner/screens/scanner_screen/bloc/scanner_event.dart';
import 'package:better_scanner/screens/scanner_screen/bloc/scanner_state.dart';
import 'package:bloc/bloc.dart';

export 'package:better_scanner/screens/scanner_screen/bloc/scanner_event.dart';
export 'package:better_scanner/screens/scanner_screen/bloc/scanner_state.dart';

class ScannerBloc extends Bloc<ScannerEvent, ScannerState> {
  ScannerBloc() : super(ScannerStateUninitialized()) {
    on<ScannerEventInit>(_onInit);
    on<ScannerEventScan>(_onScan);
  }

  void _onInit(ScannerEventInit event, Emitter<ScannerState> emit) async{
    await Future.delayed(const Duration(seconds: 3));
    emit(ScannerScreenState(qrCodes: []));
  }

  void _onScan(ScannerEventScan event, Emitter<ScannerState> emit) async{
    final state = this.state as ScannerScreenState;
    emit(state.copyWith(
      qrCodes: [...state.qrCodes, event.code],
    ));
  }
}
