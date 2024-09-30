// providers/customer_provider.dart
import 'package:flutter/material.dart';

import '../models/customer_models.dart';
import '../helper/db_helper.dart';

class CustomerProvider with ChangeNotifier {
  List<Customer> _customers = [];
  final DBHelper _dbHelper = DBHelper();

  List<Customer> get customers => _customers;

  Future<void> fetchCustomers() async {
    _customers = await _dbHelper.getCustomers();
    notifyListeners();
  }

  Future<void> addCustomer(Customer customer) async {
    await _dbHelper.insertCustomer(customer);
    await fetchCustomers(); // Refresh the list
  }
}
