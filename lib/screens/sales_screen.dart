import 'package:flutter/material.dart';

import '../helper/saleDb_Helper.dart';

class SalesManagementPage extends StatefulWidget {
  @override
  _SalesManagementPageState createState() => _SalesManagementPageState();
}

class _SalesManagementPageState extends State<SalesManagementPage> {
  final DatabaseHelper _dbHelper = DatabaseHelper();
  final TextEditingController _productNameController = TextEditingController();
  final TextEditingController _priceController = TextEditingController();
  List<Map<String, dynamic>> _sales = [];
  double _totalPrice = 0.0;

  @override
  void initState() {
    super.initState();
    _refreshSales();
  }

  Future<void> _refreshSales() async {
    _sales = await _dbHelper.getSales();
    _totalPrice = await _dbHelper.getTotalPrice();
    setState(() {});
  }

  Future<void> _addSale() async {
    final String productName = _productNameController.text;
    final double? price = double.tryParse(_priceController.text);

    if (productName.isNotEmpty && price != null) {
      await _dbHelper.insertSale(productName, price);
      _productNameController.clear();
      _priceController.clear();
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
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _productNameController,
                    decoration: InputDecoration(labelText: 'Product Name'),
                  ),
                ),
                Expanded(
                  child: TextField(
                    controller: _priceController,
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(labelText: 'Price'),
                  ),
                ),
                IconButton(
                  icon: Icon(Icons.add),
                  onPressed: _addSale,
                ),
              ],
            ),
          ),
          Text('Total Price: \$${_totalPrice.toStringAsFixed(2)}'),
          Expanded(
            child: ListView.builder(
              itemCount: _sales.length,
              itemBuilder: (context, index) {
                final sale = _sales[index];
                return ListTile(
                  title: Text(sale['productName']),
                  subtitle: Text('\$${sale['price']}'),
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
