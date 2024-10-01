class Customer {
  final String id;
  final String userId;
  final String name;
  final String address;
  final String phone;
  final String email;
  final String ownerId;
  final String TIN;

  Customer({
    required this.id,
    required this.userId,
    required this.name,
    required this.address,
    required this.phone,
    required this.email,
    required this.ownerId,
    required this.TIN,
  });

  factory Customer.fromJson(Map<String, dynamic> json) {
    return Customer(
      id: json['id'],
      userId: json['user_id'],
      name: json['name'],
      address: json['address'],
      phone: json['phone'],
      email: json['email'],
      ownerId: json['owner_id'],
      TIN: json['TIN'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'user_id': userId,
      'name': name,
      'address': address,
      'phone': phone,
      'email': email,
      'owner_id': ownerId,
      'TIN': TIN,
    };
  }
}
