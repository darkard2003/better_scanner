import 'package:better_scanner/models/qr_models.dart';
import 'package:uuid/uuid.dart';

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

  String get displayName => name.isEmpty ? 'No Name' : name;
  String get displayData => data;
  String get copyData => data;
  bool get canOpen => false;

  factory QrRecordModel.fromText(String text, {String? uuid}) {
    var createdAt = DateTime.now();
    return QrRecordModel(
      id: uuid ?? const Uuid().v4().toString(),
      name: '',
      data: text,
      type: QrType.text,
      createdAt: createdAt,
    );
  }

  factory QrRecordModel.newType({
    required id,
    required name,
    required data,
    required type,
    required createdAt,
  }) {
    switch (type) {
      case QrType.url:
        return UrlQrModel(
          id: id,
          name: name,
          data: data,
          type: type,
          createdAt: createdAt,
        );
      case QrType.wifi:
        return WifiCred(
          id: id,
          name: name,
          data: data,
          type: type,
          createdAt: createdAt,
        );
      case QrType.geo:
        return GeoLocation(
          id: id,
          name: name,
          data: data,
          type: type,
          createdAt: createdAt,
        );
      case QrType.phone:
        return Phone(
          id: id,
          name: name,
          data: data,
          type: type,
          createdAt: createdAt,
        );

      case QrType.sms:
        return Sms(
          id: id,
          name: name,
          data: data,
          type: type,
          createdAt: createdAt,
        );

      case QrType.email:
        return Email(
          id: id,
          name: name,
          data: data,
          type: type,
          createdAt: createdAt,
        );
      case QrType.contact:
        return VCard(
          id: id,
          name: name,
          data: data,
          type: type,
          createdAt: createdAt,
        );

      case QrType.calendar:
        return Calendar(
          id: id,
          name: name,
          data: data,
          type: type,
          createdAt: createdAt,
        );
      case QrType.event:
        return Event(
          id: id,
          name: name,
          data: data,
          type: type,
          createdAt: createdAt,
        );
      default:
        return QrRecordModel(
          id: id,
          name: name,
          data: data,
          type: type,
          createdAt: createdAt,
        );
    }
  }

  factory QrRecordModel.newEmpty({required data, type}) {
    var id = const Uuid().v4().toString();
    var createdAt = DateTime.now();

    return QrRecordModel.newType(
      id: id,
      name: '',
      data: data,
      type: type,
      createdAt: createdAt,
    );
  }

  factory QrRecordModel.fromMap(Map<dynamic, dynamic> map) {
    var id = map[consts.id];
    var name = map[consts.name];
    var data = map[consts.data];
    var type = QrType.values[map[consts.type]];
    var createdAt = DateTime.parse(map[consts.createdAt]);

    return QrRecordModel.newType(
      id: id,
      name: name,
      data: data,
      type: type,
      createdAt: createdAt,
    );
  }

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
