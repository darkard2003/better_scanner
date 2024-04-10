import 'package:better_scanner/models/qr_record_model.dart';
import 'package:better_scanner/models/qr_type.dart';
import 'package:better_scanner/screens/qr_generator_screen/qr_generaor_state.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:uuid/uuid.dart';

class QrGeneratorVM extends Cubit<QRGeneratorState> {
  BuildContext context;
  QrRecordModel? qrIn;
  final TextEditingController nameController = TextEditingController();
  final availableQrTypes = [
    QrType.text,
    QrType.url,
    QrType.wifi,
  ];
  QrGeneratorVM({
    required this.context,
    this.qrIn,
  }) : super(QRGeneratorState(
          uuid: qrIn?.id ?? const Uuid().v4(),
          name: qrIn?.name ?? "",
          qrString: qrIn?.data ?? "",
          type: qrIn?.type ?? QrType.text,
        )) {
    nameController.text = state.name;
  }

  void updateQrRecord(String qrString) {
    emit(state.copyWith(qrString: qrString));
  }

  void updateType(QrType type) {
    emit(state.copyWith(type: type));
  }

  void save() {
    Navigator.of(context).pop(qr);
  }

  void updateName(String name) {
    emit(state.copyWith(name: name));
  }

  QrRecordModel get qr {
    return QrRecordModel(
      id: state.uuid,
      name: state.name,
      data: state.qrString,
      type: state.type,
      createdAt: DateTime.now(),
    );
  }
}
