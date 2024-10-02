import 'package:flutter/foundation.dart';
import '../helper/customer_dbHelper.dart';
import '../models/customer_models.dart';
import '../service/costumer_service.dart';

class CustomerProvider with ChangeNotifier {
  List<Customer> _customers = [];
  final CustomerService _customerService = CustomerService();
  final DBHelper _dbHelper = DBHelper();

  List<Customer> get customers => _customers;

  // Fetch customers from the local database and try to sync with API if online
  Future<void> fetchCustomers() async {
    try {
      // Load customers from local database
      final dbCustomers = await _dbHelper.getCustomers();
      _customers = dbCustomers;

      // Sync local customers with the server when internet is available
      if (await _customerService.hasInternetConnection()) {
        // Sync each customer from the local database with the API
        for (Customer customer in _customers) {
          await _customerService.syncCustomer(customer);
        }

        // Fetch customers from the API and store them in the local database
        final fetchedCustomers = await _customerService.fetchCustomers(_customers.first.userId);
        for (Customer customer in fetchedCustomers) {
          await _dbHelper.insertCustomer(customer); // Store in SQLite
        }

        // Update provider list with the newly fetched customers
        _customers = fetchedCustomers;
      }

      notifyListeners();
    } catch (error) {
      print('Error fetching customers: $error');
    }
  }

  // Add a new customer, save offline, and sync with server if online
  Future<void> addCustomer(Customer customer) async {
    await _dbHelper.insertCustomer(customer); // Save to local database

    // Sync with server when internet is available
    if (await _customerService.hasInternetConnection()) {
      try {
        await _customerService.syncCustomer(customer); // Sync with server
      } catch (error) {
        print('Error syncing customer: $error');
      }
    }

    _customers.add(customer);
    notifyListeners();
  }
}
