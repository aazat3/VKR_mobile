import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:logger/logger.dart';

import '/Models/MealModel/MealModel.dart';
import 'DioClient.dart';
import 'package:flutter_application_1/ApiList.dart';
import 'package:flutter_application_1/Models/PaginatedModel/PaginatedResponse.dart';

final logger = Logger();

class MealProvider with ChangeNotifier {
  String selectedPeriod = 'day';
  List<String> periods = ['day', 'week', 'month'];
  List<FlSpot> getSpots() {
    switch (selectedPeriod) {
      case 'week':
        return [
          FlSpot(0, 180),
          FlSpot(1, 200),
          FlSpot(2, 150),
          FlSpot(3, 210),
          FlSpot(4, 170),
          FlSpot(5, 190),
          FlSpot(6, 220),
        ];
      case 'month':
        return List.generate(
          30,
          (i) => FlSpot(i.toDouble(), (150 + i % 5 * 10).toDouble()),
        );
      default:
        return [FlSpot(0, 180), FlSpot(1, 200), FlSpot(2, 150)];
    }
  }

  List<MealModel> _meals = [];
  String? _nextCursor;
  bool _isLoading = false;

  List<MealModel> get meals => _meals;
  bool get isLoading => _isLoading;

  Future<void> loadMeals({DateTime? startDate, DateTime? endDate}) async {
    if (_isLoading) return;

    _isLoading = true;
    notifyListeners();

    try {
      final response = await fetchMeals(
        size: 50,
        nextCursor: _nextCursor,
        startDate: startDate,
        endDate: endDate,
      );
      _meals.addAll(response.items);
      logger.i(_meals);
      if (response.items.isNotEmpty) {
        // _nextCursor = response.items.last.id;
        _nextCursor = response.nextCursor;
      }
    } catch (e) {
      _meals = [];
    }

    _isLoading = false;
    notifyListeners();
  }

  Future<PaginatedResponse<MealModel>> fetchMeals({
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
      queryParameters: queryParameters
    );
    if (response.statusCode == 200) {
      // final data = response.data as List;
      // return data.map((item) => MealModel.fromJson(item)).toList();
      return PaginatedResponse<MealModel>.fromJson(
        response.data,
        (item) => MealModel.fromJson(item),
      );
    } else {
      throw Exception('Failed to load meals');
    }
  }

  void reset() {
    _meals.clear();
    _nextCursor = '';
    _isLoading = false;
    notifyListeners();
  }
}
