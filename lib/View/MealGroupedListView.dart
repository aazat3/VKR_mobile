// widgets/MealGropedListView.dart

import 'package:flutter/material.dart';
import 'package:flutter_application_1/Models/MealModel/MealModel.dart';
import 'package:flutter_application_1/View/MealCard.dart';

class GroupedMealList extends StatelessWidget {
  final Map<String, List<MealModel>> groupedMeals;

  const GroupedMealList({super.key, required this.groupedMeals});

  String _formatDate(String rawDate) {
    final parts = rawDate.split('-');
    final year = parts[0];
    final month = parts[1].padLeft(2, '0');
    final day = parts[2].padLeft(2, '0');
    return '$day.$month.$year';
  }

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: groupedMeals.length,
      itemBuilder: (context, index) {
        final date = groupedMeals.keys.elementAt(index);
        final meals = groupedMeals[date]!;

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.all(16),
              child: Text(
                _formatDate(date),
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
            ),
            ...meals.map((meal) => MealCard(meal: meal)),
          ],
        );
      },
    );
  }
}
