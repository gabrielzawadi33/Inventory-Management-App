import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

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
              icon: const Icon(Icons.logout, size: 30, color: Colors.black),
              onPressed: () async {
                final prefs = await SharedPreferences.getInstance();
                await prefs.clear();
                Navigator.of(context).pushReplacementNamed('/auth');
              },
            ),
          ),
        ],
        leading: const Icon(Icons.menu, color: Colors.black),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: [

                        Card(
              elevation: 4,
              margin: const EdgeInsets.symmetric(vertical: 10),
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
                        const Text('Customers ', style: TextStyle(fontSize: 24)),
                        const Text('Manage your customers here'),
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
                    Navigator.of(context).pushNamed('/products');
                  },
                  child: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.local_offer,
                            size: 50, color: Colors.green.withOpacity(0.5)),
                        const Text('Products', style: TextStyle(fontSize: 24)),
                        const Text('Manage your Products Here'),
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
                        const Text('Sales', style: TextStyle(fontSize: 24)),
                        const Text('Manage your sales here'),
                      ],
                    ),
                  ),
                ),
              ),
            ),

          ],
        ),
      ),
    );
  }
}
