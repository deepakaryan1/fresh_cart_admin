import 'package:flutter/material.dart';
import '../supabase_client.dart';

class SuppliersPage extends StatefulWidget {
  const SuppliersPage({super.key});

  @override
  State<SuppliersPage> createState() => _SuppliersPageState();
}

class _SuppliersPageState extends State<SuppliersPage> {
  List<Map<String, dynamic>> suppliers = [];

  @override
  void initState() {
    super.initState();
    fetchSuppliers();
  }

  Future<void> fetchSuppliers() async {
    final response = await SupabaseConfig.client.from('suppliers').select();
    setState(() => suppliers = List<Map<String, dynamic>>.from(response));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Suppliers')),
      body: ListView.builder(
        itemCount: suppliers.length,
        itemBuilder: (context, index) {
          final s = suppliers[index];
          return ListTile(
            title: Text(s['name']),
            subtitle: Text(s['contact_info'] ?? ''),
          );
        },
      ),
    );
  }
}
