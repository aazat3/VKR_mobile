import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '/Providers/ProductProvider.dart';

class HomeController {
  int currentIndex = 0;
  late PageController pageController;

  void init(BuildContext context) {
    pageController = PageController(initialPage: currentIndex);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<ProductProvider>(context, listen: false).loadProducts();
    });
  }

  void dispose() {
    pageController.dispose();
  }

  void onTabTapped(int index, VoidCallback updateUI) {
    currentIndex = index;
    pageController.jumpToPage(index);
    updateUI();
  }

  // bool showFab() => currentIndex == 0;
}
