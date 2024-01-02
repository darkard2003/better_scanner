import 'package:better_scanner/models/qr_record_model.dart';
import 'package:better_scanner/services/database/database.dart';
import 'package:hive_flutter/hive_flutter.dart';

class HiveDB extends Database {
  late final Box _box;

  @override
  Future<void> addRecord(QrRecordModel record) async {
    await _box.put(record.id, record.toMap());
  }

  @override
  Future<void> deleteRecord(QrRecordModel record) async {
    await _box.delete(record.id);
  }

  @override
  Future<List<QrRecordModel>> getRecords() async {
    var values = _box.values.map((e) => QrRecordModel.fromMap(e)).toList();
    values.sort((a, b) => b.createdAt.compareTo(a.createdAt));
    return values;
  }

  @override
  Stream<List<QrRecordModel>> getRecordsStream() {
    return _box.watch().map((event) {
      var values = _box.values.map((e) => QrRecordModel.fromMap(e)).toList();
      values.sort((a, b) => b.createdAt.compareTo(a.createdAt));
      return values;
    });
  }

  @override
  Future<void> init(String uid) async {
    await Hive.initFlutter();
    _box = await Hive.openBox(uid);
  }

  @override
  Future<void> updateRecord(QrRecordModel record) async {
    await _box.put(record.id, record.toMap());
  }

  @override
  Future<void> dispose() async {
    await _box.close();
  }

  @override
  Future<bool> containsRecord(QrRecordModel record) async {
    return _box.containsKey(record.id);
  }

  @override
  Future<void> deleteAllRecords() {
    return _box.clear();
  }
}
