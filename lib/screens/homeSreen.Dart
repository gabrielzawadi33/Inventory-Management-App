// import 'package:flutter/material.dart';

// class HomeScreen extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: Text('Home')),
//       body: Padding(
//         padding: const EdgeInsets.all(16.0),
//         child: ListView(
//           children: [
//             Card(
//               elevation: 4,
//               margin: EdgeInsets.symmetric(vertical: 10),
//               child: ListTile(
//                 title: Text('Sales Part'),
//                 subtitle: Text('Manage your sales here'),
//                 trailing: Icon(Icons.arrow_forward),
//                 onTap: () {
//                   navigateToProductsListScreen(context); // Call the method for navigation
//                 },
//               ),
//             ),
//             Card(
//               elevation: 4,
//               margin: EdgeInsets.symmetric(vertical: 10),
//               child: ListTile(
//                 title: Text('Customers Part'),
//                 subtitle: Text('Manage your customers here'),
//                 trailing: Icon(Icons.arrow_forward),
//                 onTap: () {
//                   navigateToCustomerListScreen(context); // Call the method for navigation
//                 },
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }

//   // Method to navigate to ProductsListScreen
//   void navigateToProductsListScreen(BuildContext context) {
//     Navigator.of(context).pushReplacement(
//       MaterialPageRoute(builder: (context) => ProductsListScreen()), // Replace with your ProductsListScreen
//     );
//   }

//   // Method to navigate to CustomerListScreen
//   void navigateToCustomerListScreen(BuildContext context) {
//     Navigator.of(context).pushReplacement(
//       MaterialPageRoute(builder: (context) => CustomerListScreen()), // Ensure CustomerListScreen is defined
//     );
//   }
// }
