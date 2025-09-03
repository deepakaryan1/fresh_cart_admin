import 'package:flutter/material.dart';
import '../supabase_client.dart';

class ProductsPage extends StatefulWidget {
  const ProductsPage({super.key});

  @override
  State<ProductsPage> createState() => _ProductsPageState();
}

class _ProductsPageState extends State<ProductsPage> {
  List<Map<String, dynamic>> products = [];

  @override
  void initState() {
    super.initState();
    fetchProducts();
  }

  Future<void> fetchProducts() async {
    final response = await SupabaseConfig.client
        .from('products')
        .select()
        .order('created_at', ascending: false);
    setState(() {
      products = List<Map<String, dynamic>>.from(response);
    });
  }

  Future<void> addProduct(String name, double price, int stock) async {
    await SupabaseConfig.client.from('products').insert({
      'name': name,
      'price': price,
      'stock': stock,
    });
    fetchProducts();
  }

  Future<void> updateProduct(
    int id,
    String name,
    double price,
    int stock,
  ) async {
    await SupabaseConfig.client
        .from('products')
        .update({'name': name, 'price': price, 'stock': stock})
        .eq('id', id);
    fetchProducts();
  }

  Future<void> deleteProduct(int id) async {
    await SupabaseConfig.client.from('products').delete().eq('id', id);
    fetchProducts();
  }

  void showProductDialog({Map<String, dynamic>? product}) {
    final nameCtrl = TextEditingController(text: product?['name'] ?? '');
    final priceCtrl = TextEditingController(
      text: product?['price']?.toString() ?? '',
    );
    final stockCtrl = TextEditingController(
      text: product?['stock']?.toString() ?? '',
    );

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(product == null ? 'Add Product' : 'Edit Product'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: nameCtrl,
              decoration: const InputDecoration(labelText: 'Name'),
            ),
            TextField(
              controller: priceCtrl,
              decoration: const InputDecoration(labelText: 'Price'),
              keyboardType: TextInputType.number,
            ),
            TextField(
              controller: stockCtrl,
              decoration: const InputDecoration(labelText: 'Stock'),
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
              if (product == null) {
                addProduct(
                  nameCtrl.text,
                  double.tryParse(priceCtrl.text) ?? 0,
                  int.tryParse(stockCtrl.text) ?? 0,
                );
              } else {
                updateProduct(
                  product['id'],
                  nameCtrl.text,
                  double.tryParse(priceCtrl.text) ?? 0,
                  int.tryParse(stockCtrl.text) ?? 0,
                );
              }
              Navigator.pop(context);
            },
            child: Text(product == null ? 'Add' : 'Update'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Products'),
        actions: [
          IconButton(
            onPressed: () => showProductDialog(),
            icon: const Icon(Icons.add),
          ),
        ],
      ),
      body: ListView.builder(
        itemCount: products.length,
        itemBuilder: (context, index) {
          final product = products[index];
          return ListTile(
            title: Text(product['name']),
            subtitle: Text("₹${product['price']} - Stock: ${product['stock']}"),
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                IconButton(
                  icon: const Icon(Icons.edit, color: Colors.blue),
                  onPressed: () => showProductDialog(product: product),
                ),
                IconButton(
                  icon: const Icon(Icons.delete, color: Colors.red),
                  onPressed: () => deleteProduct(product['id']),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
