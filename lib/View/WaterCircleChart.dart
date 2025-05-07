import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';

class WaterCircleChart extends StatelessWidget {
  final double water;

  const WaterCircleChart({
    super.key,
    required this.water,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.center,
      children: [
        PieChart(
          PieChartData(
            centerSpaceRadius: 40,
            sections: [
              PieChartSectionData(
                value: 1500,
                title: '',
                color: Color.fromARGB(255, 30, 84, 201),
                radius: 25,
                titleStyle: const TextStyle(color: Colors.white, fontSize: 14),
              ),
              PieChartSectionData(
                value: 1000,
                title: '',
                color: Colors.grey.shade300,
                radius: 25,
                titleStyle: const TextStyle(color: Colors.black, fontSize: 14),
              ),
            ],
          ),
        ),
        Text(
                '${26.toStringAsFixed(0)}%',
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
