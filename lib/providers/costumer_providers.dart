import 'package:flutter/material.dart';
import '../helper/customer_dbHelper.dart';
import '../models/customer_models.dart';

class CustomerProvider with ChangeNotifier {
  List<Customer> _customers = [];
  final DBHelper _dbHelper = DBHelper();

  List<Customer> get customers => _customers;

  Future<void> fetchCustomers() async {
    _customers = await _dbHelper.getCustomers();
    print("Fetched customers: $_customers"); // Debugging: Print fetched customers
    notifyListeners();
  }

  Future<void> addCustomer(Customer customer) async {
    await _dbHelper.insertCustomer(customer);
    print("Added customer: ${customer.name}"); // Debugging: Print the added customer
    await fetchCustomers(); // Refresh the list
  }
}
