import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import '/Models/MealModel/MealModel.dart';
import 'DioClient.dart';
import 'package:flutter_application_1/ApiList.dart';

class MealProvider with ChangeNotifier {
  List<MealModel> _meals = [];
  List<MealModel> get meals => _meals;

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  String _searchQuery = '';
  String get searchQuery => _searchQuery;

  String? _selectedCategory;
  String? get selectedCategory => _selectedCategory;

  DateTime? _startDate;
  DateTime? _endDate;
  DateTime? get startDate => _startDate;
  DateTime? get endDate => _endDate;

  MealProvider() {
    _endDate = DateTime.now();
    _startDate = _endDate!.subtract(const Duration(days: 7));
  }

  void setSearchQuery(String query) {
    _searchQuery = query.toLowerCase();
    notifyListeners();
  }

  void setCategoryFilter(String? category) {
    _selectedCategory = category;
    notifyListeners();
  }

  List<MealModel> get filteredMeals {
    return _meals.where((meal) {
      final matchesSearch =
          meal.product?.name.toLowerCase().contains(
            _searchQuery.toLowerCase(),
          ) ??
          false;

      final matchesCategory =
          _selectedCategory == null ||
          _selectedCategory == 'Все' ||
          meal.product?.category?.name == _selectedCategory;

      return matchesSearch && matchesCategory;
    }).toList();
  }

  Future<void> loadMeals({
    int? size,
    String? nextCursor,
    DateTime? startDate,
    DateTime? endDate,
  }) async {
    _isLoading = true;
    notifyListeners();
    _startDate = startDate;
    _endDate = endDate;
    try {
      _meals = await fetchMeals(
        size: size,
        nextCursor: nextCursor,
        startDate: startDate,
        endDate: endDate,
      );
    } catch (e) {
      _meals = [];
    }

    _isLoading = false;
    notifyListeners();
  }

  Future<List<MealModel>> fetchMeals({
    required int? size,
    required String? nextCursor,
    required DateTime? startDate,
    required DateTime? endDate,
  }) async {
    final Map<String, dynamic> queryParameters = {};

    // Добавляем параметры только если они не равны null
    if (size != null) queryParameters['size'] = size;
    if (nextCursor != null) queryParameters['after_id'] = nextCursor;
    if (startDate != null) {
      queryParameters['start_date'] = startDate.toIso8601String();
    }
    if (endDate != null) {
      queryParameters['end_date'] = endDate.toIso8601String();
    }
    final response = await DioClient.dio.get(
      APIS.meal,
      queryParameters: queryParameters,
    );
    if (response.statusCode == 200) {
      final data = response.data as List;
      return data.map((item) => MealModel.fromJson(item)).toList();
      // return PaginatedResponse<MealModel>.fromJson(
      //   response.data,
      //   (item) => MealModel.fromJson(item),
      // );
    } else {
      throw Exception('Failed to load meals');
    }
  }

  Future<void> addMeal({
    required int productID,
    required int weight,
    required DateTime time,
  }) async {
    try {
      final response = await DioClient.dio.post(
        APIS.meal,
        data: {
          'productID': productID, // Совпадает с именем из curl-примера
          'weight': weight,
          'time': time.toUtc().toIso8601String(),
        },
        options: Options(
          headers: {
            'accept': 'application/json', // Явно указываем заголовок accept
            'Content-Type': 'application/json',
          },
          validateStatus: (status) => status! < 500,
        ),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        await loadMeals();
        return;
      }

      final errorMessage =
          response.data?['detail'] ?? 'Unknown error (${response.statusCode})';
      throw Exception(errorMessage);
    } on DioException catch (e) {
      final errorData = e.response?.data?['detail'] ?? e.message;
      throw Exception('Dio Error: $errorData');
    } catch (e) {
      throw Exception('Unexpected error: $e');
    }
  }

  Future<void> deleteMeal(int mealId) async {
    try {
      final response = await DioClient.dio.delete(
        APIS.meal,
        queryParameters: {'id': mealId},
        options: Options(
          headers: {
            'accept': 'application/json',
            'Authorization': 'Bearer your_token', // если требуется
          },
        ),
      );
      if (response.statusCode == 200) {
        _meals.removeWhere((m) => m.id == mealId);
        notifyListeners();
      }
    } catch (e) {
      throw Exception('Ошибка удаления: $e');
    }
  }

  void restoreMeal(MealModel meal) {
    _meals.add(meal);
    notifyListeners();
  }

  // Future<List<MealModel>> fetchMeals({required startDate, required endDate}) async {
  //   final response = await DioClient.dio.get(APIS.meal);
  //   if (response.statusCode == 200) {
  //     final data = response.data as List;
  //     return data.map((item) => MealModel.fromJson(item)).toList();
  //   } else {
  //     throw Exception('Failed to load meals');
  //   }
  // }
}
