import 'package:better_scanner/models/qr_record_model.dart';
import 'package:better_scanner/screens/scanner_screen/bloc/state_message.dart';
import 'package:equatable/equatable.dart';
import 'package:mobile_scanner/mobile_scanner.dart';

class ScannerState {
  bool isLoading;
  StateMessage? msg;

  ScannerState({
    required this.isLoading,
    this.msg,
  });

  ScannerState copyWith({
    bool? isLoading,
    StateMessage? msg,
  }) {
    return ScannerState(
      isLoading: isLoading ?? this.isLoading,
      msg: msg ?? this.msg,
    );
  }
}

class ScannerStateUninitialized extends ScannerState {
  ScannerStateUninitialized() : super(isLoading: false);
}

class ScannerScreenState extends ScannerState with EquatableMixin {
  List<QrRecordModel> qrCodes;
  MobileScannerController controller;
  ScannerScreenState({
    required this.qrCodes,
    required this.controller,
    super.isLoading = false,
    super.msg,
  });

  @override
  List<Object?> get props => [isLoading, msg, qrCodes];

  @override
  ScannerScreenState copyWith({
    bool? isLoading,
    StateMessage? msg,
    List<QrRecordModel>? qrCodes,
  }) {
    return ScannerScreenState(
      qrCodes: qrCodes ?? this.qrCodes,
      controller: controller,
      isLoading: isLoading ?? this.isLoading,
      msg: msg ?? this.msg,
    );
  }
}
