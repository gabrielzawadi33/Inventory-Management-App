// main.dart
import 'package:flutter/material.dart';
import 'package:inventory_app/screens/sales_screen.dart';
import 'package:provider/provider.dart';

import '../models/customer_models.dart';
import '../providers/costumer_providers.dart';
void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => CustomerProvider(),
      child: MaterialApp(
        title: 'Customer Management',
        theme: ThemeData(primarySwatch: Colors.green),
        home: CustomerListScreen(),
      ),
    );
  }
}

class CustomerListScreen extends StatefulWidget {
  static const routeName = '/customers'; 
  @override
  _CustomerListScreenState createState() => _CustomerListScreenState();
}

class _CustomerListScreenState extends State<CustomerListScreen> {
  @override
  void initState() {
    super.initState();
    Provider.of<CustomerProvider>(context, listen: false).fetchCustomers();
  }

  @override
  Widget build(BuildContext context) {
    final customerProvider = Provider.of<CustomerProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text('Customers'),
        actions: [
          IconButton(
            icon: Icon(Icons.add),
            onPressed: () {
              _showAddCustomerDialog(context);
            },
          ),
        ],
      ),
      body: customerProvider.customers.isEmpty
          ? Center(child: Text('No customers found.'))
          : 
          ListView.builder(
            itemCount: customerProvider.customers.length,
            itemBuilder: (context, index) {
              final customer = customerProvider.customers[index];
              return Container(
                margin: EdgeInsets.all(5),
                color: Colors.green[50],
                child: InkWell(
                  onTap: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) => SalesManagementPage(),
                      ),
                    );
                  },
                  child: ListTile(
                    title: Text(customer.name),
                    subtitle: Text('${customer.email}, ${customer.phoneNumber}'),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: <Widget>[
                        IconButton(
                          icon: Icon(Icons.edit),
                          onPressed: () {
                            // Implement your edit functionality here
                          },
                        ),
                        IconButton(
                          icon: Icon(Icons.delete),
                          onPressed: () {
                            // Implement your delete functionality here
                          },
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
          ),
    );
  }

  void _showAddCustomerDialog(BuildContext context) {
    final _nameController = TextEditingController();
    final _emailController = TextEditingController();
    final _phoneController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Add Customer'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: _nameController,
                decoration: InputDecoration(labelText: 'Name'),
              ),
              TextField(
                controller: _emailController,
                decoration: InputDecoration(labelText: 'Email'),
              ),
              TextField(
                controller: _phoneController,
                decoration: InputDecoration(labelText: 'Phone Number'),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                final newCustomer = Customer(
                  id: DateTime.now().toString(), // Use a unique ID
                  name: _nameController.text,
                  email: _emailController.text,
                  phoneNumber: _phoneController.text,
                );
                Provider.of<CustomerProvider>(context, listen: false).addCustomer(newCustomer);
                Navigator.of(context).pop();
              },
              child: Text('Add'),
            ),
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text('Cancel'),
            ),
          ],
        );
      },
    );
  }
}
