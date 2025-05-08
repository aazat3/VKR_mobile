import 'package:flutter/material.dart';
import '/Models/CategoryModel/CategoryModel.dart';
import 'DioClient.dart';
import 'package:flutter_application_1/ApiList.dart';

class CategoryProvider with ChangeNotifier {
  List<CategoryModel> _categories = [];
  List<CategoryModel> get categories => _categories;

  bool _isLoading = false;
  bool get isLoading => _isLoading;


  Future<void> loadCategory() async {
    _isLoading = true;
    notifyListeners();
    try {
      _categories = await fetchCategory();
    } catch (e) {
      _categories = [];
    }

    _isLoading = false;
    notifyListeners();
  }

  Future<List<CategoryModel>> fetchCategory() async {

    final response = await DioClient.dio.get(
      APIS.category,
    );
    if (response.statusCode == 200) {
      final data = response.data as List;
      return data.map((item) => CategoryModel.fromJson(item)).toList();
    } else {
      throw Exception('Failed to load categories');
    }
  }

}
