import 'package:better_scanner/models/qr_record_model.dart';
import 'package:better_scanner/models/qr_type.dart';

class QRGeneratorState {
  final QrRecordModel qrRecord;
  final QrType type;

  const QRGeneratorState({
    required this.qrRecord,
    required this.type,
  });

  QRGeneratorState copyWith({
    QrRecordModel? qrRecord,
    QrType? type,
  }) {
    return QRGeneratorState(
      qrRecord: qrRecord ?? this.qrRecord,
      type: type ?? this.type,
    );
  }
}
