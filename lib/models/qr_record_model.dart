import 'qr_type.dart';
import 'model_consts.dart' as consts;

class QrRecordModel {
  String id;
  String name;
  String data;
  QrType type;
  DateTime createdAt;

  QrRecordModel({
    required this.id,
    required this.name,
    required this.data,
    required this.type,
    required this.createdAt,
  });

  QrRecordModel.newEmpty({required this.data, required this.type})
      : id = data,
        name = '',
        createdAt = DateTime.now();

  QrRecordModel.fromMap(Map<dynamic, dynamic> map)
      : id = map[consts.id],
        name = map[consts.name],
        data = map[consts.data],
        type = QrType.values[map[consts.type]],
        createdAt = DateTime.parse(map[consts.createdAt]);

  QrRecordModel copyWith({
    String? id,
    String? name,
    String? data,
    QrType? type,
    DateTime? createdAt,
  }) {
    return QrRecordModel(
      id: id ?? this.id,
      name: name ?? this.name,
      data: data ?? this.data,
      type: type ?? this.type,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  Map<String, dynamic> toMap() => {
        consts.id: id,
        consts.name: name,
        consts.data: data,
        consts.type: type.index,
        consts.createdAt: createdAt.toIso8601String(),
      };
}
