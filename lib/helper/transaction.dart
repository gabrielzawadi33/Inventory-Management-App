import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class TransactionDBHelper {
  static final TransactionDBHelper _instance = TransactionDBHelper._internal();
  static Database? _database;

  factory TransactionDBHelper() {
    return _instance;
  }

  TransactionDBHelper._internal();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB();
    return _database!;
  }

  Future<Database> _initDB() async {
    String path = join(await getDatabasesPath(), 'transactions.db');
    return await openDatabase(
      path,
      version: 1,
      onCreate: (db, version) async {
        await db.execute('''
          CREATE TABLE transactions(
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            customerName TEXT,
            productNames TEXT,
            totalPrice REAL,
            dateTime TEXT
          )
        ''');
      },
    );
  }

  Future<void> insertTransaction(String customerName, List<String> productNames, double totalPrice) async {
    final db = await database;
    await db.insert('transactions', {
      'customerName': customerName,
      'productNames': productNames.join(', '), // Join product names into a single string
      'totalPrice': totalPrice,
      'dateTime': DateTime.now().toIso8601String(), // Store the current date and time
    });
  }

  Future<List<Map<String, dynamic>>> getTransactions() async {
    final db = await database;
    return await db.query('transactions', orderBy: 'dateTime DESC');
  }

  Future<void> deleteTransaction(int id) async {
    final db = await database;
    await db.delete('transactions', where: 'id = ?', whereArgs: [id]);
  }
}
