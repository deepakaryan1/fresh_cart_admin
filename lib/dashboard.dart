import 'package:flutter/material.dart';
import 'products_page.dart';
import 'suppliers_page.dart';
import 'orders_page.dart';

class DashboardPage extends StatefulWidget {
  const DashboardPage({super.key});

  @override
  State<DashboardPage> createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  int selectedIndex = 0;

  final pages = const [ProductsPage(), SuppliersPage(), OrdersPage()];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Row(
        children: [
          NavigationRail(
            backgroundColor: Colors.blueGrey.shade900,
            selectedIndex: selectedIndex,
            onDestinationSelected: (index) {
              setState(() => selectedIndex = index);
            },
            destinations: const [
              NavigationRailDestination(
                icon: Icon(Icons.inventory, color: Colors.white),
                label: Text('Products'),
              ),
              NavigationRailDestination(
                icon: Icon(Icons.people, color: Colors.white),
                label: Text('Suppliers'),
              ),
              NavigationRailDestination(
                icon: Icon(Icons.shopping_cart, color: Colors.white),
                label: Text('Orders'),
              ),
            ],
          ),
          Expanded(child: pages[selectedIndex]),
        ],
      ),
    );
  }
}
