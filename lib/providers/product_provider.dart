import 'package:flutter/material.dart';
import '../helper/product_database_Helper.dart';
import '../models/products.dart'; // Assuming this contains your Product model

class ProductProvider with ChangeNotifier {
  List<Product> _products = [];
  
  List<Product> get products => _products;

  final ProductDBHelper _productDbHelper = ProductDBHelper(); // Using ProductDBHelper instance

  // Fetch all products from the database
  Future<void> fetchProducts() async {
    final productMaps = await _productDbHelper.getProducts(); // Fetch products as Map from the DB
    _products = productMaps.map((map) => Product.fromMap(map)).toList(); // Assuming Product model has fromMap method
    notifyListeners();
  }

  // Add a new product and refresh the product list
  Future<void> addProduct(Product product) async {
    await _productDbHelper.insertProduct(product.name, product.price); // Use name and price directly
    await fetchProducts(); // Refresh the list after adding
  }

  // Update an existing product and refresh the product list
  Future<void> updateProduct(Product product) async {
    await _productDbHelper.updateProduct(product.id!, product.name, product.price); // Make sure product has an id
    await fetchProducts(); // Refresh the list after updating
  }

  // Delete a product and refresh the product list
  Future<void> deleteProduct(int id) async {
    await _productDbHelper.deleteProduct(id);
    await fetchProducts(); // Refresh the list after deletion
  }
}
