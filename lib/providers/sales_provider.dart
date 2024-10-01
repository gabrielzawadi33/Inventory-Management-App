import 'package:flutter/material.dart';
import '../helper/customer_dbHelper.dart';
import '../helper/saleDb_Helper.dart';
import '../models/customer_models.dart';

class SalesManagementPage extends StatefulWidget {
  @override
  _SalesManagementPageState createState() => _SalesManagementPageState();
}

class _SalesManagementPageState extends State<SalesManagementPage> {
  final DatabaseHelper _dbHelper = DatabaseHelper();
  final DBHelper _customerDbHelper = DBHelper();
  List<Map<String, dynamic>> _sales = [];
  double _totalPrice = 0.0;
  Map<String, double> _customerTotalPrices = {}; // To hold total prices by customer

  // Dummy list of products with their prices
  final List<Map<String, dynamic>> _products = [
    {'name': 'Product A', 'price': 50.0},
    {'name': 'Product B', 'price': 100.0},
    {'name': 'Product C', 'price': 150.0},
    {'name': 'Product D', 'price': 200.0},
  ];

  List<String> _selectedProducts = []; // List to hold selected product names
  String? _selectedCustomerId; // To store the selected customer's ID
  List<Customer> _customers = []; // To hold customers from the database

  @override
  void initState() {
    super.initState();
    _refreshSales();
    _fetchCustomers();
  }

  Future<void> _fetchCustomers() async {
    _customers = await _customerDbHelper.getCustomers();
    setState(() {});
  }

  Future<void> _refreshSales() async {
    _sales = await _dbHelper.getSales();
    _totalPrice = await _dbHelper.getTotalPrice();
    _calculateCustomerTotalPrices(); // Calculate totals after refreshing sales
    setState(() {});
  }

  void _calculateCustomerTotalPrices() {
    _customerTotalPrices.clear(); // Clear previous totals
    for (var sale in _sales) {
      final customerId = sale['customerName'];
      final price = sale['price'];

      if (_customerTotalPrices.containsKey(customerId)) {
        _customerTotalPrices[customerId] = _customerTotalPrices[customerId]! + price;
      } else {
        _customerTotalPrices[customerId] = price;
      }
    }
  }

  void _calculateTotalPrice() {
    _totalPrice = 0.0;
    for (var productName in _selectedProducts) {
      final product = _products.firstWhere((product) => product['name'] == productName);
      _totalPrice += product['price'];
    }
    setState(() {});
  }

  Future<void> _addSale() async {
    if (_selectedProducts.isNotEmpty && _selectedCustomerId != null) {
      for (var productName in _selectedProducts) {
        final double? price = _products.firstWhere((product) => product['name'] == productName)['price'];
        if (price != null) {
          await _dbHelper.insertSaleWithCustomer(productName, price, _selectedCustomerId!);
        }
      }
      _selectedProducts.clear();
      _selectedCustomerId = null;
      _refreshSales();
    }
  }

  Future<void> _deleteSale(int id) async {
    await _dbHelper.deleteSale(id);
    _refreshSales();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Sales Management'),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              children: [
                // Dropdown for selecting customers
                _customers.isEmpty
                    ? CircularProgressIndicator()
                    : DropdownButton<String>(
                        value: _selectedCustomerId,
                        hint: Text('Select Customer'),
                        isExpanded: true,
                        items: _customers.map((customer) {
                          return DropdownMenuItem<String>(
                            value: customer.id,
                            child: Text('${customer.name} (${customer.email})'),
                          );
                        }).toList(),
                        onChanged: (String? newValue) {
                          setState(() {
                            _selectedCustomerId = newValue;
                          });
                        },
                      ),
                Column(
                  children: [
                    // Multi-select for products
                    Text('Select Products:'),
                    Wrap(
                      spacing: 8.0,
                      children: _products.map((product) {
                        return ChoiceChip(
                          label: Text(product['name']),
                          selected: _selectedProducts.contains(product['name']),
                          onSelected: (selected) {
                            setState(() {
                              if (selected) {
                                _selectedProducts.add(product['name']);
                              } else {
                                _selectedProducts.remove(product['name']);
                              }
                              _calculateTotalPrice();
                            });
                          },
                        );
                      }).toList(),
                    ),
                  ],
                ),
                // Display total price
                Text('Total Price: \$${_totalPrice.toStringAsFixed(2)}'),
                // Button to confirm transaction
                ElevatedButton(
                  onPressed: _addSale,
                  child: Text('Confirm Transaction'),
                ),
                // Show customer summary after confirming a transaction
                SizedBox(height: 16), // Add space
                Text('Transaction Summary by Customer:', style: TextStyle(fontWeight: FontWeight.bold)),
                ..._customerTotalPrices.entries.map((entry) {
                  return ListTile(
                    title: Text(entry.key),
                    trailing: Text('\$${entry.value.toStringAsFixed(2)}'),
                  );
                }).toList(),
              ],
            ),
          ),
          // Expanded ListView to show transactions
          Expanded(
            child: ListView.builder(
              itemCount: _sales.length,
              itemBuilder: (context, index) {
                final sale = _sales[index];
                return ListTile(
                  title: Text(sale['productName']),
                  subtitle: Text('Customer: ${sale['customerName']}\nPrice: \$${sale['price']}'),
                  trailing: IconButton(
                    icon: Icon(Icons.delete),
                    onPressed: () => _deleteSale(sale['id']),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Sales Management',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: SalesManagementPage(),
    );
  }
}

