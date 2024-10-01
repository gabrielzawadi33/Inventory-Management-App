class Product {
  final int? id;
  final String name;
  final double price;

  Product({this.id, required this.name, required this.price});

  // Convert a Product into a Map.
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'price': price,
    };
  }

  // Factory method to create a Product from a Map
  factory Product.fromMap(Map<String, dynamic> map) {
    return Product(
      id: map['id'],
      name: map['name'],
      price: map['price'],
    );
  }

  @override
  String toString() {
    return 'Product{id: $id, name: $name, price: $price}';
  }
}
