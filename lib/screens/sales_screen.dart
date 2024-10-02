import 'package:flutter/material.dart';
import '../helper/customer_dbHelper.dart';
import '../helper/product_database_Helper.dart';
import '../helper/saleDb_Helper.dart';
import '../helper/transaction.dart';
import '../models/customer_models.dart';

class SalesManagementPage extends StatefulWidget {
  const SalesManagementPage({super.key});

  @override
  _SalesManagementPageState createState() => _SalesManagementPageState();
}

class _SalesManagementPageState extends State<SalesManagementPage> {
  final DatabaseHelper _dbHelper = DatabaseHelper();
  final DBHelper _customerDbHelper = DBHelper();
  final TransactionDBHelper _transactionDbHelper = TransactionDBHelper();
  final ProductDBHelper _productDbHelper = ProductDBHelper();

  List<Map<String, dynamic>> _sales = [];
  List<Map<String, dynamic>> _transactions = [];
  List<Map<String, dynamic>> _products = [];
  double _totalPrice = 0.0;
  Map<String, double> _customerTotalPrices = {};
  Map<String, List<Map<String, dynamic>>> _customerTransactions = {};

  List<String> _selectedProducts = [];
  String? _selectedCustomerId;
  List<Customer> _customers = [];

  @override
  void initState() {
    super.initState();
    _refreshSales();
    _fetchCustomers();
    _fetchTransactions();
    _fetchProducts();
  }

  Future<void> _fetchCustomers() async {
    _customers = await _customerDbHelper.getCustomers();
    setState(() {});
  }

  Future<void> _fetchTransactions() async {
    _transactions = await _transactionDbHelper.getTransactions();
    setState(() {});
  }

  Future<void> _fetchProducts() async {
    _products = await _productDbHelper.getProducts(); 
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
      double totalTransactionPrice = 0.0;

      for (var productName in _selectedProducts) {
        final double? price = _products.firstWhere((product) => product['name'] == productName)['price'];
        if (price != null) {
          await _dbHelper.insertSaleWithCustomer(productName, price, _selectedCustomerId!);
          totalTransactionPrice += price;
        }
      }

      await _transactionDbHelper.insertTransaction(
        _customers.firstWhere((customer) => customer.id == _selectedCustomerId).name,
        _selectedProducts,
        totalTransactionPrice,
      );

      _selectedProducts.clear();
      _selectedCustomerId = null;
      _refreshSales();
      _fetchTransactions();
    }
  }


  Future<void> _deleteTransaction(int id) async {
    await _transactionDbHelper.deleteTransaction(id);
    _fetchTransactions();
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
        title: const Text('Sales Management'),
      ),
      body: Column(
        children: [
          Card(
            child: Padding(
              padding: const EdgeInsets.all(8),
              child: Column(
                children: [
                  _customers.isEmpty
                      ? const CircularProgressIndicator()
                      : DropdownButton<String>(
                          value: _selectedCustomerId,
                          hint: const Text('Select Customer'),
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
                      const Text('Select Products:'),
                      Wrap(
                        spacing: 8.0,
                        children: _products.isEmpty
                            ? [const CircularProgressIndicator()]
                            : _products.map((product) {
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
                  ElevatedButton(
                    onPressed: _addSale,
                    child: const Text('Confirm Transaction'),
                  ),
                  const SizedBox(height: 8),
                  const Text('Sales List:', style: TextStyle(fontWeight: FontWeight.bold)),
                ],
              ),
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: _transactions.length,
              itemBuilder: (context, index) {
                final transaction = _transactions[index];
                return Card(
                  color: Colors.green[50],
                  child: ListTile(
                    title: Text('Customer Name: ${transaction['customerName']}'),
                    subtitle: Text('Products Sold: ${transaction['productNames']}\nTotal Price: \Tsh ${transaction['totalPrice']}'),
                    trailing: IconButton(
                      icon: const Icon(Icons.delete),
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
