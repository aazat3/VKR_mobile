// widgets/MealCard.dart

import 'package:flutter/material.dart';
import '../Models/MealModel/MealModel.dart'; // путь зависит от твоей структуры проекта

class MealCard extends StatelessWidget {
  final MealModel meal;

  const MealCard({super.key, required this.meal});

  @override
  Widget build(BuildContext context) {
    return Card(
      color: const Color.fromARGB(255, 226, 245, 240),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      elevation: 4,
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Icon(Icons.fastfood, color: Colors.orange),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    meal.product?.name ?? 'Продукт неизвестен',
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                const Icon(Icons.scale, color: Colors.blue),
                const SizedBox(width: 8),
                Text('${meal.weight} г'),
                const Spacer(),
                const Icon(Icons.local_fire_department, color: Colors.red),
                const SizedBox(width: 8),
                Text(
                  '${((meal.product?.energyKcal ?? 0) * meal.weight / 100).toStringAsFixed(1)} ккал',
                ),
              ],
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                const Icon(Icons.access_time, size: 20, color: Colors.deepPurple),
                const SizedBox(width: 8),
                Text(
                  '${meal.time.hour.toString().padLeft(2, '0')}:${meal.time.minute.toString().padLeft(2, '0')}',
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
