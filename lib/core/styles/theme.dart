import 'package:flutter/material.dart';

class AppTheme {
  static ThemeData get lightTheme {
    return ThemeData(
      brightness: Brightness.light,
      scaffoldBackgroundColor: Colors.white,
      // primaryColor: Colors.green,
      colorScheme: ColorScheme.fromSeed(
        primary: Colors.white,
        onPrimary: Colors.black,
        secondary: Colors.grey,
        seedColor: Colors.green,
        brightness: Brightness.light,
      ),
      // Add more customizations if needed
    );
  }

  static ThemeData get darkTheme {
    return ThemeData(
      brightness: Brightness.dark,
      scaffoldBackgroundColor: Colors.black,
      // primaryColor: Colors.green,
      colorScheme: ColorScheme.fromSeed(
        primary: Colors.black,
        onPrimary: Colors.white,
        secondary: Colors.grey,
        seedColor: Colors.green,
        brightness: Brightness.dark,
      ),
    );
  }
}