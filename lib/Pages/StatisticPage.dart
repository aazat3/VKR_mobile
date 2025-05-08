import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '/Providers/MealProvider.dart';
import '/Models/MealModel/MealModel.dart';
import 'package:flutter_application_1/Providers/CategoryProvider.dart';
import 'package:flutter_application_1/View/MealGroupedListView.dart';

class StatisticPage extends StatefulWidget {
  const StatisticPage({super.key});

  @override
  State<StatisticPage> createState() => _StatisticPageState();
}

class _StatisticPageState extends State<StatisticPage> {
  @override
  void initState() {
    super.initState();
    // Запускаем метод загрузки данных после завершения фазы построения виджетов
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final mealProvider = Provider.of<MealProvider>(context, listen: false);
      mealProvider.loadMeals();
      final categoryProvider = Provider.of<CategoryProvider>(
        context,
        listen: false,
      );
      categoryProvider.loadCategory();
    });
  }

  @override
  Widget build(BuildContext context) {
    final mealProvider = Provider.of<MealProvider>(context);
    final categoryProvider = Provider.of<CategoryProvider>(context);

    final groupedMeals = <String, List<MealModel>>{};
    for (var meal in mealProvider.filteredMeals) {
      final dateKey =
          "${meal.time.year}-${meal.time.month.toString().padLeft(2, '0')}-${meal.time.day.toString().padLeft(2, '0')}";
      groupedMeals.putIfAbsent(dateKey, () => []).add(meal);
    }

    return Scaffold(
      appBar: AppBar(title: const Text('Статистика')),
      body:
          mealProvider.isLoading
              ? const Center(child: CircularProgressIndicator())
              : RefreshIndicator(
                onRefresh: () async => mealProvider.loadMeals(),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 8,
                      ),
                      child: TextField(
                        onChanged: (value) {
                          mealProvider.setSearchQuery(value);
                        },
                        decoration: InputDecoration(
                          hintText: 'Поиск по названию продукта...',
                          prefixIcon: Icon(Icons.search),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(16),
                      child: Row(
                        children: [
                          DateSelector(),
                        ],
                      ),
                    ),
                    
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: DropdownButtonFormField<String>(
                        value: mealProvider.selectedCategory ?? 'Все',
                        decoration: InputDecoration(
                          labelText: 'Категория продукта',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        
                        items: [
                          const DropdownMenuItem(
                            value: 'Все',
                            child: Text('Все'),
                          ),
                          ...categoryProvider.categories
                              .where(
                                (c) => c.name != 'Все',
                              ) // на случай если 'Все' уже есть
                              .map(
                                (category) => DropdownMenuItem<String>(
                                  value: category.name,
                                  child: Text(category.name),
                                ),
                              ),
                        ],

                        onChanged: (value) {
                          mealProvider.setCategoryFilter(
                            value == 'Все' ? null : value,
                          );
                        },
                      ),
                    ),
                    
                    const SizedBox(height: 8),
                    Expanded(
                      child: GroupedMealList(groupedMeals: groupedMeals),
                    ),
                  ],
                ),
              ),

      floatingActionButton: FloatingActionButton(
        onPressed: () => mealProvider.loadMeals(),
        child: const Icon(Icons.refresh),
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
    final selectedStart = mealProvider.startDate ?? DateTime.now();
    final selectedEnd = mealProvider.endDate ?? DateTime.now();

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
              firstDate: DateTime(0),
              lastDate: DateTime.now(),
              initialDateRange: DateTimeRange(
                start: selectedStart,
                end: selectedEnd,
              ),
            );
            if (picked != null) {
              // mealProvider.setDateRange(picked);
              mealProvider.loadMeals(
                startDate: picked.start,
                endDate: picked.end,
              );
            }
          },
          icon: const Icon(Icons.date_range),
          label: const Text('Выбрать диапазон'),
        ),
      ],
    );
  }
}
