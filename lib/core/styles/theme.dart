import 'package:flutter/material.dart';

class AppTheme {
  static ThemeData get lightTheme {
    return ThemeData(
      brightness: Brightness.light,
      scaffoldBackgroundColor: Colors.white,
      fontFamily: 'Comfortaa', // This sets Comfortaa as default for ALL text
      colorScheme: ColorScheme.fromSeed(
        primary: Colors.white,
        onPrimary: Colors.black,
        secondary: Colors.grey,
        seedColor: Colors.green,
        brightness: Brightness.light,
      ),
      // Remove redundant textTheme - fontFamily above handles it
    );
  }

  static ThemeData get darkTheme {
    return ThemeData(
      brightness: Brightness.dark,
      scaffoldBackgroundColor: Colors.black,
      fontFamily: 'Comfortaa', // This sets Comfortaa as default for ALL text
      colorScheme: ColorScheme.fromSeed(
        primary: Colors.black,
        onPrimary: Colors.white,
        secondary: Colors.grey,
        seedColor: Colors.green,
        brightness: Brightness.dark,
      ),
      // Remove redundant textTheme - fontFamily above handles it
    );
  }
}
