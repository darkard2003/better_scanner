import 'package:better_scanner/services/database/database.dart';
import 'package:better_scanner/services/database/hive_db.dart';

enum DBType { hive }

abstract class DBProvider {
  static DBType type = DBType.hive;
  static Database? _database;

  static Database getDatabase() {
    if (_database == null) {
      throw Exception('Database not initialized');
    }
    return _database!;
  }

  static Future<Database> useDB(DBType type, String uid) async {
    await _database?.dispose();
    switch (type) {
      case DBType.hive:
        _database = HiveDB();
        break;
      default:
        throw Exception('Database type not supported');
    }
    await _database!.init(uid);
    return _database!;
  }
}
