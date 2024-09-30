// sales_provider.dart
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http; // For making API calls
import 'dart:convert';

import '../models/products.dart';
import '../helper/saleDb_Helper.dart';

class SalesProvider with ChangeNotifier {
  List<Sale> _sales = [];
  List<Product> _currentProducts = [];
  final DatabaseHelper _dbHelper = DatabaseHelper();

  List<Sale> get sales => _sales;
  List<Product> get currentProducts => _currentProducts;

  SalesProvider() {
    loadSales();
  }

  Future<void> loadSales() async {
    _currentProducts = await _dbHelper.getSales();
    notifyListeners();
  }

  void addProductToSale(Product product) {
    _currentProducts.add(product);
    _dbHelper.insertSale(product); // Save to SQLite
    notifyListeners();
  }

  void deleteProductFromSale(String productId) {
    _currentProducts.removeWhere((product) => product.id == productId);
    _dbHelper.deleteSale(productId); // Remove from SQLite
    notifyListeners();
  }

  void finalizeSale() {
    if (_currentProducts.isNotEmpty) {
      _sales.add(Sale(products: List.from(_currentProducts))); // Create a new Sale
      _currentProducts.clear(); // Clear current products for the next sale
      notifyListeners();
    }
  }

  double get totalPrice => _currentProducts.fold(0, (total, product) => total + product.price);

  Future<void> syncWithAPI() async {
    // Here you can implement the logic to sync your local data with the API
    // Example: sending local sales data to the server
    final response = await http.post(
      Uri.parse('https://your-api-endpoint.com/sales'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'sales': _currentProducts.map((product) => {
          'id': product.id,
          'name': product.name,
          'price': product.price,
        }).toList(),
      }),
    );

    if (response.statusCode == 200) {
      // Handle successful sync
      print('Data synced successfully');
    } else {
      // Handle error
      print('Failed to sync data');
    }
  }
}
