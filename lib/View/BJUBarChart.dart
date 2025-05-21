import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';

class BJUBarChart extends StatelessWidget {
  final double protein;
  final double fat;
  final double carbs;

  const BJUBarChart({
    super.key,
    required this.protein,
    required this.fat,
    required this.carbs,
  });

  @override
  Widget build(BuildContext context) {
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
                value: 2.64,
                color: Colors.blue,
                radius: 10, // Радиус внешнего кольца
                title: '',
              ),
              PieChartSectionData(
                value: 120,
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
                value: 0.88,
                color: Colors.green,
                radius: 10, // Радиус среднего кольца
                title: '',
              ),
              PieChartSectionData(
                value: 100,
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
                value: 36.96,
                color: Colors.red,
                radius: 10, // Радиус внутреннего кfруга
                title: '',
              ),
              PieChartSectionData(
                value: 100,
                color: Colors.grey.shade300,
                radius: 10, // Радиус внешнего кольца
                title: '',
              ),
            ],
          ),
        ),

        // Текст в центре
        // Text('75%', style: TextStyle(fontSize: 20)),
      ],
    );

    // return BarChart(
    //   BarChartData(
    //     alignment: BarChartAlignment.spaceAround,
    //     maxY: ([
    //           protein,
    //           fat,
    //           carbs,
    //         ].reduce((a, b) => a > b ? a : b) *
    //         1.2), // немного отступа сверху
    //     barGroups: [
    //       _makeGroup(0, protein, Colors.green, 'Белки'),
    //       _makeGroup(1, fat, Colors.orange, 'Жиры'),
    //       _makeGroup(2, carbs, Colors.blue, 'Углеводы'),
    //     ],
    //     titlesData: FlTitlesData(
    //       leftTitles: AxisTitles(
    //         sideTitles: SideTitles(showTitles: true),
    //       ),
    //       bottomTitles: AxisTitles(
    //         sideTitles: SideTitles(
    //           showTitles: true,
    //           getTitlesWidget: (value, _) {
    //             switch (value.toInt()) {
    //               case 0:
    //                 return const Text('Белки');
    //               case 1:
    //                 return const Text('Жиры');
    //               case 2:
    //                 return const Text('Углеводы');
    //               default:
    //                 return const Text('');
    //             }
    //           },
    //         ),
    //       ),
    //     ),
    //     borderData: FlBorderData(show: false),
    //     gridData: FlGridData(show: false),
    //   ),
    // );
  }

  BarChartGroupData _makeGroup(int x, double y, Color color, String label) {
    return BarChartGroupData(
      x: x,
      barRods: [
        BarChartRodData(
          toY: y,
          color: color,
          width: 20,
          borderRadius: BorderRadius.circular(6),
        ),
      ],
    );
  }
}
