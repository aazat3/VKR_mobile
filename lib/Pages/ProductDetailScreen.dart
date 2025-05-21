// product_detail_screen.dart
import 'package:flutter/material.dart';
import '../Models/ProductModel/ProductModel.dart';

class ProductDetailScreen extends StatelessWidget {
  final ProductModel product;

  const ProductDetailScreen({super.key, required this.product, });

 @override
Widget build(BuildContext context) {
  return Scaffold(
    appBar: AppBar(
      title: Text(product.name),
    ),
    body: SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildSectionTitle('Основные характеристики'),
          _buildInfoCard([
            _buildInfoRow('Категория', product.category?.name ?? 'Не указана'),
            _buildInfoRow('Калории', _formatValue(product.energyKcal, 'ккал')),
            _buildInfoRow('Вода', _formatPercent(product.waterPercent)),
            _buildInfoRow('Белки', _formatPercent(product.proteinPercent)),
            _buildInfoRow('Жиры', _formatPercent(product.fatPercent)),
            _buildInfoRow('Углеводы', _formatPercent(product.carbohydratesPercent)),
              _buildInfoRow('Клетчатка', _formatPercent(product.fiberPercent)),

            _buildInfoRow('Алкоголь', _formatPercent(product.ethanolPercent)),
          ]),
          

          _buildSectionTitle('Минеральный состав'),
          _buildInfoCard([
            _buildInfoRow('Натрий (Na)', _formatMilligrams(product.sodiumMg)),
            _buildInfoRow('Калий (K)', _formatMilligrams(product.potassiumMg)),
            _buildInfoRow('Кальций (Ca)', _formatMilligrams(product.calciumMg)),
            _buildInfoRow('Магний (Mg)', _formatMilligrams(product.magnesiumMg)),
            _buildInfoRow('Фосфор (P)', _formatMilligrams(product.phosphorusMg)),
            _buildInfoRow('Железо (Fe)', _formatMilligrams(product.ironMg)),
          ]),

          _buildSectionTitle('Витамины'),
          _buildInfoCard([
            _buildInfoRow('Ретинол (A)', _formatMicrograms(product.retinolUg)),
            _buildInfoRow('Бета-каротин', _formatMicrograms(product.betaCaroteneUg)),
            _buildInfoRow('Ретинол эквивалент', _formatMicrograms(product.retinolEqUg)),
            _buildInfoRow('Токоферол эквивалент (E)', _formatMilligrams(product.tocopherolEqMg)),
            _buildInfoRow('Тиамин (B1)', _formatMilligrams(product.thiamineMg)),
            _buildInfoRow('Рибофлавин (B2)', _formatMilligrams(product.riboflavinMg)),
            _buildInfoRow('Ниацин (PP)', _formatMilligrams(product.niacinMg)),
            _buildInfoRow('Ниацин эквивалент', _formatMilligrams(product.niacinEqMg)),
            _buildInfoRow('Аскорбиновая кислота (C)', _formatMilligrams(product.ascorbicAcidMg)),
          ]),

          _buildSectionTitle('Дополнительные компоненты'),
          _buildInfoCard([
            _buildInfoRow('Крахмал', _formatPercent(product.starchPercent)),
            _buildInfoRow('Насыщенные жирные кислоты', _formatPercent(product.saturatedFaPercent)),
            _buildInfoRow('Полиненасыщенные жирные кислоты', _formatPercent(product.polyunsaturatedFaPercent)),
            _buildInfoRow('Холестерин', _formatMilligrams(product.cholesterolMg)),
            _buildInfoRow('Моно- и дисахариды', _formatPercent(product.monodisaccharidesPercent)),
            _buildInfoRow('Зола', _formatPercent(product.ashPercent)),
            _buildInfoRow('Органические кислоты', _formatPercent(product.organicAcidsPercent)),
          ]),

        ],
      ),
    ),
  );
}

  Widget _buildSectionTitle(String title) {
  return Padding(
    padding: const EdgeInsets.symmetric(vertical: 12),
    child: Text(
      title,
      style: const TextStyle(
        fontSize: 18,
        fontWeight: FontWeight.bold,
        color: Colors.blueGrey,
      ),
    ),
  );
}

  Widget _buildInfoCard(List<Widget> children) {
  final filteredChildren = children.whereType<Widget>().toList();
  
  return Card(
    elevation: 2,
    margin: const EdgeInsets.only(bottom: 16),
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(10),
    ),
    child: Padding(
      padding: const EdgeInsets.all(12),
      child: Column(
        children: filteredChildren
          .expand((widget) => [widget, const Divider(height: 1)])
          .take(filteredChildren.length * 2 - 1)
          .toList(),
      ),
    ),
  );
}

Widget _buildInfoRow(String label, String? value) {
  if (value == null || value.isEmpty) return const SizedBox.shrink();
  
  return Padding(
    padding: const EdgeInsets.symmetric(vertical: 8),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(
          child: Text(
            label,
            style: TextStyle(
              fontSize: 16,
              color: Colors.grey.shade700,
            ),
          ),
        ),
        Text(
          value,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w500,
            color: Colors.black87,
          ),
        ),
      ],
    ),
  );
}

String? _formatPercent(double? value) {
  return value != null ? '${value.toStringAsFixed(2)} г' : null;
}

String? _formatMilligrams(double? value) {
  return value != null ? '${value.toStringAsFixed(2)} мг' : null;
}

String? _formatMicrograms(double? value) {
  return value != null ? '${value.toStringAsFixed(2)} мкг' : null;
}


  String? _formatValue(double? value, [String? unit]) {
    if (value == null) return null;
    return '${value.toStringAsFixed(1)}${unit != null ? ' $unit' : ''}';
  }
}