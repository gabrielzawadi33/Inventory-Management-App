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
          user_id TEXT,  
          name TEXT,
          address TEXT,
          phone TEXT,
          email TEXT,
          owner_id TEXT,
          TIN TEXT
        )
      ''');
    },
  );
}


  Future<void> insertCustomer(Customer customer) async {
    final db = await database;
    int result = await db.insert(
      'customers',
      customerToMap(customer),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
    print("Insert result: $result"); // Debugging: Print result of insertion
  }

  Future<List<Customer>> getCustomers() async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query('customers');
    print("DB query result: $maps"); // Debugging: Print result of the query

    return List.generate(maps.length, (i) {
      return Customer(
        id: maps[i]['id'],
        userId: maps[i]['user_id'],
        name: maps[i]['name'],
        address: maps[i]['address'],
        phone: maps[i]['phone'],
        email: maps[i]['email'],
        ownerId: maps[i]['owner_id'],
        TIN: maps[i]['TIN'],
      );
    });
  }

  Map<String, dynamic> customerToMap(Customer customer) {
    return {
      'id': customer.id,
      'user_id': customer.userId,
      'name': customer.name,
      'address': customer.address,
      'phone': customer.phone,
      'email': customer.email,
      'owner_id': customer.ownerId,
      'TIN': customer.TIN,
    };
  }
}
