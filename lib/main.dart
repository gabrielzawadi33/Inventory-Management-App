import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'authentication.dart';
import 'providers/costumer_providers.dart';
import 'screens/customers_screen.dart';
import 'screens/sales_screen.dart';

void main() async {
  WidgetsFlutterBinding
      .ensureInitialized(); // Ensure Flutter binding is initialized
  final prefs = await SharedPreferences.getInstance();
  final isLoggedIn = prefs.getBool('isLoggedIn') ?? false;

  // Create an instance of MyApp and call printStoredData
  MyApp app = MyApp(isLoggedIn: isLoggedIn);
  await app.printStoredData();

  runApp(app);
}

class MyApp extends StatelessWidget {
  final bool isLoggedIn;

// Function to print the stored data
  Future<void> printStoredData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    // Retrieve and print the login status
    bool? isLoggedIn = prefs.getBool('isLoggedIn');
    print('Is Logged In: $isLoggedIn');

    // Retrieve and print the user information
    String? userJson = prefs.getString('user');
    if (userJson != null) {
      Map<String, dynamic> user = jsonDecode(userJson);
      print('User Info: $user');
    } else {
      print('No user data stored.');
    }
  }

  const MyApp({Key? key, required this.isLoggedIn}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [ChangeNotifierProvider(create: (ctx) => CustomerProvider())],
      child: MaterialApp(
        title: 'Flutter Demo',
        theme: ThemeData(
            colorScheme: ColorScheme.fromSeed(seedColor: Colors.green[50]!)),
        initialRoute: isLoggedIn ? '/home' : '/auth', // Check login status
        routes: {
          '/auth': (ctx) => AuthScreen(),
          '/customers': (ctx) => CustomerListScreen(),
          '/sales': (ctx) => SalesManagementPage(),
          '/home': (ctx) => HomeScreen(),
        },
      ),
    );
  }
}

class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Inventory Management',
          style: TextStyle(color: Colors.black, fontSize: 15),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 20.0),
            child: IconButton(
              icon: Icon(Icons.logout, size: 30, color: Colors.black),
              onPressed: () async {
                final prefs = await SharedPreferences.getInstance();
                await prefs.clear();
                Navigator.of(context).pushReplacementNamed('/auth');
              },
            ),
          ),
          
        ],
        leading: Icon(Icons.menu, color: Colors.black),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: [
            Card(
              elevation: 4,
              child: Container(
                color: Colors.green.withOpacity(0.1),
                height: 200,
                child: InkWell(
                  onTap: () {
                    Navigator.of(context).pushNamed('/sales');
                  },
                  child: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.monetization_on,
                          size: 50,
                          color: Colors.green.withOpacity(0.5),
                        ),
                        Text('Sales Part', style: TextStyle(fontSize: 24)),
                        Text('Manage your sales here'),
                      ],
                    ),
                  ),
                ),
              ),
            ),
            Card(
              elevation: 4,
              margin: EdgeInsets.symmetric(vertical: 10),
              child: Container(
                color: Colors.green.withOpacity(0.1),
                height: 200,
                child: InkWell(
                  onTap: () {
                    Navigator.of(context).pushNamed('/customers');
                  },
                  child: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.people,
                            size: 50, color: Colors.green.withOpacity(0.5)),
                        Text('Customers Part', style: TextStyle(fontSize: 24)),
                        Text('Manage your customers here'),
                      ],
                    ),
                  ),
                ),
              ),
            ),
            Card(
              elevation: 4,
              child: Container(
                color: Colors.green.withOpacity(0.1),
                height: 200,
                child: InkWell(
                  onTap: () {
                    // Add the logout logic here
                  },
                  child: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.local_offer,
                            size: 50, color: Colors.green.withOpacity(0.5)),
                        Text('Products', style: TextStyle(fontSize: 24)),
                        Text('Manage your Products Here'),
                      ],
                    ),
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
