// database_helper.dart
import 'dart:async';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

import '../models/products.dart';

class DatabaseHelper {
  static final DatabaseHelper _instance = DatabaseHelper._internal();
  static Database? _database;

  factory DatabaseHelper() {
    return _instance;
  }

  DatabaseHelper._internal();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    String path = join(await getDatabasesPath(), 'sales_database.db');
    return await openDatabase(
      path,
      version: 1,
      onCreate: (db, version) async {
        await db.execute('''
          CREATE TABLE sales (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            product_id TEXT,
            product_name TEXT,
            product_price REAL
          )
        ''');
      },
    );
  }

  Future<void> insertSale(Product product) async {
    final db = await database;
    await db.insert(
      'sales',
      {
        'product_id': product.id,
        'product_name': product.name,
        'product_price': product.price,
      },
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<List<Product>> getSales() async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query('sales');
    return List.generate(maps.length, (i) {
      return Product(
        id: maps[i]['product_id'],
        name: maps[i]['product_name'],
        price: maps[i]['product_price'],
      );
    });
  }

  Future<void> deleteSale(String productId) async {
    final db = await database;
    await db.delete(
      'sales',
      where: 'product_id = ?',
      whereArgs: [productId],
    );
  }

  Future<void> clearSales() async {
    final db = await database;
    await db.delete('sales');
  }
}
