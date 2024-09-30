import 'package:flutter/material.dart';
import 'package:provider/provider.dart'; 
import 'screens/customers_screen.dart';
import 'package:inventory_app/authentication.dart';

import 'providers/costumer_providers.dart';  

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (ctx) => CustomerProvider()),
      ],
      child: MaterialApp(
        title: 'Flutter Demo',
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
          useMaterial3: true,
        ),
        home: AuthScreen(),
        routes: {
          '/customers': (ctx) => CustomerListScreen(),
        },
      ),
    );
  }
}
