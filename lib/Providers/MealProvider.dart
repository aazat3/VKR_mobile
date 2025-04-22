import 'package:flutter/material.dart';
import '/Models/MealModel/MealModel.dart';
import 'package:flutter_application_1/Services/MealService.dart';


class MealProvider with ChangeNotifier {
  final MealService _service = MealService();

  List<MealModel> _meals = [];
  List<MealModel> get meals => _meals;

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  Future<void> loadMeals() async {
    _isLoading = true;
    notifyListeners();

    try {
      _meals = await _service.fetchMeals();
    } catch (e) {
      _meals = [];
    }

    _isLoading = false;
    notifyListeners();
  }
}