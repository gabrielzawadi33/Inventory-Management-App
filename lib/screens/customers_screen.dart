

import 'package:flutter/material.dart';
  import 'package:inventory_app/screens/sales_screen.dart';
  import 'package:provider/provider.dart';
  import '../models/customer_models.dart';
  import 'dart:convert';

  import '../providers/costumer_providers.dart'; // Import to work with JSON

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
    String userId = "";

    @override
    void initState() {
      super.initState();
      Provider.of<CustomerProvider>(context, listen: false).fetchCustomers();
      _getUserId(); // Retrieve user ID on initialization
    }

    void _getUserId() {
      // Simulating the retrieval of user ID from login response
      String loginResponse = '''{"success": true, "error": false, "message": "User login successfully", "user": {"id": "1012", "name": "gabriel", "added_by": "1012", "address": "mabibo", "phone": "321888888", "email": "gab@gmail.com", "last_login": "2024-10-01"}}''';
      
      var jsonResponse = json.decode(loginResponse);
      setState(() {
        userId = jsonResponse['user']['id']; // Extracting user ID
      });
    }

    @override
    Widget build(BuildContext context) {
      final customerProvider = Provider.of<CustomerProvider>(context);

      return Scaffold(
        appBar: AppBar(
          title: const Text('Customers'), 
          actions: [
            IconButton(
              icon: const Icon(Icons.add),
              onPressed: () {
                _showAddCustomerDialog(context);
              },
            ),
          ],
        ),
        body: customerProvider.customers.isEmpty
            ? const Center(child: Text('No customers found.'))
            : ListView.builder(
                itemCount: customerProvider.customers.length,
                itemBuilder: (context, index) {
                  final customer = customerProvider.customers[index];
                  return Container(
                    margin: const EdgeInsets.all(5),
                    color: Colors.green[50],
                    child: InkWell(
                      onTap: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (context) => const SalesManagementPage(),
                          ),
                        );
                      },
                      child: Card(
                        color: Colors.green[50],
                        elevation: 4,
                        child: ListTile(
                          title: Text(customer.name),
                          subtitle: Text('${customer.email}, ${customer.phone}'),
                          trailing: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: <Widget>[
                              IconButton(
                                icon: const Icon(Icons.edit),
                                onPressed: () {
                                  _showEditCustomerDialog(context, customer);
                                },
                              ),
                              IconButton(
                                icon: const Icon(Icons.delete),
                                onPressed: () {
                                  _showDeleteConfirmationDialog(context, customer);
                                },
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  );
                },
              ),
      );
    }

    void _showAddCustomerDialog(BuildContext context) {
      final nameController = TextEditingController();
      final emailController = TextEditingController();
      final phoneController = TextEditingController();
      final addressController = TextEditingController();
      final TINController = TextEditingController();

      showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: const Text('Add Customer'),
            content: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextField(
                    controller: nameController,
                    decoration: const InputDecoration(labelText: 'Name'),
                  ),
                  TextField(
                    controller: emailController,
                    decoration: const InputDecoration(labelText: 'Email'),
                  ),
                  TextField(
                    controller: phoneController,
                    decoration: const InputDecoration(labelText: 'Phone Number'),
                  ),
                  TextField(
                    controller: addressController,
                    decoration: const InputDecoration(labelText: 'Address'),
                  ),
                  TextField(
                    controller: TINController,
                    decoration: const InputDecoration(labelText: 'TIN'),
                  ),
                ],
              ),
            ),
            actions: [
              TextButton(
                onPressed: () {
                  final newCustomer = Customer(
                    id: DateTime.now().toString(),
                    userId: userId, // Set User ID from the session
                    name: nameController.text,
                    address: addressController.text,
                    phone: phoneController.text,
                    email: emailController.text,
                    ownerId: userId, // Set Owner ID to the same value as User ID
                    TIN: TINController.text,
                  );
                  Provider.of<CustomerProvider>(context, listen: false)
                      .addCustomer(newCustomer);
                  Navigator.of(context).pop();
                },
                child: const Text('Add'),
              ),
              TextButton(
                onPressed: () => Navigator.of(context).pop(),
                child: const Text('Cancel'),
              ),
            ],
          );
        },
      );
    }

    void _showEditCustomerDialog(BuildContext context, Customer customer) {
      final nameController = TextEditingController(text: customer.name);
      final emailController = TextEditingController(text: customer.email);
      final phoneController = TextEditingController(text: customer.phone);
      final addressController = TextEditingController(text: customer.address);
      final TINController = TextEditingController(text: customer.TIN);

      showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: const Text('Edit Customer'),
            content: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextField(
                    controller: nameController,
                    decoration: const InputDecoration(labelText: 'Name'),
                  ),
                  TextField(
                    controller: emailController,
                    decoration: const InputDecoration(labelText: 'Email'),
                  ),
                  TextField(
                    controller: phoneController,
                    decoration: const InputDecoration(labelText: 'Phone Number'),
                  ),
                  TextField(
                    controller: addressController,
                    decoration: const InputDecoration(labelText: 'Address'),
                  ),
                  TextField(
                    controller: TINController,
                    decoration: const InputDecoration(labelText: 'TIN'),
                  ),
                ],
              ),
            ),
            actions: [
              TextButton(
                onPressed: () {
                  final updatedCustomer = Customer(
                    id: customer.id,
                    userId: userId,
                    name: nameController.text,
                    address: addressController.text,
                    phone: phoneController.text,
                    email: emailController.text,
                    ownerId: customer.ownerId,
                    TIN: TINController.text,
                  );
                  // Provider.of<CustomerProvider>(context, listen: false)
                  //     .updateCustomer(updatedCustomer);
                  // Navigator.of(context).pop();
                },
                child: const Text('Update'),
              ),
              TextButton(
                onPressed: () => Navigator.of(context).pop(),
                child: const Text('Cancel'),
              ),
            ],
          );
        },
      );
    }

    void _showDeleteConfirmationDialog(BuildContext context, Customer customer) {
      showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: const Text('Delete Customer'),
            content: Text('Are you sure you want to delete ${customer.name}?'),
            actions: [
              TextButton(
                onPressed: () {
                  // Provider.of<CustomerProvider>(context, listen: false)
                  //     .deleteCustomer(customer.id);
                  // Navigator.of(context).pop();
                },
                child: const Text('Delete'),
              ),
              TextButton(
                onPressed: () => Navigator.of(context).pop(),
                child: const Text('Cancel'),
              ),
            ],
          );
        },
      );
    }
  }
