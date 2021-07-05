import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class SqlDatabase {
  Database database;

  SqlDatabase() {}

  Future<Database> initDB() async {
    int dbVersion = 8;
    final path = join(await getDatabasesPath(), 'bca_v$dbVersion.db');
    this.database =
        await openDatabase(path, version: dbVersion, onCreate: (Database db, int version) async {
      await db.execute(
          'CREATE TABLE History (id TEXT PRIMARY KEY,timestamp INTEGER, amount REAL, pair TEXT,result TEXT,rawFirestore TEXT)');
    });
    print("inited DB");

    return this.database;
  }

  Future<void> deleteDB() async {
    await database.rawDelete("DELETE FROM History");
    print("deleted DB");
  }
}
