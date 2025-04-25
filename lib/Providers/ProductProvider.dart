import 'package:flutter/material.dart';
import '/Models/ProductModel/ProductModel.dart';
import 'DioClient.dart';
import 'package:flutter_application_1/ApiList.dart';


class ProductProvider with ChangeNotifier {

  List<ProductModel> _products = [];
  List<ProductModel> get products => _products;

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  Future<void> loadProducts() async { ///проблема 
    _isLoading = true;
    notifyListeners();

    try {
      _products = await fetchProducts();
    } catch (e) {
      _products = [];
    }

    _isLoading = false;
    notifyListeners();
  }

  Future<List<ProductModel>> fetchProducts() async {
    final response = await DioClient.dio.get(APIS.product);
    if (response.statusCode == 200) {
      final data = response.data as List;
      return data.map((item) => ProductModel.fromJson(item)).toList();
    } else {
      throw Exception('Failed to load products');
    }
  }
}