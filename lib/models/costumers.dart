// models/customer.dart
class Customer {
  final String id;
  final String name;
  final String email;
  final String phoneNumber;

  Customer({
    required this.id,
    required this.name,
    required this.email,
    required this.phoneNumber,
  });

  factory Customer.fromJson(Map<String, dynamic> json) {
    return Customer(
      id: json['id'],
      name: json['name'],
      email: json['email'],
      phoneNumber: json['phone_number'],
    );
  }
}
