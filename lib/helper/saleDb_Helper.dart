import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DatabaseHelper {
  static final DatabaseHelper _instance = DatabaseHelper._internal();
  factory DatabaseHelper() => _instance;

  static Database? _database;

  DatabaseHelper._internal();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    String path = join(await getDatabasesPath(), 'sales.db');
    return await openDatabase(
      path,
      version: 1,
      onCreate: (db, version) async {
        await db.execute('''
          CREATE TABLE sales(
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            productName TEXT,
            price REAL
          )
        ''');
      },
    );
  }

  Future<void> insertSale(String productName, double price) async {
    final db = await database;
    await db.insert(
      'sales',
      {'productName': productName, 'price': price},
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<List<Map<String, dynamic>>> getSales() async {
    final db = await database;
    return await db.query('sales');
  }

  Future<void> deleteSale(int id) async {
    final db = await database;
    await db.delete('sales', where: 'id = ?', whereArgs: [id]);
  }

  Future<double> getTotalPrice() async {
    final db = await database;
    final result = await db.rawQuery('SELECT SUM(price) AS total FROM sales');
    return result.isNotEmpty ? result.first['total'] as double : 0.0;
  }
}
