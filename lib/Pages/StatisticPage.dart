import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '/Providers/MealProvider.dart';
import 'package:intl/intl.dart';
import '/Models/MealModel/MealModel.dart';

class StatisticPage extends StatefulWidget {
  const StatisticPage({super.key});

  @override
  State<StatisticPage> createState() => _StatisticPageState();
}

class _StatisticPageState extends State<StatisticPage> {
  DateTime? _startDate;
  DateTime? _endDate;

  @override
  void initState() {
    super.initState();
    // Запускаем метод загрузки данных после завершения фазы построения виджетов
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final mealProvider = Provider.of<MealProvider>(context, listen: false);
      mealProvider.loadMeals();
    });
  }

  Future<void> _selectDate(BuildContext context, bool isStartDate) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: isStartDate ? (_startDate ?? DateTime.now()) : (_endDate ?? DateTime.now()),
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );
    if (picked != null && picked != (isStartDate ? _startDate : _endDate)) {
      setState(() {
        if (isStartDate) {
          _startDate = picked;
        } else {
          _endDate = picked;
        }
      });
      // Загружаем данные с фильтрацией по датам
      final mealProvider = Provider.of<MealProvider>(context, listen: false);
      mealProvider.loadMeals(startDate: _startDate, endDate: _endDate);
    }
  }

  @override
  Widget build(BuildContext context) {
    final mealProvider = Provider.of<MealProvider>(context);

    final groupedMeals = <String, List<MealModel>>{};
    for (var meal in mealProvider.meals) {
      final dateKey =
          "${meal.time.year}-${meal.time.month.toString().padLeft(2, '0')}-${meal.time.day.toString().padLeft(2, '0')}";
      groupedMeals.putIfAbsent(dateKey, () => []).add(meal);
    }

    return Scaffold(
      appBar: AppBar(title: const Text('Статистика')),
      body:
          mealProvider.isLoading
              ? const Center(child: CircularProgressIndicator())
              : ListView.builder(
                itemCount: groupedMeals.length,
                itemBuilder: (context, index) {
                  final date = groupedMeals.keys.elementAt(index);
                  final meals = groupedMeals[date]!;

                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Заголовок с датой
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

                      // Список карточек продуктов на эту дату
                      ...meals.map((meal) => _buildMealCard(meal)),
                    ],
                  );
                },
              ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => mealProvider.loadMeals(),
        child: const Icon(Icons.refresh),
      ),
    );
  }

  Widget _buildMealCard(MealModel meal) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      elevation: 4,
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Название продукта
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
            // Вес и калории
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
            // Время
            Row(
              children: [
                const Icon(
                  Icons.access_time,
                  size: 20,
                  color: Colors.deepPurple,
                ),
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

  String _formatDate(String dateKey) {
    final parts = dateKey.split('-');
    final date = DateTime(
      int.parse(parts[0]),
      int.parse(parts[1]),
      int.parse(parts[2]),
    );
    return "${date.day.toString().padLeft(2, '0')}.${date.month.toString().padLeft(2, '0')}.${date.year}";
  }
}
