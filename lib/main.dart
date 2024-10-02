import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'authentication.dart';
import 'providers/costumer_providers.dart';
import 'providers/product_provider.dart';
import 'screens/customers_screen.dart';
import 'screens/product_screen.dart';
import 'screens/sales_screen.dart';
import 'screens/homeSreen.dart';

void main() async {
  WidgetsFlutterBinding
      .ensureInitialized(); 
  final prefs = await SharedPreferences.getInstance();
  final isLoggedIn = prefs.getBool('isLoggedIn') ?? false;

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
      providers: [
        ChangeNotifierProvider(create: (ctx) => CustomerProvider()),
        ChangeNotifierProvider(create: (ctx) => ProductProvider())
      ],
      child: MaterialApp(
        title: 'Flutter Demo',
        theme: ThemeData(
            colorScheme: ColorScheme.fromSeed(seedColor: Colors.green[50]!)),
        initialRoute: isLoggedIn ? '/home' : '/home',
        routes: {
          '/auth': (ctx) => AuthScreen(),
          '/customers': (ctx) => CustomerListScreen(),
          '/sales': (ctx) => SalesManagementPage(),
          '/home': (ctx) => HomeScreen(),
          '/products': (ctx) => ProductPage(),
        },
      ),
    );
  }
}
