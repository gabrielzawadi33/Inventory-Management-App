// home_page.dart
import 'package:flutter/material.dart';

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Home'),
      ),
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
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => SalesManagementPage(),
                  ),
                );
              },
              )
            Card(
              elevation: 4,
              margin: EdgeInsets.symmetric(vertical: 10),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15.0),
              ),
              child: ListTile(
                title: Text('Customers Part'),
                subtitle: Text('Manage your customers here'),
                trailing: Icon(Icons.arrow_forward),
                onTap: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => SalesManagementPage(),
                  ),
                );
              },
            ),
            ),
          ],
        ),
      ),
    );
  }
}
