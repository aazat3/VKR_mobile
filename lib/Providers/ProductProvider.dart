import 'package:flutter/material.dart';
import '/Models/ProductModel/ProductModel.dart';
import 'package:flutter_application_1/Services/ProductService.dart';


class ProductProvider with ChangeNotifier {
  final ProductService _service = ProductService();

  List<ProductModel> _products = [];
  List<ProductModel> get products => _products;

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  Future<void> loadProducts() async {
    _isLoading = true;
    notifyListeners();

    try {
      _products = await _service.fetchProducts();
    } catch (e) {
      _products = [];
    }

    _isLoading = false;
    notifyListeners();
  }
}