// import 'package:flutter/material.dart';
// import '../models/products.dart';
// import '../helper/saleDb_Helper.dart';

// class SalesProvider with ChangeNotifier {
//   List<Sale> _sales = [];
//   List<Product> _currentProducts = [];
//   final DatabaseHelper _dbHelper = DatabaseHelper();

//   List<Sale> get sales => _sales;
//   List<Product> get currentProducts => _currentProducts;

//   SalesProvider() {
//     loadSales();
//   }

//   Future<void> loadSales() async {
//     _currentProducts = await _dbHelper.getSales();
//     notifyListeners();
//   }

//   void addProductToSale(Product product) {
//     _currentProducts.add(product);
//     _dbHelper.insertSale(product); // Save to SQLite
//     notifyListeners();
//   }

//   void deleteProductFromSale(String productId) {
//     _currentProducts.removeWhere((product) => product.id == productId);
//     _dbHelper.deleteSale(productId); // Remove from SQLite
//     notifyListeners();
//   }

//   void finalizeSale() {
//     if (_currentProducts.isNotEmpty) {
//       _sales.add(Sale(products: List.from(_currentProducts))); // Create a new Sale
//       _currentProducts.clear(); // Clear current products for the next sale
//       notifyListeners();
//     }
//   }

//   double get totalPrice => _currentProducts.fold(0, (total, product) => total + product.price);
// }
