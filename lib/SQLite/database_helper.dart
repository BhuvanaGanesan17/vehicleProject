import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DatabaseHelper {
  static final DatabaseHelper instance = DatabaseHelper._init();
  static Database? _database;

  DatabaseHelper._init();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB('form_data.db');
    return _database!;
  }

  Future<Database> _initDB(String filePath) async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, filePath);

    return await openDatabase(path, version: 1, onCreate: _createDB);
  }

  Future _createDB(Database db, int version) async {
    await db.execute('''
      CREATE TABLE form_data (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        key TEXT NOT NULL,
        value TEXT NOT NULL
      )
    ''');
  }

  Future<void> saveData(String key, String value) async {
    final db = await instance.database;

    await db.insert(
      'form_data',
      {'key': key, 'value': value},
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<Map<String, String>> fetchAllData() async {
    final db = await instance.database;

    final result = await db.query('form_data');
    return {for (var row in result) row['key'] as String: row['value'] as String};
  }

  Future<void> deleteData(String key) async {
    final db = await instance.database;

    await db.delete('form_data', where: 'key = ?', whereArgs: [key]);
  }
}
