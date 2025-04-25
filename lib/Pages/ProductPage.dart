import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '/Providers/ProductProvider.dart';

class ProductPage extends StatelessWidget {
  const ProductPage({super.key});

  @override
  Widget build(BuildContext context) {
    final productProvider = Provider.of<ProductProvider>(context);

    if (productProvider.isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    return Scaffold(
      appBar: AppBar(title: const Text('Продукты')),
      body: productProvider.isLoading
          ? const Center(child: CircularProgressIndicator())
          : ListView.builder(
              itemCount: productProvider.products.length,
              itemBuilder: (_, i) => Card(
              child: ListTile(
                title: Text(productProvider.products[i].name),
                subtitle: Text('${productProvider.products[i].energyKcal} ккал'),
                trailing: Text('ID: ${productProvider.products[i].id}'),
              )
            )
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => productProvider.loadProducts(),
        child: const Icon(Icons.add),
      ),
    );
  
  
  }
}