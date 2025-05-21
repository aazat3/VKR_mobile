// widgets/Productcard.dart

import 'package:flutter/material.dart';
import 'package:flutter_application_1/Models/ProductModel/ProductModel.dart';
import 'package:flutter_application_1/Pages/ProductDetailScreen.dart';

class Productcard extends StatelessWidget {
  final ProductModel product;

  const Productcard({super.key, required this.product});

  @override
Widget build(BuildContext context) {
  final (icon, color) = _getCategoryIcon(product.category?.id);
  
  return InkWell(
    borderRadius: BorderRadius.circular(16),
    onTap: () {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => ProductDetailScreen(product: product),
        ),
      );
        },
    child: Card(
      color: const Color.fromARGB(255, 226, 245, 240),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      elevation: 4,
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
                    product.name,
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
                const SizedBox(width: 8),
                Text(
                  'Э- ${((product.energyKcal ?? 0)).toStringAsFixed(1)} ккал',
                ),
                const SizedBox(width: 8),
                Text(
                  'Б- ${((product.proteinPercent ?? 0)).toStringAsFixed(1)} г',
                ),
                const SizedBox(width: 8),
                Text(
                  'Ж- ${((product.fatPercent ?? 0)).toStringAsFixed(1)} г',
                ),
                const SizedBox(width: 8),
                Text(
                  'У- ${((product.carbohydratesPercent ?? 0)).toStringAsFixed(1)} г',
                ),
              ],
            ),
          ],
        ),
      ),
    ),
  );
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
