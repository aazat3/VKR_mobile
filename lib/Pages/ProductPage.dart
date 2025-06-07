import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_application_1/Pages/AddProductPage.dart';
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
  List<ProductModel> _searchResults = [];
  bool _isSearching = false;
  String? _searchError;
  Timer? _searchDebounce;
  String _currentSort = 'id';

  @override
  void initState() {
    super.initState();
    _searchController.addListener(_onSearchChanged);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<ProductProvider>(context, listen: false).loadProducts();
      Provider.of<ProductProvider>(context, listen: false).loadCategories();
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    _searchDebounce?.cancel();
    super.dispose();
  }

  Future<void> _loadProducts() async {
    await Provider.of<ProductProvider>(context, listen: false).loadProducts();
  }

  void _onSearchChanged() {
    if (_searchDebounce?.isActive ?? false) _searchDebounce?.cancel();

    _searchDebounce = Timer(const Duration(milliseconds: 500), () {
      if (_searchController.text.isEmpty) {
        setState(() {
          _searchResults = [];
          _searchError = null;
        });
        return;
      }
      _performSearch(_searchController.text);
    });
  }

  Future<void> _performSearch(String query) async {
    setState(() {
      _isSearching = true;
      _searchError = null;
    });

    try {
      final results = await context.read<ProductProvider>().searchLoadProducts(
        name: query,
      );
      setState(() {
        _searchResults = results;
        _isSearching = false;
      });
    } catch (e) {
      setState(() {
        _searchError = e.toString();
        _isSearching = false;
      });
    }
  }

  void _handleSort(String value) {
    setState(() {
      _currentSort = value;

      // Сортируем результаты поиска, если поиск активен
      if (_searchController.text.isNotEmpty) {
        _searchResults = _applySort(_searchResults);
      } else {
        // Если поиск не активен — обновляем сортировку в провайдере
        Provider.of<ProductProvider>(context, listen: false).sortBy(value);
      }
    });
  }

  List<ProductModel> _applySort(List<ProductModel> list) {
    final sorted = [...list];
    sorted.sort((a, b) {
      switch (_currentSort) {
        case 'name':
          return a.name.toLowerCase().compareTo(b.name.toLowerCase());
        case 'calories':
          return a.energyKcal!.compareTo(b.energyKcal!.toDouble());
        case 'id':
        default:
          return a.id.compareTo(b.id);
      }
    });
    return sorted;
  }

  void _navigateToAddProduct() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => AddProductPage()),
    );
  }

  Widget _buildSearchField() {
    return TextField(
      controller: _searchController,
      decoration: InputDecoration(
        labelText: 'Поиск продукта',
        prefixIcon: const Icon(Icons.search),
        suffixIcon:
            _isSearching
                ? const Padding(
                  padding: EdgeInsets.all(8.0),
                  child: SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  ),
                )
                : (_searchController.text.isNotEmpty
                    ? IconButton(
                      icon: const Icon(Icons.clear),
                      onPressed: () {
                        _searchController.clear();
                        FocusScope.of(context).unfocus();
                      },
                    )
                    : null),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
      ),
    );
  }

  Widget _buildSortMenu() {
    return PopupMenuButton<String>(
      onSelected: _handleSort,
      itemBuilder:
          (_) => const [
            PopupMenuItem(value: 'id', child: Text('По ID')),
            PopupMenuItem(value: 'name', child: Text('По названию')),
            PopupMenuItem(value: 'calories', child: Text('По калориям')),
          ],
    );
  }

  Widget _buildEmptyState() {
    return Column(
      children: [
        Padding(padding: const EdgeInsets.all(12), child: _buildSearchField()),
        if (_searchError != null)
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              'Ошибка: $_searchError',
              style: const TextStyle(color: Colors.red),
            ),
          ),
        Expanded(
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.fastfood_outlined,
                  size: 80,
                  color: Colors.grey.shade400,
                ),
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
          ),
        ),
      ],
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

  Widget _buildBody() {
    return Consumer<ProductProvider>(
      builder: (context, provider, _) {
        if (provider.isLoading) {
          return const Center(child: CircularProgressIndicator());
        }

        if (provider.error != null) {
          return Center(child: Text('Ошибка: ${provider.error}'));
        }

        final productsToShow =
            _searchResults.isNotEmpty || _searchController.text.isNotEmpty
                ? _searchResults
                : provider.products;

        if (productsToShow.isEmpty) {
          return _buildEmptyState();
        }

        return RefreshIndicator(
          onRefresh: _loadProducts,
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(12),
                child: _buildSearchField(),
              ),
              if (_searchError != null)
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    'Ошибка: $_searchError',
                    style: const TextStyle(color: Colors.red),
                  ),
                ),
              Expanded(
                child: ListView.separated(
                  padding: const EdgeInsets.all(16),
                  itemCount: productsToShow.length,
                  separatorBuilder: (_, __) => const SizedBox(height: 8),
                  itemBuilder:
                      (_, index) => Productcard(product: productsToShow[index]),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Каталог продуктов'),
        actions: [_buildSortMenu()],
      ),
      body: _buildBody(),
      floatingActionButton: _buildAddButton(),
    );
  }
}
