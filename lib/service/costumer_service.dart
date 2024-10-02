import 'dart:convert';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:http/http.dart' as http;
import '../models/customer_models.dart';

class CustomerService {
  final String baseUrl = 'https://app.ema.co.tz/api/ema';

  Future<bool> hasInternetConnection() async {
    var connectivityResult = await Connectivity().checkConnectivity();
    return connectivityResult == ConnectivityResult.mobile ||
        connectivityResult == ConnectivityResult.wifi;
  }

  Future<void> syncCustomer(Customer customer) async {
    if (await hasInternetConnection()) {
      final url = Uri.parse('$baseUrl/get_client/${customer.userId}/save');
      final response = await http.post(
        url,
        headers: {
          'Content-Type': 'application/json',
        },
        body: jsonEncode({
          'id': customer.userId,
          'name': customer.name,
          'email': customer.email,
          'phone': customer.phone,
          'TIN': customer.TIN,
          'address': customer.address,
        }),
      );

      if (response.statusCode == 200) {
        print('Customer synced successfully');
      } else {
        print('Failed to sync customer');
        throw Exception('Failed to sync customer data');
      }
    } else {
      print('No internet connection. Cannot sync customer data.');
    }
  }

  Future<List<Customer>> fetchCustomers(String userId) async {
    if (await hasInternetConnection()) {
      final url = Uri.parse('$baseUrl/pos/get_client/$userId/index');
      final response = await http.get(url);

      if (response.statusCode == 200) {
        List<dynamic> data = jsonDecode(response.body);
        return data.map((json) => Customer.fromJson(json)).toList();
      } else {
        throw Exception('Failed to load customers from server');
      }
    } else {
      throw Exception('No internet connection');
    }
  }
}
