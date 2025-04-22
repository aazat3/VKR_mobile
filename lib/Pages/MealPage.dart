import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '/Providers/MealProvider.dart';

class MealPage extends StatelessWidget {
  const MealPage({super.key});

  @override
  Widget build(BuildContext context) {
    final mealProvider = Provider.of<MealProvider>(context);

    return Scaffold(
      appBar: AppBar(title: const Text('Продукты')),
      body: mealProvider.isLoading
          ? const Center(child: CircularProgressIndicator())
          : ListView.builder(
              itemCount: mealProvider.meals.length,
              itemBuilder: (context, index) {
                final meal = mealProvider.meals[index];
                return ListTile(
                  title: Text('ID: ${meal.id}'),
                  subtitle: Text('ID продукта: ${meal.productId}'),
                  trailing: Text('Время: ${meal.time}'),
                );
              },
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => mealProvider.loadMeals(),
        child: const Icon(Icons.refresh),
      ),
    );
  }
}