// sales_management_page.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/products.dart';
import '../providers/sales_provider.dart';
class SalesManagementPage extends StatelessWidget {
  final TextEditingController _productIdController = TextEditingController();
  final TextEditingController _productNameController = TextEditingController();
  final TextEditingController _productPriceController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Sales Management'),
        actions: [
          IconButton(
            icon: Icon(Icons.sync),
            onPressed: () {
              Provider.of<SalesProvider>(context, listen: false).syncWithAPI();
            },
          ),
        ],
      ),
      body: Consumer<SalesProvider>(
        builder: (context, salesProvider, child) {
          return Column(
            children: [
              Expanded(
                child: ListView.builder(
                  itemCount: salesProvider.currentProducts.length,
                  itemBuilder: (context, index) {
                    final product = salesProvider.currentProducts[index];
                    return ListTile(
                      title: Text(product.name),
                      subtitle: Text('Price: ${product.price}'),
                      trailing: IconButton(
                        icon: Icon(Icons.delete),
                        onPressed: () {
                          salesProvider.deleteProductFromSale(product.id);
                        },
                      ),
                    );
                  },
                ),
              ),
              Text('Total Price: ${salesProvider.totalPrice}'),
              Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _productIdController,
                      decoration: InputDecoration(labelText: 'Product ID'),
                    ),
                  ),
                  Expanded(
                    child: TextField(
                      controller: _productNameController,
                      decoration: InputDecoration(labelText: 'Product Name'),
                    ),
                  ),
                  Expanded(
                    child: TextField(
                      controller: _productPriceController,
                      decoration: InputDecoration(labelText: 'Product Price'),
                      keyboardType: TextInputType.number,
                    ),
                  ),
                  IconButton(
                    icon: Icon(Icons.add),
                    onPressed: () {
                      final product = Product(
                        id: _productIdController.text,
                        name: _productNameController.text,
                        price: double.tryParse(_productPriceController.text) ?? 0.0,
                      );
                      salesProvider.addProductToSale(product);
                      _productIdController.clear();
                      _productNameController.clear();
                      _productPriceController.clear();
                    },
                  ),
                ],
              ),
              ElevatedButton(
                onPressed: () {
                  salesProvider.finalizeSale();
                },
                child: Text('Finalize Sale'),
              ),
            ],
          );
        },
      ),
    );
  }
}
