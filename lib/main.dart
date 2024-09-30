import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'authentication.dart';
import 'providers/costumer_providers.dart';
import 'screens/customers_screen.dart';
import 'screens/sales_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [ChangeNotifierProvider(create: (ctx) => CustomerProvider())],
      child: MaterialApp(
        title: 'Flutter Demo',
        theme: ThemeData(colorScheme: ColorScheme.fromSeed(seedColor: Colors.green[50]!)),
        initialRoute: '/auth',
        routes: {
          '/auth': (ctx) => AuthScreen(),
          '/customers': (ctx) => CustomerListScreen(),
          '/sales': (ctx) => SalesManagementPage(),
          '/home': (ctx) => HomeScreen(), // Updated the route to '/home'
        },
      ),
    );
  }
}

class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Home')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: [
            Card(
              elevation: 4,
              margin: EdgeInsets.symmetric(vertical: 10),
              child: ListTile(
                title: Text('Sales Part'),
                subtitle: Text('Manage your sales here'),
                trailing: Icon(Icons.arrow_forward),
                onTap: () {
                  Navigator.of(context).pushReplacementNamed('/sales'); // Use named route
                },
              ),
            ),
            Card(
              elevation: 4,
              margin: EdgeInsets.symmetric(vertical: 10),
              child: ListTile(
                title: Text('Customers Part'),
                subtitle: Text('Manage your customers here'),
                trailing: Icon(Icons.arrow_forward),
                onTap: () {
                  Navigator.of(context).pushReplacementNamed('/customers'); // Use named route
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
