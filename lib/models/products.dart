// product.dart
class Product {
  final String id;
  final String name;
  final double price;

  Product({required this.id, required this.name, required this.price});
}

// sale.dart
class Sale {
  final List<Product> products;

  Sale({required this.products});

  double get totalPrice => products.fold(0, (total, product) => total + product.price);
}
