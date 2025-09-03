import 'package:flutter/material.dart';
import '../supabase_client.dart';

class OrdersPage extends StatefulWidget {
  const OrdersPage({super.key});

  @override
  State<OrdersPage> createState() => _OrdersPageState();
}

class _OrdersPageState extends State<OrdersPage> {
  List<Map<String, dynamic>> orders = [];

  @override
  void initState() {
    super.initState();
    fetchOrders();
  }

  Future<void> fetchOrders() async {
    final response = await SupabaseConfig.client.from('orders').select();
    setState(() => orders = List<Map<String, dynamic>>.from(response));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Orders')),
      body: ListView.builder(
        itemCount: orders.length,
        itemBuilder: (context, index) {
          final o = orders[index];
          return ListTile(
            title: Text('Order #${o['id']}'),
            subtitle: Text('Status: ${o['status']}'),
          );
        },
      ),
    );
  }
}
