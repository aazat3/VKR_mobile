// widgets/MealCard.dart

import 'package:flutter/material.dart';
import 'package:flutter_application_1/Pages/MealDetailScreen.dart';
import '../Models/MealModel/MealModel.dart'; // путь зависит от твоей структуры проекта
import '/Providers/MealProvider.dart';
import 'package:provider/provider.dart';

class MealCard extends StatelessWidget {
  final MealModel meal;

  const MealCard({super.key, required this.meal});

  @override
  Widget build(BuildContext context) {
    final (icon, color) = _getCategoryIcon(meal.product?.category?.id);
    final mealProvider = Provider.of<MealProvider>(context, listen: false);

    return Dismissible(
      key: Key('meal_${meal.id}'),
      direction: DismissDirection.endToStart,
      background: Container(
        decoration: BoxDecoration(
          color: Colors.red,
          borderRadius: BorderRadius.circular(16),
        ),
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.only(right: 20),
        child: const Icon(Icons.delete_forever, color: Colors.white, size: 30),
      ),
      confirmDismiss: (direction) async {
        return await showDialog(
          context: context,
          builder: (ctx) => AlertDialog(
            title: const Text('Подтверждение удаления'),
            content: const Text('Вы уверены, что хотите удалить этот прием пищи?'),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(ctx).pop(false),
                child: const Text('Отмена'),
              ),
              TextButton(
                onPressed: () => Navigator.of(ctx).pop(true),
                child: const Text('Удалить', style: TextStyle(color: Colors.red)),
              ),
            ],
          ),
        );
      },
      onDismissed: (direction) async {
        try {
          await mealProvider.deleteMeal(meal.id);
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: const Text('Прием пищи удален'),
              action: SnackBarAction(
                label: 'Отменить',
                onPressed: () => mealProvider.restoreMeal(meal),
              ),
            ),
          );
        } catch (e) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Ошибка удаления: ${e.toString()}'),
              backgroundColor: Colors.red,
            ),
          );
        }
      },
      child: InkWell(
        // Ваш существующий код карточки
        borderRadius: BorderRadius.circular(16),
        onTap: () {
          if (meal.product != null) {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => Mealdetailscreen(
                  product: meal.product!,
                  weight: meal.weight,
                ),
              ),
            );
          }
        },
      child: Card(
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
                  Icon(icon, color: color),
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
            ],
          ),
        ),
      ),
    ));
  }

  (IconData, Color) _getCategoryIcon(int? categoryId) {
    const defaultIcon = Icons.fastfood;
    const defaultColor = Colors.orange;

    if (categoryId == null) return (defaultIcon, defaultColor);

    switch (categoryId) {
      case 1: // Молочные продукты
        return (Icons.local_drink, Colors.lightBlue.shade400);
      case 2: // Яйца и яйцепродукты
        return (Icons.egg, Colors.yellow.shade700);
      case 3: // Мясные продукты
        return (Icons.set_meal, Colors.brown.shade600);
      case 4: // Рыбные продукты
        return (Icons.water, Colors.blue.shade700);
      case 5: // Жировые продукты
        return (Icons.oil_barrel, Colors.amber.shade600);
      case 6: // Зерновые продукты
        return (Icons.grass, Colors.green.shade700);
      case 7: // Бобовые, орехи
        return (Icons.eco, Colors.lightGreen.shade700);
      case 8: // Овощи, картофель и грибы
        return (Icons.forest, Colors.green.shade900);
      case 9: // Фрукты и ягоды
        return (Icons.apple, Colors.red.shade600);
      case 10: // Кондитерские изделия
        return (Icons.cake, Colors.pink.shade400);
      case 11: // Напитки
        return (Icons.local_cafe, Colors.brown.shade400);
      case 12: // Вспомогательные вещества
        return (Icons.science, Colors.deepPurple.shade400);
      default:
        return (defaultIcon, defaultColor);
    }
  }
}
