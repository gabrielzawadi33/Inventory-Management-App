import 'dart:convert';
import 'package:http/http.dart' as http;

import '../models/customer_models.dart';

class ApiService {
  final String userId = '1012';
  
  String get apiUrl => 'https://app.ema.co.tz/api/ema/pos/get_client/$userId/index';

  Future<List<Customer>> fetchCustomers() async {
    final response = await http.get(Uri.parse(apiUrl));
    if (response.statusCode == 200) {
      // Parse the response as a Map
      Map<String, dynamic> data = json.decode(response.body);
      
      // Assuming the list of customers is under a field called 'customers' in the API response
      if (data.containsKey('customers')) {
        List<dynamic> customerList = data['customers'];
        return customerList.map((customer) => Customer.fromJson(customer)).toList();
      } else {
        throw Exception('Customers data not found in the response');
      }
    } else {
      throw Exception('Failed to load customers');
    }
  }

  Future<void> addCustomer(Customer customer) async {
    await http.post(
      Uri.parse(apiUrl),
      headers: {'Content-Type': 'application/json'},
      body: json.encode({
        'name': customer.name,
        'email': customer.email,
        'phone': customer.phoneNumber,
      }),
    );
  }

  Future<void> deleteCustomer(String id) async {
    final deleteUrl = 'https://app.ema.co.tz/api/ema/pos/get_client/$userId/delete/$id';
    await http.delete(Uri.parse(deleteUrl));
  }

  Future<void> updateCustomer(Customer customer) async {
    final updateUrl = 'https://app.ema.co.tz/api/ema/pos/get_client/$userId/update/${customer.id}';
    await http.put(
      Uri.parse(updateUrl),
      headers: {'Content-Type': 'application/json'},
      body: json.encode({
        'name': customer.name,
        'email': customer.email,
        'phone_number': customer.phoneNumber,
      }),
    );
  }
}
