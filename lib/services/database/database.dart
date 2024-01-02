import 'package:better_scanner/models/qr_record_model.dart';

abstract class Database {
  Future<void> init(String uid);
  Future<void> dispose();
  Future<void> addRecord(QrRecordModel record);
  Future<void> deleteRecord(QrRecordModel record);
  Future<void> deleteAllRecords();
  Future<void> updateRecord(QrRecordModel record);
  Future<bool> containsRecord(QrRecordModel record);
  Future<List<QrRecordModel>> getRecords();
  Stream<List<QrRecordModel>> getRecordsStream();
}
