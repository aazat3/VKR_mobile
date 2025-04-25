import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:carousel_slider/carousel_slider.dart';

final CarouselSliderController _controller = CarouselSliderController();
final ValueNotifier<int> _currentIndexNotifier = ValueNotifier<int>(0);

class StatisticCarousel extends StatelessWidget {
  const StatisticCarousel({super.key});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        return Column(
          children: [
            CarouselSlider(
              carouselController: _controller,
              options: CarouselOptions(
                height: constraints.maxHeight * 0.9,
                // aspectRatio: 1.0,
                enableInfiniteScroll: false,
                enlargeCenterPage: true,
                viewportFraction: 0.8,
                onPageChanged: (index, reason) {
                    _currentIndexNotifier.value = index;
                },
              ),
              items: [
                _buildChartCard("Калории", LineChart(_lineChartData())),
                _buildChartCard("БЖУ", PieChart(_pieChartData())),
                _buildChartCard("График 3", Placeholder()),
              ],
            ),
            ValueListenableBuilder<int>(
              valueListenable: _currentIndexNotifier,
              builder: (context, value, _) {
                return Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [1, 2, 3].asMap().entries.map((entry) {
                    return GestureDetector(
                      onTap: () => _controller.animateToPage(entry.key),
                      child: Container(
                        width: 12.0,
                        height: 12.0,
                        margin: EdgeInsets.symmetric(vertical: 8.0, horizontal: 4.0),
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: (Theme.of(context).brightness == Brightness.dark
                                  ? Colors.white
                                  : Colors.black)
                              .withOpacity(
                                value == entry.key ? 0.9 : 0.4,
                              ),
                        ),
                      ),
                    );
                  }).toList(),
                );
              },
            )
          ],
        );
      },
    );
  }

  Widget _buildChartCard(String title, Widget chart) {
    return LayoutBuilder(
      builder: (context, constraints) {
        return FractionallySizedBox(
          widthFactor: 1.0, // 90% ширины родителя
          heightFactor: 1.0, // 50% высоты родителя
          child: Card(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            elevation: 4,
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 16),
                  // Ограничим максимальную высоту графика
                  SizedBox(
                    height: constraints.maxHeight * 0.6, // 60% высоты карточки
                    child: chart,
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  LineChartData _lineChartData() {
    return LineChartData(
      titlesData: FlTitlesData(show: false),
      borderData: FlBorderData(show: false),
      gridData: FlGridData(show: false),
      lineBarsData: [
        LineChartBarData(
          spots: const [
            FlSpot(0, 1),
            FlSpot(1, 3),
            FlSpot(2, 2),
            FlSpot(3, 4),
            FlSpot(4, 3),
          ],
          isCurved: true,
          color: Colors.blue,
          dotData: FlDotData(show: true),
          belowBarData: BarAreaData(show: false),
        ),
      ],
    );
  }

  PieChartData _pieChartData() {
    return PieChartData(
      sections: [
        PieChartSectionData(
          value: 30,
          title: 'Белки',
          color: Colors.blue,
          radius: 50,
        ),
        PieChartSectionData(
          value: 40,
          title: 'Жиры',
          color: Colors.red,
          radius: 50,
        ),
        PieChartSectionData(
          value: 30,
          title: 'Углеводы',
          color: Colors.green,
          radius: 50,
        ),
      ],
    );
  }
}
