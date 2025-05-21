import 'package:flutter/material.dart';
import 'package:flutter_application_1/Pages/ProductDetailScreen.dart';
import 'package:flutter_application_1/View/ProductCard.dart';
import 'package:provider/provider.dart';
import '/Providers/ProductProvider.dart';
import '/Models/ProductModel/ProductModel.dart';

class ProductPage extends StatefulWidget {
  const ProductPage({super.key});

  @override
  State<ProductPage> createState() => _ProductPageState();
}

class _ProductPageState extends State<ProductPage> {
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadProducts();
    });
  }

  Future<void> _loadProducts() async {
    await Provider.of<ProductProvider>(context, listen: false).loadProducts();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Каталог продуктов'),
        actions: [
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: () => _showSearch(context),
          ),
          _buildSortMenu(),
        ],
      ),
      body: _buildBody(),
      floatingActionButton: _buildAddButton(),
    );
  }

  Widget _buildBody() {
    return Consumer<ProductProvider>(
      builder: (context, provider, _) {
        if (provider.isLoading) {
          return const Center(child: CircularProgressIndicator());
        }

        if (provider.error != null) {
          return Center(child: Text('Ошибка: ${provider.error}'));
        }

        if (provider.products.isEmpty) {
          return _buildEmptyState();
        }

        return RefreshIndicator(
          onRefresh: _loadProducts,
          child: ListView.separated(
            padding: const EdgeInsets.all(16),
            itemCount: provider.products.length,
            separatorBuilder: (_, __) => const SizedBox(height: 0),
            itemBuilder: (_, index) => Productcard(product : provider.products[index]),
          ),
        );
      },
    );
  }

  Widget _buildSortMenu() {
    return PopupMenuButton<String>(
      onSelected: (value) => _handleSort(value),
      itemBuilder: (BuildContext context) => [
        const PopupMenuItem(value: 'id', child: Text('По ID')),
        const PopupMenuItem(value: 'name', child: Text('По названию')),
        const PopupMenuItem(value: 'calories', child: Text('По калориям')),
      ],
    );
  }

  Widget _buildProductCard(ProductModel product) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: () => _showProductDetails(product),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              _buildProductIcon(),
              const SizedBox(width: 16),
              _buildProductInfo(product),
              _buildProductActions(product),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildProductIcon() {
    return Container(
      width: 60,
      height: 60,
      decoration: BoxDecoration(
        color: Colors.grey.shade200,
        borderRadius: BorderRadius.circular(8),
      ),
      alignment: Alignment.center,
      child: Icon(Icons.fastfood, color: Colors.grey.shade600),
    );
  }

  Widget _buildProductInfo(ProductModel product) {
    return Expanded(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            product.name,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            '${product.energyKcal} ккал / 100г',
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey.shade600,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProductActions(ProductModel product) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Chip(
          label: Text('ID: ${product.id}'),
          backgroundColor: Colors.blue.shade50,
          labelStyle: const TextStyle(color: Colors.blue),
        ),
        IconButton(
          icon: Icon(Icons.info_outline, color: Colors.grey.shade600),
          onPressed: () => _showProductDetails(product),
        ),
      ],
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.fastfood_outlined, size: 80, color: Colors.grey.shade400),
          const SizedBox(height: 20),
          const Text(
            'Продуктов не найдено',
            style: TextStyle(fontSize: 18, color: Colors.grey),
          ),
          const SizedBox(height: 8),
          Text(
            'Нажмите "+" чтобы добавить новый продукт',
            style: TextStyle(color: Colors.grey.shade600),
          ),
        ],
      ),
    );
  }

  Widget _buildAddButton() {
    return FloatingActionButton(
      heroTag: 'add_product',
      onPressed: () => _navigateToAddProduct(),
      backgroundColor: Colors.teal,
      child: const Icon(Icons.add, color: Colors.white),
    );
  }

  void _showSearch(BuildContext context) {
    showSearch(
      context: context,
      delegate: ProductSearchDelegate(
        products: Provider.of<ProductProvider>(context, listen: false).products,
        delegateContext: context,
      ),
    );
  }

  void _handleSort(String value) {
    Provider.of<ProductProvider>(context, listen: false).sortBy(value);
  }

  void _navigateToAddProduct() {
    // Navigator.push(context, MaterialPageRoute(builder: (_) => AddProductPage()));
  }

  void _showProductDetails(ProductModel product) {
    Navigator.push(
    context,
    MaterialPageRoute(
      builder: (context) => ProductDetailScreen(product: product),
    ),
  );
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }
}

class ProductSearchDelegate extends SearchDelegate<String> {
  final List<ProductModel> products;
  final BuildContext delegateContext;

  ProductSearchDelegate({
    required this.products,
    required this.delegateContext,
  });

  @override
  List<Widget> buildActions(BuildContext context) => [
    IconButton(
      icon: const Icon(Icons.clear),
      onPressed: () => query = '',
    ),
  ];

  @override
  Widget buildLeading(BuildContext context) => IconButton(
    icon: const Icon(Icons.arrow_back),
    onPressed: () => close(context, ''),
  );

  @override
  Widget buildResults(BuildContext context) => _buildSearchList(context);

  @override
  Widget buildSuggestions(BuildContext context) => _buildSearchList(context);

  Widget _buildSearchList(BuildContext context) {
    final filtered = products.where((p) => 
      p.name.toLowerCase().contains(query.toLowerCase())
    ).toList();

    return ListView.builder(
      itemCount: filtered.length,
      itemBuilder: (_, i) => ListTile(
        title: Text(filtered[i].name),
        subtitle: Text('${filtered[i].energyKcal} ккал'),
        onTap: () => close(context, filtered[i].id.toString()),
      ),
    );
  }
}