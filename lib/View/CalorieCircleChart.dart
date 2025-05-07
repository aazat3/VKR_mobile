import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';

class CalorieCircleChart extends StatelessWidget {
  final double consumed;
  final double goal;

  const CalorieCircleChart({
    super.key,
    required this.consumed,
    required this.goal,
  });

  @override
  Widget build(BuildContext context) {
    final remaining = (goal - consumed).clamp(0, goal);
    final percentage = ((consumed / goal) * 100).clamp(0, 100);
    return Stack(
            alignment: Alignment.center,
            children: [
              PieChart(
                PieChartData(
                  centerSpaceRadius: 40, // Размер центрального пустого пространства
                  sectionsSpace: 2,
                  sections: [
                    PieChartSectionData(
                      value: consumed,
                      color: const Color(0xFFF16700),
                      radius: 25,
                      title: '', // Убираем текст из секции
                    ),
                    PieChartSectionData(
                      value: remaining.toDouble(),
                      color: Colors.grey.shade300,
                      radius: 25,
                      title: '',
                    ),
                  ],
                ),
              ),
              Text(
                '${percentage.toStringAsFixed(0)}%',
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ],
          );
  }
}
