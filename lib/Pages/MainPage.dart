import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '/Providers/MealProvider.dart';
import '/View/CarouselView.dart';

class MainPage extends StatefulWidget {
  const MainPage({super.key});

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  @override
  void initState() {
    super.initState();
    // Запускаем метод загрузки данных после завершения фазы построения виджетов
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final mealProvider = Provider.of<MealProvider>(context, listen: false);
      mealProvider.loadMeals();
    });
  }

  @override
  Widget build(BuildContext context) {
    final mealProvider = Provider.of<MealProvider>(context);

    return Scaffold(
      appBar: AppBar(title: const Text('Продукты')),
      body:
          mealProvider.isLoading
              ? const Center(child: CircularProgressIndicator())
              : CustomScrollView(
                slivers: [
                  SliverToBoxAdapter(
                    child: SizedBox(
                      height: MediaQuery.of(context).size.width * 0.8,
                      child: const StatisticCarousel(),
                    ),
                  ),
                  SliverPadding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 0,
                    ),
                    sliver: SliverList(
                      delegate: SliverChildBuilderDelegate(
                        (context, index) {
                          final meal = mealProvider.meals[index];
                          return Card(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(16),
                            ),
                            elevation: 4,
                            margin: const EdgeInsets.symmetric(
                              horizontal: 16,
                              vertical: 2,
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(16.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  // Название продукта
                                  Row(
                                    children: [
                                      Icon(
                                        Icons.fastfood,
                                        color: Colors.orange,
                                      ),
                                      const SizedBox(width: 8),
                                      Expanded(
                                        child: Text(
                                          meal.product?.name ??
                                              'Продукт неизвестен',
                                          style: TextStyle(
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
                                      Icon(Icons.scale, color: Colors.blue),
                                      const SizedBox(width: 8),
                                      Text('${meal.weight} г'),
                                      const Spacer(),
                                      Icon(
                                        Icons.local_fire_department,
                                        color: Colors.red,
                                      ),
                                      const SizedBox(width: 8),
                                      Text(
                                        '${((meal.product?.energyKcal ?? 0) * meal.weight / 100).toStringAsFixed(1)} ккал',
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 12),

                                  // Дата и время
                                  Row(
                                    children: [
                                      Icon(
                                        Icons.calendar_today,
                                        size: 20,
                                        color: Colors.green,
                                      ),
                                      const SizedBox(width: 8),
                                      Text(
                                        '${meal.time.day.toString().padLeft(2, '0')}.${meal.time.month.toString().padLeft(2, '0')}.${meal.time.year}',
                                      ),
                                      const Spacer(),
                                      Icon(
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
                        },
                        childCount:
                            mealProvider.meals.length, // количество элементов
                      ),
                    ),
                  ),
                ],
              ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => mealProvider.loadMeals(),
        child: const Icon(Icons.refresh),
      ),
    );
  }
}
