import 'package:uuid/v4.dart';

import 'qr_type.dart';
import 'model_consts.dart' as consts;

class QrRecordModel {
  String id;
  String name;
  String data;
  QrType type;

  QrRecordModel({
    required this.id,
    required this.name,
    required this.data,
    required this.type,
  });

  QrRecordModel.newEmpty({required this.data, required this.type})
      : id = const UuidV4().toString(),
        name = '';

  QrRecordModel.fromMap(Map<String, dynamic> map)
      : id = map[consts.id],
        name = map[consts.name],
        data = map[consts.data],
        type = QrType.values[map[consts.type]];

  Map<String, dynamic> toMap() => {
        consts.id: id,
        consts.name: name,
        consts.data: data,
        consts.type: type.index,
      };
}
