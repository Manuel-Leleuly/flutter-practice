import 'package:path/path.dart' as path;
import 'package:sqflite/sqflite.dart' as sql;
import 'package:sqflite/sqlite_api.dart';

Future<Database> getDatabase() async {
  final dbPath = await sql.getDatabasesPath();
  final db = await sql.openDatabase(
    path.join(dbPath, 'places.db'),
    onCreate: (db, version) {
      return db.execute(
        'CREATE TABLE user_places('
        'id TEXT PRIMARY KEY,'
        'title TEXT,'
        'image TEXT,'
        'lat REAL,'
        'lng REAL,'
        'address TEXT'
        ')',
      );
    },
    version: 1,
  );
  return db;
}
