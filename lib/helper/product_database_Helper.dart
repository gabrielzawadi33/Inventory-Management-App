import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class ProductDBHelper {
  // Singleton pattern
  static final ProductDBHelper _instance = ProductDBHelper._internal();
  factory ProductDBHelper() => _instance;

  ProductDBHelper._internal();

  Database? _database;

  // Get database instance (initialize if not already created)
  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB();
    return _database!;
  }

  // Initialize the database
  Future<Database> _initDB() async {
    String path = join(await getDatabasesPath(), 'products.db');

    return await openDatabase(
      path,
      version: 2, // Update version for migrations
      onCreate: (db, version) async {
        await _createTables(db);
      },
      onUpgrade: (db, oldVersion, newVersion) async {
        if (oldVersion < 2) {
          await _addTimestampColumns(db);
        }
      },
    );
  }

  // Create the initial products table
  Future<void> _createTables(Database db) async {
    await db.execute('''
      CREATE TABLE products (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        name TEXT NOT NULL,
        price REAL NOT NULL,
        created_at TEXT, 
        updated_at TEXT
      )
    ''');
  }

  // Add new columns (for migration purposes)
  Future<void> _addTimestampColumns(Database db) async {
    await db.execute('ALTER TABLE products ADD COLUMN created_at TEXT');
    await db.execute('ALTER TABLE products ADD COLUMN updated_at TEXT');
  }

  // Fetch all products from the database
  Future<List<Map<String, dynamic>>> getProducts() async {
    final db = await database;
    try {
      return await db.query('products');
    } catch (e) {
      print("Error fetching products: $e");
      return [];
    }
  }

  // Insert a new product into the database with automatic timestamps
  Future<void> insertProduct(String name, double price) async {
    final db = await database;
    final timestamp = DateTime.now().toIso8601String();

    try {
      await db.insert(
        'products',
        {
          'name': name,
          'price': price,
          'created_at': timestamp,
          'updated_at': timestamp,
        },
        conflictAlgorithm: ConflictAlgorithm.replace,
      );
    } catch (e) {
      print("Error inserting product: $e");
    }
  }

  // Update an existing product and modify the updated_at timestamp
  Future<void> updateProduct(int id, String name, double price) async {
    final db = await database;
    final timestamp = DateTime.now().toIso8601String();

    try {
      await db.update(
        'products',
        {
          'name': name,
          'price': price,
          'updated_at': timestamp, // only update timestamp
        },
        where: 'id = ?',
        whereArgs: [id],
      );
    } catch (e) {
      print("Error updating product: $e");
    }
  }

  // Delete a product from the database by ID
  Future<void> deleteProduct(int id) async {
    final db = await database;
    try {
      await db.delete(
        'products',
        where: 'id = ?',
        whereArgs: [id],
      );
    } catch (e) {
      print("Error deleting product: $e");
    }
  }

}
