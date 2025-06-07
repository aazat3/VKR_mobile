import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class GoalProvider with ChangeNotifier {
  static const String _goalKey = 'goals';
  static const Map<String, dynamic> _defaultGoals = {
    'calories': 2000,
    'water': 2000,
    'protein': 30,
    'fat': 30,
    'carbs': 40,
  };

late Map<String, dynamic> _goals = Map.from(_defaultGoals);
  Map<String, dynamic> get goals => _goals;
  GoalProvider() {
    _loadGoals();
  }

  int get calories => _goals['calories'];
  int get water => _goals['water'];
  int get proteinPercent => _goals['protein'];
  int get fatPercent => _goals['fat'];
  int get carbsPercent => _goals['carbs'];

  // Расчет граммов макронутриентов
  double get proteinGrams => (calories * proteinPercent / 100) / 4;
  double get fatGrams => (calories * fatPercent / 100) / 9;
  double get carbsGrams => (calories * carbsPercent / 100) / 4;

  Future<void> _loadGoals() async {
    final prefs = await SharedPreferences.getInstance();
    final saved = prefs.getString(_goalKey);

    _goals =
        saved != null
            ? Map<String, dynamic>.from(json.decode(saved))
            : _defaultGoals;

    _validateMacros();
    notifyListeners();
  }

  Future<void> saveGoals(Map<String, dynamic> newGoals) async {
    _goals = newGoals;
    _validateMacros();

    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_goalKey, json.encode(_goals));

    notifyListeners();
  }

  void _validateMacros() {
    final total = _goals['protein'] + _goals['fat'] + _goals['carbs'];
    if (total != 100) {
      _goals['protein'] = _defaultGoals['protein'];
      _goals['fat'] = _defaultGoals['fat'];
      _goals['carbs'] = _defaultGoals['carbs'];
    }
  }
}
