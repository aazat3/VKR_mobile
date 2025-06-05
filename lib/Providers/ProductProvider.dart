import 'package:flutter/material.dart';
import '/Models/ProductModel/ProductModel.dart';
import 'DioClient.dart';
import 'package:flutter_application_1/ApiList.dart';

class ProductProvider with ChangeNotifier {
  List<ProductModel> _allProducts = [];
  List<ProductModel> _filteredProducts = [];
  bool _isLoading = false;
  String? _error;
  String _searchQuery = '';
  String _sortField = 'id';
  bool _ascending = true;

  List<ProductModel> get products => _filteredProducts;

  bool get isLoading => _isLoading;
  String? get error => _error;

  Future<void> loadProducts() async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      _allProducts = await _fetchProducts();
      _applyFilters();
    } catch (e) {
      _error = 'Ошибка загрузки: ${e.toString()}';
      _allProducts = [];
      _filteredProducts = [];
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<List<ProductModel>> _fetchProducts() async {
    final response = await DioClient.dio.get(APIS.product);
    if (response.statusCode == 200) {
      return (response.data as List)
          .map((item) => ProductModel.fromJson(item))
          .toList();
    }
    throw Exception('Ошибка сервера: ${response.statusCode}');
  }

  Future<List<ProductModel>> searchLoadProducts({required String? name}) async {
    final Map<String, dynamic> queryParameters = {};
    if (name != null) queryParameters['name'] = name;

    final response = await DioClient.dio.get(
      APIS.searchProduct,
      queryParameters: queryParameters,
    );
    if (response.statusCode == 200) {
      return (response.data as List)
          .map((item) => ProductModel.fromJson(item))
          .toList();
    }
    throw Exception('Ошибка сервера: ${response.statusCode}');
  }

  void sortBy(String field) {
    if (_sortField == field) {
      _ascending = !_ascending;
    } else {
      _sortField = field;
      _ascending = true;
    }
    _applyFilters();
  }

  void setSearchQuery(String query) {
    _searchQuery = query.toLowerCase();
    _applyFilters();
  }

  void _applyFilters() {
    // Фильтрация
    var result =
        _allProducts
            .where(
              (product) => product.name.toLowerCase().contains(_searchQuery),
            )
            .toList();

    // Сортировка
    result.sort((a, b) {
      switch (_sortField) {
        case 'calories':
          return _ascending
              ? a.energyKcal!.compareTo(b.energyKcal as num)
              : b.energyKcal!.compareTo(a.energyKcal as num);
        case 'name':
          return _ascending
              ? a.name.compareTo(b.name)
              : b.name.compareTo(a.name);

        default: // id
          return _ascending ? a.id.compareTo(b.id) : b.id.compareTo(a.id);
      }
    });

    _filteredProducts = result;
    notifyListeners();
  }

  void clearFilters() {
    _searchQuery = '';
    _sortField = 'id';
    _ascending = true;
    _applyFilters();
  }
}
