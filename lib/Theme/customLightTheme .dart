import 'package:flutter/material.dart';

final ThemeData customLightTheme = ThemeData(
  colorScheme: ColorScheme.fromSeed(
    seedColor: Color(0xFF008C8C), // Основной акцентный цвет
    brightness: Brightness.light,
  ),
  useMaterial3: true,
  scaffoldBackgroundColor: const Color(0xFFF5F7FA),
  appBarTheme: const AppBarTheme(
    foregroundColor: Colors.black87,
    surfaceTintColor: Colors.transparent,
    elevation: 0,
    scrolledUnderElevation: 0,
    centerTitle: true,
    titleTextStyle: TextStyle(
      fontSize: 20,
      fontWeight: FontWeight.w600,
      color: Colors.black87,
    ),
  ),
  textTheme: const TextTheme(
    titleLarge: TextStyle(
      fontSize: 22,
      fontWeight: FontWeight.bold,
      color: Colors.black87,
    ),
    titleMedium: TextStyle(
      fontSize: 18,
      fontWeight: FontWeight.w500,
      color: Colors.black87,
    ),
    bodyMedium: TextStyle(
      fontSize: 16,
      color: Colors.black87,
    ),
  ),
  cardTheme: CardTheme(
    elevation: 3,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(16),
    ),
    margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
  ),
  elevatedButtonTheme: ElevatedButtonThemeData(
    style: ElevatedButton.styleFrom(
      backgroundColor: Color(0xFF008C8C),
      foregroundColor: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
      textStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
    ),
  ),
  inputDecorationTheme: InputDecorationTheme(
    filled: true,
    fillColor: Colors.white,
    contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
    border: OutlineInputBorder(
      borderRadius: BorderRadius.circular(12),
      borderSide: const BorderSide(color: Color(0xFF008C8C),),
    ),
    focusedBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(12),
      borderSide: const BorderSide(color: Color(0xFF008C8C), width: 2),
    ),
  ),
);
