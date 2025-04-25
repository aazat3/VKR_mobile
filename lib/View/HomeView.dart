import 'package:flutter/material.dart';
import '/Pages/StatisticPage.dart';
import '/Pages/ProductPage.dart';
import '/Pages/SettingsPage.dart';
import '/Pages/MainPage.dart';
import '/Controller/HomeController.dart';

class HomeView extends StatefulWidget {
  final HomeController controller;

  const HomeView({super.key, required this.controller});

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  @override
  void dispose() {
    widget.controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PageView(
        controller: widget.controller.pageController,
        physics: NeverScrollableScrollPhysics(),
        children: const [
          MainPage(),
          StatisticPage(),
          ProductPage(),
          SettingsPage(),
        ],
      ),
      bottomNavigationBar: NavigationBar(
        selectedIndex: widget.controller.currentIndex,
        onDestinationSelected: (index) =>
            widget.controller.onTabTapped(index, () => setState(() {})),
        destinations: const [
          NavigationDestination(icon: Icon(Icons.list), label: 'Главное'),
          NavigationDestination(icon: Icon(Icons.bar_chart), label: 'Статистика'),
          NavigationDestination(icon: Icon(Icons.list), label: 'Продукты'),
          NavigationDestination(icon: Icon(Icons.settings), label: 'Настройки'),
        ],
      ),
      // floatingActionButton: widget.controller.showFab()
      //     ? FloatingActionButton(
      //         onPressed: () {
      //           // TODO: переход к экрану добавления продукта
      //         },
      //         child: const Icon(Icons.add),
      //       )
      //     : null,
    );
  }
}
