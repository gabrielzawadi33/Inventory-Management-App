// helper/saleDb_Helper.dart
import 'dart:async';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DatabaseHelper {
  static final DatabaseHelper _instance = DatabaseHelper._internal();
  factory DatabaseHelper() => _instance;

  DatabaseHelper._internal();

  static Database? _database;

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB();
    return _database!;
  }

  Future<Database> _initDB() async {
    String path = join(await getDatabasesPath(), 'sales_  stomers.db');
    return await openDatabase(
      path,
      version: 1,
      onCreate: (db, version) async {
        // Create the customers table
        await db.execute('''
          CREATE TABLE customers(
            id TEXT PRIMARY KEY,
            name TEXT,
            email TEXT,
            phone_number TEXT
          )
        ''');

        // Create the sales table with a foreign key to the customers table
        await db.execute('''
          CREATE TABLE sales(
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            productName TEXT,
            price REAL,
            customerId TEXT,
            FOREIGN KEY(customerId) REFERENCES customers(id)
          )
        ''');
      },
    );
  }

  // Method to insert a sale with a customer reference
  Future<void> insertSaleWithCustomer(String productName, double price, String customerId) async {
    final db = await database;
    await db.insert(
      'sales',
      {
        'productName': productName,
        'price': price,
        'customerId': customerId,
      },
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  // Method to get all sales with customer information
  Future<List<Map<String, dynamic>>> getSales() async {
    final db = await database;
    return await db.rawQuery('''
      SELECT sales.id, sales.productName, sales.price, customers.name AS customerName, customers.email AS customerEmail 
      FROM sales 
      JOIN customers ON sales.customerId = customers.id
    ''');
  }

  // Method to get the total price of all sales
  Future<double> getTotalPrice() async {
    final db = await database;
    var result = await db.rawQuery('SELECT SUM(price) as totalPrice FROM sales');
    return result[0]['totalPrice'] != null ? result[0]['totalPrice'] as double : 0.0;
  }

  // Method to delete a sale by its ID
  Future<void> deleteSale(int id) async {
    final db = await database;
    await db.delete('sales', where: 'id = ?', whereArgs: [id]);
  }
}
