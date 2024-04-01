import 'package:better_scanner/models/qr_record_model.dart';
import 'package:better_scanner/models/qr_type.dart';
import 'package:better_scanner/screens/qr_generator_screen/qr_generaor_state.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class QrGeneratorVM extends Cubit<QRGeneratorState> {
  BuildContext context;
  QrGeneratorVM({
    required this.context,
  }) : super(QRGeneratorState(
          qrRecord: QrRecordModel.fromText(''),
          type: QrType.text,
        ));

  void updateQrRecord(QrRecordModel qrRecord) {
    emit(state.copyWith(qrRecord: qrRecord));
  }

  void updateType(QrType type) {
    emit(state.copyWith(type: type));
  }
}
