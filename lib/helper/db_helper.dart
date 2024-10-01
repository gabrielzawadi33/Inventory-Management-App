// services/db_helper.dart
import 'dart:async';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

import '../models/customer_models.dart';

class DBHelper {
  static final DBHelper _instance = DBHelper._internal();
  factory DBHelper() => _instance;

  DBHelper._internal();

  static Database? _database;

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB();
    return _database!;
  }

  Future<Database> _initDB() async {
    String path = join(await getDatabasesPath(), 'customers.db');
    return await openDatabase(
      path,
      version: 1,
      onCreate: (db, version) async {
        await db.execute('''
          CREATE TABLE customers(
            id TEXT PRIMARY KEY,
            name TEXT,
            email TEXT,
            phone_number TEXT
          )
        ''');
      },
    );
  }

  Future<void> insertCustomer(Customer customer) async {
    final db = await database;
    await db.insert('customers', customerToMap(customer), conflictAlgorithm: ConflictAlgorithm.replace);
  }
  

  Future<List<Customer>> getCustomers() async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query('customers');
    return List.generate(maps.length, (i) {
      return Customer(
        id: maps[i]['id'],
        name: maps[i]['name'],
        email: maps[i]['email'],
        phoneNumber: maps[i]['phone_number'],
      );
    });
  }

  Map<String, dynamic> customerToMap(Customer customer) {
    return {
      'id': customer.id,
      'name': customer.name,
      'email': customer.email,
      'phone_number': customer.phoneNumber,
    };
  }
}
