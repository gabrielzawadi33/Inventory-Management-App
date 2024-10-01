import 'package:flutter/material.dart';
import '../helper/db_helper.dart';
import '../helper/saleDb_Helper.dart';
import '../helper/transaction.dart';
import '../models/customer_models.dart';

class SalesManagementPage extends StatefulWidget {
  @override
  _SalesManagementPageState createState() => _SalesManagementPageState();
}

class _SalesManagementPageState extends State<SalesManagementPage> {
  final DatabaseHelper _dbHelper = DatabaseHelper();
  final DBHelper _customerDbHelper = DBHelper();
  final TransactionDBHelper _transactionDbHelper = TransactionDBHelper(); // Create instance of transaction DB helper

  List<Map<String, dynamic>> _sales = [];
  List<Map<String, dynamic>> _transactions = []; // List to hold transactions
  double _totalPrice = 0.0;
  Map<String, double> _customerTotalPrices = {};
  Map<String, List<Map<String, dynamic>>> _customerTransactions = {};

  final List<Map<String, dynamic>> _products = [
    {'name': 'Product A', 'price': 50.0},
    {'name': 'Product B', 'price': 100.0},
    {'name': 'Product C', 'price': 150.0},
    {'name': 'Product D', 'price': 200.0},
  ];

  List<String> _selectedProducts = [];
  String? _selectedCustomerId;
  List<Customer> _customers = [];

  @override
  void initState() {
    super.initState();
    _refreshSales();
    _fetchCustomers();
    _fetchTransactions(); // Fetch transactions on startup
  }

  Future<void> _fetchCustomers() async {
    _customers = await _customerDbHelper.getCustomers();
    setState(() {});
  }

  Future<void> _fetchTransactions() async {
    _transactions = await _transactionDbHelper.getTransactions(); // Fetch transactions from the DB
    setState(() {});
  }

  Future<void> _refreshSales() async {
    _sales = await _dbHelper.getSales();
    _totalPrice = await _dbHelper.getTotalPrice();
    _calculateTotalPrices();
    setState(() {});
  }

  Map<String, double> _calculateCustomerTotalPricesWithTransactions() {
    final Map<String, List<Map<String, dynamic>>> customerTransactions = {};
    final Map<String, double> customerTotalPrices = {};

    for (var sale in _sales) {
      final customerName = sale['customerName'];
      final price = sale['price'];

      if (!customerTransactions.containsKey(customerName)) {
        customerTransactions[customerName] = [];
      }
      customerTransactions[customerName]!.add(sale);

      if (customerTotalPrices.containsKey(customerName)) {
        customerTotalPrices[customerName] = customerTotalPrices[customerName]! + price;
      } else {
        customerTotalPrices[customerName] = price;
      }
    }

    _customerTransactions = customerTransactions;
    return customerTotalPrices;
  }

  void _calculateTotalPrices() {
    _customerTotalPrices = _calculateCustomerTotalPricesWithTransactions();
  }

  Future<void> _addSale() async {
    if (_selectedProducts.isNotEmpty && _selectedCustomerId != null) {
      double totalTransactionPrice = 0.0; // Track the total price for the current transaction

      for (var productName in _selectedProducts) {
        final double? price = _products.firstWhere((product) => product['name'] == productName)['price'];
        if (price != null) {
          await _dbHelper.insertSaleWithCustomer(productName, price, _selectedCustomerId!);
          totalTransactionPrice += price; // Add price to the transaction total
        }
      }

      // Insert transaction into the transaction DB
      await _transactionDbHelper.insertTransaction(
        _customers.firstWhere((customer) => customer.id == _selectedCustomerId).name,
        _selectedProducts,
        totalTransactionPrice,
      );

      _selectedProducts.clear();
      _selectedCustomerId = null;
      _refreshSales();
      _fetchTransactions(); // Refresh transactions
    }
  }

  Future<void> _deleteSale(int id) async {
    await _dbHelper.deleteSale(id);
    _refreshSales();
  }

  Future<void> _deleteTransaction(int id) async {
    await _transactionDbHelper.deleteTransaction(id);
    _fetchTransactions(); // Refresh transactions after deletion
  }

  void _showCustomerTransactions(BuildContext context, String customerName) {
    final transactions = _customerTransactions[customerName] ?? [];

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Transactions for $customerName'),
          content: Container(
            width: double.maxFinite,
            child: ListView.builder(
              itemCount: transactions.length,
              itemBuilder: (context, index) {
                final transaction = transactions[index];
                return ListTile(
                  title: Text(transaction['productName']),
                  subtitle: Text('Price: \$${transaction['price'].toStringAsFixed(2)}'),
                );
              },
            ),
          ),
          actions: [
            TextButton(
              child: Text('Close'),
              onPressed: () => Navigator.of(context).pop(),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Sales Management'),
      ),
      body: Column(
        children: [
          Card(
            child: Padding(
              padding: const EdgeInsets.all(8),
              child: Column(
                children: [
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
                              });
                            },
                          );
                        }).toList(),
                      ),
                    ],
                  ),
                  Text('Total Price: \$${_totalPrice.toStringAsFixed(2)}'),
                  ElevatedButton(
                    onPressed: _addSale,
                    child: Text('Confirm Transaction'),
                  ),
                  SizedBox(height: 8), // Reduced height for better spacing
                  Text('Transaction Summary by Customer:', style: TextStyle(fontWeight: FontWeight.bold)),
                ],
              ),
            ),
          ),
          // List of transactions starts immediately after the summary text
          Expanded(
            child: ListView.builder(
              itemCount: _transactions.length,
              itemBuilder: (context, index) {
                final transaction = _transactions[index];
                return Card(
                  child: ListTile(
                    title: Text('Customer: ${transaction['customerName']}'),
                    subtitle: Text('Products: ${transaction['productNames']}\nTotal: \$${transaction['totalPrice']}'),
                    trailing: IconButton(
                      icon: Icon(Icons.delete),
                      onPressed: () => _deleteTransaction(transaction['id']),
                    ),
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
