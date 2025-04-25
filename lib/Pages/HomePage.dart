import 'package:flutter/material.dart';
import '/Controller/HomeController.dart';
import '/View/HomeView.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late final HomeController controller;

  @override
  void initState() {
    super.initState();
    controller = HomeController();
    controller.init(context);
  }

  @override
  Widget build(BuildContext context) {
    return HomeView(controller: controller);
  }
}