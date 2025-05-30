import 'package:flutter/material.dart';
import 'package:flutter_application_1/Providers/CategoryProvider.dart';
import 'package:flutter_application_1/Providers/GoalProvider.dart';
import 'package:provider/provider.dart';

import '/Theme/customLightTheme .dart';

import 'Pages/HomePage.dart';
import '/Pages/LoginPage.dart';

import 'Providers/AuthProvider.dart';
import 'Providers/ProductProvider.dart';
// import 'Providers/NavigationProvider.dart';
import 'Providers/MealProvider.dart';


void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthProvider()..tryAutoLogin()),
        ChangeNotifierProvider(create: (_) => ProductProvider()),
        ChangeNotifierProvider(create: (_) => MealProvider()),
        ChangeNotifierProvider(create: (_) => CategoryProvider()),
        ChangeNotifierProvider(create: (_) => GoalProvider()),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Nutrition Tracker',
      theme: customLightTheme,
      // theme: ThemeData.light(useMaterial3: true),
      routes: {
        // '/': (context) => const HomePage(),
        '/login': (context) => const LoginPage(), // 🔹 ВАЖНО: добавляем маршрут!
      },
      home: Consumer<AuthProvider>(
        builder: (context, auth, _) {
          return auth.isAuthenticated ? const HomePage() : const LoginPage();
        },
      ),
    );
  }
}
