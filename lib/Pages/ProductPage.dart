import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '/Providers/ProductProvider.dart';

class ProductsPage extends StatelessWidget {
  const ProductsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final productProvider = Provider.of<ProductProvider>(context);

    return Scaffold(
      appBar: AppBar(title: const Text('Продукты')),
      body: productProvider.isLoading
          ? const Center(child: CircularProgressIndicator())
          : ListView.builder(
              itemCount: productProvider.products.length,
              itemBuilder: (context, index) {
                final product = productProvider.products[index];
                return ListTile(
                  title: Text(product.name),
                  subtitle: Text('Энергия: ${product.energyKcal} ккал'),
                  trailing: Text('ID: ${product.id}'),
                );
              },
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => productProvider.loadProducts(),
        child: const Icon(Icons.refresh),
      ),
    );
  }
}