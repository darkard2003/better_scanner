import 'package:better_scanner/models/qr_type.dart';

class QRGeneratorState {
  final String uuid;
  final String name;
  final String qrString;
  final QrType type;

  const QRGeneratorState({
    required this.uuid,
    required this.name,
    required this.qrString,
    required this.type,
  });

  QRGeneratorState copyWith({
    String? name,
    String? qrString,
    QrType? type,
  }) {
    return QRGeneratorState(
      uuid: uuid,
      name: name ?? this.name,
      qrString: qrString ?? this.qrString,
      type: type ?? this.type,
    );
  }
}
