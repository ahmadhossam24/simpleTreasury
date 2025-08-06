import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'dart:async';

class DBProvider {
  static final DBProvider instance = DBProvider._internal();
  factory DBProvider() => instance;
  DBProvider._internal();

  static const _databaseName = 'treasury.db';
  static const _databaseVersion = 1;

  Database? _db;

  Future<Database> get database async {
    if (_db != null) return _db!;
    _db = await _initDatabase();
    return _db!;
  }

  Future<Database> _initDatabase() async {
    final databasesPath = await getDatabasesPath();
    final path = join(databasesPath, _databaseName);

    return await openDatabase(
      path,
      version: _databaseVersion,
      onCreate: _onCreate,
    );
  }

  Future _onCreate(Database db, int version) async {
    await db.execute('''
      CREATE TABLE transactions (
        id TEXT PRIMARY KEY,
        treasuryId TEXT NOT NULL,
        title TEXT,
        value REAL NOT NULL,
        date INTEGER NOT NULL,
        type INTEGER NOT NULL,
        deleted INTEGER NOT NULL DEFAULT 0
      )
    ''');
  }
}
