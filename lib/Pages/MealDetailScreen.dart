// product_detail_screen.dart
import 'package:flutter/material.dart';
import '../Models/ProductModel/ProductModel.dart';

class Mealdetailscreen extends StatelessWidget {
  final ProductModel product;
  final int weight;

  const Mealdetailscreen({
    super.key,
    required this.product,
    required this.weight,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(product.name)),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildSectionTitle('Основные характеристики'),
            _buildInfoCard([
              _buildInfoRow(
                'Категория',
                product.category?.name ?? 'Не указана',
              ),
              _buildDoubleInfoRow(
                'Калории',
                _formatValue(product.energyKcal, 'ккал'),
                _formatValue(_calcValue(product.energyKcal), 'ккал'),
              ),
              _buildDoubleInfoRow(
                'Вода',
                _formatPercent(product.waterPercent),
                _formatPercent(_calcValue(product.waterPercent)),
              ),
              _buildDoubleInfoRow(
                'Белки',
                _formatPercent(product.proteinPercent),
                _formatPercent(_calcValue(product.proteinPercent)),
              ),
              _buildDoubleInfoRow(
                'Жиры',
                _formatPercent(product.fatPercent),
                _formatPercent(_calcValue(product.fatPercent)),
              ),
              _buildDoubleInfoRow(
                'Углеводы',
                _formatPercent(product.carbohydratesPercent),
                _formatPercent(_calcValue(product.carbohydratesPercent)),
              ),
              _buildDoubleInfoRow(
                'Клетчатка',
                _formatPercent(product.fiberPercent),
                _formatPercent(_calcValue(product.fiberPercent)),
              ),

              _buildDoubleInfoRow(
                'Алкоголь',
                _formatPercent(product.ethanolPercent),
                _formatPercent(_calcValue(product.ethanolPercent)),
              ),
            ]),

            _buildSectionTitle('Минеральный состав'),
            _buildInfoCard([
              _buildDoubleInfoRow(
                'Натрий (Na)',
                _formatMilligrams(product.sodiumMg),
                _formatMilligrams(_calcValue(product.sodiumMg)),
              ),
              _buildDoubleInfoRow(
                'Калий (K)',
                _formatMilligrams(product.potassiumMg),
                _formatMilligrams(_calcValue(product.potassiumMg)),
              ),
              _buildDoubleInfoRow(
                'Кальций (Ca)',
                _formatMilligrams(product.calciumMg),
                _formatMilligrams(_calcValue(product.calciumMg)),
              ),
              _buildDoubleInfoRow(
                'Магний (Mg)',
                _formatMilligrams(product.magnesiumMg),
                _formatMilligrams(_calcValue(product.magnesiumMg)),
              ),
              _buildDoubleInfoRow(
                'Фосфор (P)',
                _formatMilligrams(product.phosphorusMg),
                _formatMilligrams(_calcValue(product.phosphorusMg)),
              ),
              _buildDoubleInfoRow(
                'Железо (Fe)',
                _formatMilligrams(product.ironMg),
                _formatMilligrams(_calcValue(product.ironMg)),
              ),
            ]),

            _buildSectionTitle('Витамины'),
            _buildInfoCard([
              _buildDoubleInfoRow(
                'Ретинол (A)',
                _formatMicrograms(product.retinolUg),
                _formatMicrograms(_calcValue(product.retinolUg)),
              ),
              _buildDoubleInfoRow(
                'Бета-каротин',
                _formatMicrograms(product.betaCaroteneUg),
                _formatMicrograms(_calcValue(product.betaCaroteneUg)),
              ),
              _buildDoubleInfoRow(
                'Ретинол эквивалент',
                _formatMicrograms(product.retinolEqUg),
                _formatMicrograms(_calcValue(product.retinolEqUg)),
              ),
              _buildDoubleInfoRow(
                'Токоферол эквивалент (E)',
                _formatMilligrams(product.tocopherolEqMg),
                _formatMilligrams(_calcValue(product.tocopherolEqMg)),
              ),
              _buildDoubleInfoRow(
                'Тиамин (B1)',
                _formatMilligrams(product.thiamineMg),
                _formatMilligrams(_calcValue(product.thiamineMg)),
              ),
              _buildDoubleInfoRow(
                'Рибофлавин (B2)',
                _formatMilligrams(product.riboflavinMg),
                _formatMilligrams(_calcValue(product.riboflavinMg)),
              ),
              _buildDoubleInfoRow(
                'Ниацин (PP)',
                _formatMilligrams(product.niacinMg),
                _formatMilligrams(_calcValue(product.niacinMg)),
              ),
              _buildDoubleInfoRow(
                'Ниацин эквивалент',
                _formatMilligrams(product.niacinEqMg),
                _formatMilligrams(_calcValue(product.niacinEqMg)),
              ),
              _buildDoubleInfoRow(
                'Аскорбиновая кислота (C)',
                _formatMilligrams(product.ascorbicAcidMg),
                _formatMilligrams(_calcValue(product.ascorbicAcidMg)),
              ),
            ]),

            _buildSectionTitle('Дополнительные компоненты'),
            _buildInfoCard([
              _buildDoubleInfoRow(
                'Крахмал',
                _formatPercent(product.starchPercent),
                _formatPercent(_calcValue(product.starchPercent)),
              ),
              _buildDoubleInfoRow(
                'Насыщенные жирные кислоты',
                _formatPercent(product.saturatedFaPercent),
                _formatPercent(_calcValue(product.saturatedFaPercent)),
              ),
              _buildDoubleInfoRow(
                'Полиненасыщенные жирные кислоты',
                _formatPercent(product.polyunsaturatedFaPercent),
                _formatPercent(_calcValue(product.polyunsaturatedFaPercent)),
              ),
              _buildDoubleInfoRow(
                'Холестерин',
                _formatMilligrams(product.cholesterolMg),
                _formatMilligrams(_calcValue(product.cholesterolMg)),
              ),
              _buildDoubleInfoRow(
                'Моно- и дисахариды',
                _formatPercent(product.monodisaccharidesPercent),
                _formatPercent(_calcValue(product.monodisaccharidesPercent)),
              ),
              _buildDoubleInfoRow(
                'Зола',
                _formatPercent(product.ashPercent),
                _formatPercent(_calcValue(product.ashPercent)),
              ),
              _buildDoubleInfoRow(
                'Органические кислоты',
                _formatPercent(product.organicAcidsPercent),
                _formatPercent(_calcValue(product.organicAcidsPercent)),
              ),
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
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          children:
              filteredChildren
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
              style: TextStyle(fontSize: 16, color: Colors.grey.shade700),
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

  Widget _buildDoubleInfoRow(
    String label,
    String? valuePer100, [
    String? valuePerWeight,
  ]) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Text(
              label,
              style: TextStyle(fontSize: 16, color: Colors.grey.shade700),
            ),
          ),
          _buildFirstValueColumn(valuePer100, '100 г'),
          const SizedBox(width: 20),
          _buildSecondValueColumn(
            valuePerWeight ?? '-',
            '${weight.toStringAsFixed(1)} г',
          ),
        ],
      ),
    );
  }

  Widget _buildFirstValueColumn(String? value, String subtitle) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Text(
          value ?? '-',
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w500,
            color: Colors.grey,
          ),
        ),
        Text(
          subtitle,
          style: TextStyle(fontSize: 12, color: Colors.grey.shade500),
        ),
      ],
    );
  }
   Widget _buildSecondValueColumn(String? value, String subtitle) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Text(
          value ?? '-',
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w500,
            color: Colors.black87,
          ),
        ),
        Text(
          subtitle,
          style: TextStyle(fontSize: 12, color: Colors.grey.shade500),
        ),
      ],
    );
  }

  double? _calcValue(double? per100) {
    return per100 != null ? (per100 * weight) / 100 : null;
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
