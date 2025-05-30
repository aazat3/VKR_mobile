import 'package:flutter/material.dart';
import 'package:flutter_application_1/View/CalorieCircleChart.dart';
import 'package:flutter_application_1/View/MealCard.dart';
import 'package:flutter_application_1/View/WaterCircleChart.dart';
import 'package:provider/provider.dart';
import '/Providers/MealProvider.dart';
import 'package:flutter_application_1/View/BJUBarChart.dart';

class MainPage extends StatefulWidget {
  const MainPage({super.key});

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  DateTime selectedDate = DateTime.now();

  @override
  void initState() {
    super.initState();
    // Запускаем метод загрузки данных после завершения фазы построения виджетов
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final mealProvider = Provider.of<MealProvider>(context, listen: false);
      mealProvider.loadMeals(endDate: selectedDate);
    });
  }

  @override
  Widget build(BuildContext context) {
    final mealProvider = Provider.of<MealProvider>(context);

    return Scaffold(
      appBar: AppBar(title: Text('Здравствуйте, aazat!'), centerTitle: false),
      body:
          mealProvider.isLoading
              ? const Center(child: CircularProgressIndicator())
              : RefreshIndicator(
                onRefresh:
                    () async => mealProvider.loadMeals(endDate: selectedDate),
                child: SingleChildScrollView(
                  physics: const AlwaysScrollableScrollPhysics(),
                  padding: const EdgeInsets.all(4),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Виджет выбора даты
                      const DateSelector(),

                      const SizedBox(height: 24),

                      // Первая строка: калории и вода
                      Row(
                        children: [
                          Expanded(
                            child: Consumer<MealProvider>(
                              builder: (context, mealProvider, _) {
                                // Рассчитываем общее количество потребленных калорий
                                final consumedCalories = mealProvider.meals
                                    .fold<double>(
                                      0,
                                      (sum, meal) =>
                                          sum +
                                          (meal.product?.energyKcal ?? 0) *
                                              meal.weight /
                                              100,
                                    );

                                // Получаем цель из настроек (пример, нужно заменить на реальный источник)
                                const goalCalories = 2000;

                                return Card(
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(16),
                                  ),
                                  elevation: 0,
                                  color: Color(0xFF008C8C),
                                  child: Padding(
                                    padding: const EdgeInsets.all(12.0),
                                    child: Column(
                                      children: [
                                        const Text(
                                          "Калории",
                                          style: TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.bold,
                                            color: Colors.white,
                                          ),
                                        ),
                                        const SizedBox(height: 50),
                                        SizedBox(
                                          height: 50,
                                          child: CalorieCircleChart(
                                            consumed: consumedCalories,
                                            goal: goalCalories.toDouble(),
                                          ),
                                        ),
                                        const SizedBox(height: 50),
                                        Row(
                                          children: [
                                            Icon(
                                              Icons.local_fire_department,
                                              color: Colors.white,
                                            ),
                                            Text(
                                              '${consumedCalories.toStringAsFixed(0)}',
                                              style: TextStyle(
                                                fontSize: 16,
                                                fontWeight: FontWeight.bold,
                                                color: Colors.white,
                                              ),
                                            ),
                                            Text(
                                              '/${goalCalories.toStringAsFixed(0)}',
                                              style: TextStyle(
                                                fontSize: 16,
                                                color: Colors.white60,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                );
                              },
                            ),
                          ),

                          Expanded(
                            child: Consumer<MealProvider>(
                              builder: (context, mealProvider, _) {
                                final consumedWater = mealProvider.meals
                                    .fold<double>(
                                      0,
                                      (sum, meal) =>
                                          sum +
                                          (meal.product?.waterPercent ?? 0) *
                                              meal.weight /
                                              100,
                                    );

                                // Получаем цель из настроек (пример, нужно заменить на реальный источник)
                                const goalWater = 2400;

                                return Card(
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(16),
                                  ),
                                  elevation: 0,
                                  color: Color(0xFF008C8C),
                                  child: Padding(
                                    padding: const EdgeInsets.all(12.0),
                                    child: Column(
                                      children: [
                                        const Text(
                                          "Вода",
                                          style: TextStyle(
                                            color: Colors.white,
                                            fontSize: 16,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        const SizedBox(height: 50),
                                        SizedBox(
                                          height: 50,
                                          child: WaterCircleChart(
                                            consumed: consumedWater,
                                            goal: goalWater.toDouble(),
                                          ),
                                        ),
                                        const SizedBox(height: 50),
                                        Row(
                                          children: [
                                            Icon(
                                              Icons.water_drop,
                                              color: Colors.white,
                                            ),
                                            Text(
                                              '${consumedWater.toStringAsFixed(0)}',
                                              style: TextStyle(
                                                fontSize: 16,
                                                fontWeight: FontWeight.bold,
                                                color: Colors.white,
                                              ),
                                            ),
                                            Text(
                                              '/${goalWater.toStringAsFixed(0)} ',
                                              style: TextStyle(
                                                fontSize: 16,
                                                color: Colors.white60,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                );
                              },
                            ),
                          ),
                        ],
                      ),

                      Consumer<MealProvider>(
                        builder: (context, mealProvider, _) {
                          final consumedProtein = mealProvider.meals.fold<double>(
                            0,
                            (sum, meal) =>
                                sum +
                                (meal.product?.proteinPercent ?? 0) *
                                    meal.weight /
                                    100,
                          );
                          const goalProtein = 120;

                          final consumedFat = mealProvider.meals.fold<double>(
                            0,
                            (sum, meal) =>
                                sum +
                                (meal.product?.fatPercent ?? 0) *
                                    meal.weight /
                                    100,
                          );
                          const goalFat = 80;
                          
                          final consumedCarb = mealProvider.meals.fold<double>(
                            0,
                            (sum, meal) =>
                                sum +
                                (meal.product?.carbohydratesPercent ?? 0) *
                                    meal.weight /
                                    100,
                          );
                          const goalCarb = 200;

                          return Card(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(16),
                            ),
                            elevation: 0,
                            color: Color.fromARGB(255, 0, 140, 140),
                            child: Padding(
                              padding: const EdgeInsets.all(12.0),
                              child: Column(
                                children: [
                                  const Text(
                                    "БЖУ",
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  const SizedBox(height: 50),
                                  SizedBox(
                                    height: 50,
                                    child: BJUBarChart(
                                      consumedProtein: consumedProtein,
                                      consumedFat: consumedFat,
                                      consumedCarbs: consumedCarb,
                                      goalProtein: goalCarb.toDouble(),
                                      goalFat: goalFat.toDouble(),
                                      goalCarb: goalCarb.toDouble(),
                                    ),
                                  ),
                                  const SizedBox(height: 50),

                                  // Равномерное распределение
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      // Элемент 1
                                      Expanded(
                                        child: Column(
                                          children: [
                                            Row(
                                              children: [
                                                Icon(
                                                  Icons.circle,
                                                  color: Colors.blue,
                                                  size: 20,
                                                ),
                                                const Text(
                                                  "Белки",
                                                  style: TextStyle(
                                                    color: Colors.white,
                                                    fontSize: 16,
                                                    fontWeight: FontWeight.bold,
                                                  ),
                                                ),
                                              ],
                                            ),

                                            const SizedBox(width: 4),
                                            RichText(
                                              text: TextSpan(
                                                children: [
                                                  TextSpan(
                                                    text: '${consumedProtein}',
                                                    style: TextStyle(
                                                      fontSize: 16,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      color: Colors.white,
                                                    ),
                                                  ),
                                                  TextSpan(
                                                    text: '/${goalProtein}',
                                                    style: TextStyle(
                                                      fontSize: 16,
                                                      color: Colors.white60,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),

                                      const SizedBox(), // Горизонтальный отступ
                                      // Элемент 2
                                      Expanded(
                                        child: Column(
                                          children: [
                                            Row(
                                              children: [
                                                Icon(
                                                  Icons.circle,
                                                  color: Colors.green,
                                                  size: 20,
                                                ),
                                                const Text(
                                                  "Жиры",
                                                  style: TextStyle(
                                                    color: Colors.white,
                                                    fontSize: 16,
                                                    fontWeight: FontWeight.bold,
                                                  ),
                                                ),
                                              ],
                                            ),

                                            const SizedBox(width: 4),
                                            RichText(
                                              text: TextSpan(
                                                children: [
                                                  TextSpan(
                                                    text: '${consumedFat}',
                                                    style: TextStyle(
                                                      fontSize: 16,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      color: Colors.white,
                                                    ),
                                                  ),
                                                  TextSpan(
                                                    text: '/${goalFat}',
                                                    style: TextStyle(
                                                      fontSize: 16,
                                                      color: Colors.white60,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),

                                      // Элемент 3
                                      Expanded(
                                        child: Column(
                                          children: [
                                            Row(
                                              children: [
                                                Icon(
                                                  Icons.circle,
                                                  color: Colors.red,
                                                  size: 20,
                                                ),
                                                const Text(
                                                  "Углеводы",
                                                  style: TextStyle(
                                                    color: Colors.white,
                                                    fontSize: 16,
                                                    fontWeight: FontWeight.bold,
                                                  ),
                                                ),
                                              ],
                                            ),

                                            const SizedBox(width: 4),
                                            RichText(
                                              text: TextSpan(
                                                children: [
                                                  TextSpan(
                                                    text: '${consumedCarb}',
                                                    style: TextStyle(
                                                      fontSize: 16,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      color: Colors.white,
                                                    ),
                                                  ),
                                                  TextSpan(
                                                    text: '/${goalCarb}',
                                                    style: TextStyle(
                                                      fontSize: 16,
                                                      color: Colors.white60,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      ),
                      const SizedBox(height: 24),

                      // Список съеденных продуктов
                      const Text(
                        "Продукты",
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 8),
                      ...mealProvider.meals
                          .map((meal) => MealCard(meal: meal))
                          .toList(),
                    ],
                  ),
                ),
              ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => mealProvider.loadMeals(endDate: selectedDate),
        backgroundColor: Colors.teal,
        child: const Icon(Icons.refresh, color: Colors.white),
      ),
    );
  }
}

// DateSelector виджет
class DateSelector extends StatelessWidget {
  const DateSelector({super.key});

  @override
  Widget build(BuildContext context) {
    final mealProvider = Provider.of<MealProvider>(context);
    // final selectedDate = mealProvider.selectedDate;
    final selectedDate = DateTime.now();

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          'Дата: ${selectedDate.day.toString().padLeft(2, '0')}.${selectedDate.month.toString().padLeft(2, '0')}.${selectedDate.year}',
          style: const TextStyle(fontSize: 16),
        ),
        ElevatedButton.icon(
          onPressed: () async {
            final picked = await showDateRangePicker(
              context: context,
              firstDate: DateTime(2023),
              lastDate: DateTime.now(),
              initialDateRange: DateTimeRange(
                start: selectedDate.subtract(const Duration(days: 3)),
                end: selectedDate,
              ),
            );
            if (picked != null) {
              // mealProvider.setDateRange(picked);
              mealProvider.loadMeals(endDate: picked.end);
            }
          },
          icon: const Icon(Icons.date_range),
          label: const Text('Выбрать диапазон'),
        ),
      ],
    );
  }
}
