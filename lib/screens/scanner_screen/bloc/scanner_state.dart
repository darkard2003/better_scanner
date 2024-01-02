import 'package:better_scanner/models/qr_record_model.dart';
import 'package:equatable/equatable.dart';

class ScannerState {
  bool isLoading;
  String? msg;

  ScannerState({
    required this.isLoading,
    this.msg,
  });

  ScannerState copyWith({
    bool? isLoading,
    String? msg,
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
  ScannerScreenState({
    required this.qrCodes,
    super.isLoading = false,
    super.msg,
  });

  @override
  List<Object?> get props => [isLoading, msg];

  @override
  ScannerScreenState copyWith({
    bool? isLoading,
    String? msg,
    List<QrRecordModel>? qrCodes,
  }) {
    return ScannerScreenState(
      qrCodes: qrCodes ?? this.qrCodes,
      isLoading: isLoading ?? this.isLoading,
      msg: msg ?? this.msg,
    );
  }
}
