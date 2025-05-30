import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';

class WaterCircleChart extends StatelessWidget {
  final double consumed;
  final double goal;

  const WaterCircleChart({
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
            centerSpaceRadius: 40,
            sections: [
              PieChartSectionData(
                value: consumed,
                title: '',
                color: Color.fromARGB(255, 30, 84, 201),
                radius: 25,
                titleStyle: const TextStyle(color: Colors.white, fontSize: 14),
              ),
              PieChartSectionData(
                value: remaining.toDouble(),
                title: '',
                color: Colors.grey.shade300,
                radius: 25,
                titleStyle: const TextStyle(color: Colors.black, fontSize: 14),
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
