import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';

class BJUBarChart extends StatelessWidget {
  final double consumedProtein;
  final double consumedFat;
  final double consumedCarbs;
  final double goalProtein;
  final double goalFat;
  final double goalCarb;

  const BJUBarChart({
    super.key,
    required this.consumedProtein,
    required this.consumedFat,
    required this.consumedCarbs,
    required this.goalProtein,
    required this.goalFat,
    required this.goalCarb,
  });

  @override
  Widget build(BuildContext context) {
    final remainingProtein = (goalProtein - consumedProtein).clamp(
      0,
      goalProtein,
    );
    final remainingFat = (goalFat - consumedFat).clamp(0, goalFat);
    final remainingCarb = (goalCarb - consumedCarbs).clamp(0, goalCarb);
    return Stack(
      alignment: Alignment.center,
      children: [
        // Внешнее кольцо
        PieChart(
          PieChartData(
            sectionsSpace: 2,
            centerSpaceRadius: 55, // Размер центрального отверстия
            sections: [
              PieChartSectionData(
                value: consumedCarbs,
                color: Colors.blue,
                radius: 10, // Радиус внешнего кольца
                title: '',
              ),
              PieChartSectionData(
                value: remainingCarb.toDouble(),
                color: Colors.grey.shade300,
                radius: 10, // Радиус внешнего кольца
                title: '',
              ),
            ],
          ),
        ),

        // Среднее кольцо
        PieChart(
          PieChartData(
            sectionsSpace: 2,
            centerSpaceRadius: 30,
            sections: [
              PieChartSectionData(
                value: consumedFat,
                color: Colors.green,
                radius: 10, // Радиус среднего кольца
                title: '',
              ),
              PieChartSectionData(
                value: remainingFat.toDouble(),
                color: Colors.grey.shade300,
                radius: 10, // Радиус внешнего кольца
                title: '',
              ),
            ],
          ),
        ),

        // Внутренний круг
        PieChart(
          PieChartData(
            sectionsSpace: 2,
            centerSpaceRadius: 10,
            sections: [
              PieChartSectionData(
                value: consumedProtein,
                color: Colors.red,
                radius: 10, // Радиус внутреннего кfруга
                title: '',
              ),
              PieChartSectionData(
                value: remainingProtein.toDouble(),
                color: Colors.grey.shade300,
                radius: 10, // Радиус внешнего кольца
                title: '',
              ),
            ],
          ),
        ),
      ],
    );
  }
}
