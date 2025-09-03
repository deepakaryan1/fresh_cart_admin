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

  Future<void> addOrder(int productId, int quantity, String status) async {
    await SupabaseConfig.client.from('orders').insert({
      'product_id': productId,
      'quantity': quantity,
      'status': status,
    });
    fetchOrders();
  }

  Future<void> updateOrder(
    int id,
    int productId,
    int quantity,
    String status,
  ) async {
    await SupabaseConfig.client
        .from('orders')
        .update({
          'product_id': productId,
          'quantity': quantity,
          'status': status,
        })
        .eq('id', id);
    fetchOrders();
  }

  Future<void> deleteOrder(int id) async {
    await SupabaseConfig.client.from('orders').delete().eq('id', id);
    fetchOrders();
  }

  void showOrderDialog({Map<String, dynamic>? order}) {
    final productIdCtrl = TextEditingController(
      text: order?['product_id']?.toString() ?? '',
    );
    final quantityCtrl = TextEditingController(
      text: order?['quantity']?.toString() ?? '',
    );
    final statusCtrl = TextEditingController(text: order?['status'] ?? '');

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(order == null ? 'Add Order' : 'Edit Order'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: productIdCtrl,
              decoration: const InputDecoration(labelText: 'Product ID'),
              keyboardType: TextInputType.number,
            ),
            TextField(
              controller: quantityCtrl,
              decoration: const InputDecoration(labelText: 'Quantity'),
              keyboardType: TextInputType.number,
            ),
            TextField(
              controller: statusCtrl,
              decoration: const InputDecoration(labelText: 'Status'),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              if (order == null) {
                addOrder(
                  int.tryParse(productIdCtrl.text) ?? 0,
                  int.tryParse(quantityCtrl.text) ?? 0,
                  statusCtrl.text,
                );
              } else {
                updateOrder(
                  order['id'],
                  int.tryParse(productIdCtrl.text) ?? 0,
                  int.tryParse(quantityCtrl.text) ?? 0,
                  statusCtrl.text,
                );
              }
              Navigator.pop(context);
            },
            child: Text(order == null ? 'Add' : 'Update'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Orders'),
        actions: [
          IconButton(
            onPressed: () => showOrderDialog(),
            icon: const Icon(Icons.add),
          ),
        ],
      ),
      body: ListView.builder(
        itemCount: orders.length,
        itemBuilder: (context, index) {
          final o = orders[index];
          return ListTile(
            title: Text('Order #${o['id']}'),
            subtitle: Text(
              'Product ID: ${o['product_id']} | Qty: ${o['quantity']} | Status: ${o['status']}',
            ),
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                IconButton(
                  icon: const Icon(Icons.edit, color: Colors.blue),
                  onPressed: () => showOrderDialog(order: o),
                ),
                IconButton(
                  icon: const Icon(Icons.delete, color: Colors.red),
                  onPressed: () => deleteOrder(o['id']),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
