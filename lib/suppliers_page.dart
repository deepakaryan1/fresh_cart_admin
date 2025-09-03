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

  Future<void> addSupplier(
    String name,
    String contactInfo,
    double rating,
  ) async {
    await SupabaseConfig.client.from('suppliers').insert({
      'name': name,
      'contact_info': contactInfo,
      'rating': rating,
    });
    fetchSuppliers();
  }

  Future<void> updateSupplier(
    int id,
    String name,
    String contactInfo,
    double rating,
  ) async {
    await SupabaseConfig.client
        .from('suppliers')
        .update({'name': name, 'contact_info': contactInfo, 'rating': rating})
        .eq('id', id);
    fetchSuppliers();
  }

  Future<void> deleteSupplier(int id) async {
    await SupabaseConfig.client.from('suppliers').delete().eq('id', id);
    fetchSuppliers();
  }

  void showSupplierDialog({Map<String, dynamic>? supplier}) {
    final nameCtrl = TextEditingController(text: supplier?['name'] ?? '');
    final contactCtrl = TextEditingController(
      text: supplier?['contact_info'] ?? '',
    );
    final ratingCtrl = TextEditingController(
      text: supplier?['rating']?.toString() ?? '',
    );

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(supplier == null ? 'Add Supplier' : 'Edit Supplier'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: nameCtrl,
              decoration: const InputDecoration(labelText: 'Name'),
            ),
            TextField(
              controller: contactCtrl,
              decoration: const InputDecoration(labelText: 'Contact Info'),
            ),
            TextField(
              controller: ratingCtrl,
              decoration: const InputDecoration(labelText: 'Rating'),
              keyboardType: TextInputType.number,
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
              if (supplier == null) {
                addSupplier(
                  nameCtrl.text,
                  contactCtrl.text,
                  double.tryParse(ratingCtrl.text) ?? 0,
                );
              } else {
                updateSupplier(
                  supplier['id'],
                  nameCtrl.text,
                  contactCtrl.text,
                  double.tryParse(ratingCtrl.text) ?? 0,
                );
              }
              Navigator.pop(context);
            },
            child: Text(supplier == null ? 'Add' : 'Update'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Suppliers'),
        actions: [
          IconButton(
            onPressed: () => showSupplierDialog(),
            icon: const Icon(Icons.add),
          ),
        ],
      ),
      body: ListView.builder(
        itemCount: suppliers.length,
        itemBuilder: (context, index) {
          final supplier = suppliers[index];
          return ListTile(
            title: Text(supplier['name']),
            subtitle: Text(
              'Contact: ${supplier['contact_info']} | Rating: ${supplier['rating']}',
            ),
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                IconButton(
                  icon: const Icon(Icons.edit, color: Colors.blue),
                  onPressed: () => showSupplierDialog(supplier: supplier),
                ),
                IconButton(
                  icon: const Icon(Icons.delete, color: Colors.red),
                  onPressed: () => deleteSupplier(supplier['id']),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
