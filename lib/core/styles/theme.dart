import 'package:flutter/material.dart';

class AppTheme {
  static ThemeData get lightTheme {
    return ThemeData(
      // The primary swatch defines the base color for the app (used in progress bars, sliders, etc.)
      primarySwatch: Colors.green,

      // Sets the overall brightness to light
      brightness: Brightness.light,

      // Background color for all scaffold widgets (pages) in light mode
      scaffoldBackgroundColor: Colors.white, // White background for clean look
      primaryColor: Colors.green, // Primary color for the app
      // AppBar styling for light mode
      appBarTheme: const AppBarTheme(
        backgroundColor: Colors.white, // AppBar background color
        elevation: 0, // Removes shadow
        iconTheme: IconThemeData(color: Colors.white), // AppBar icons (e.g., back button) in white
        titleTextStyle: TextStyle(
          color: Colors.black, // AppBar title text color
          fontSize: 20,
          fontWeight: FontWeight.bold,
        ),
      ),

      // Default style for all ElevatedButtons in the app (light mode)
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.green, // Button background
          foregroundColor: Colors.white, // Text/icon color
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8), // Rounded corners
          ),
        ),
      ),

      // Typography settings for light theme
      textTheme: const TextTheme(
        headlineLarge: TextStyle(
          color: Colors.black, // Large heading text color
          fontSize: 24,
          fontWeight: FontWeight.bold,
        ),
        headlineMedium: TextStyle(
          color: Colors.black, // Medium heading text color
          fontSize: 20,
          fontWeight: FontWeight.bold,
        ),
        bodyLarge: TextStyle(
          color: Colors.black87, // Body text, slightly lighter black
          fontSize: 16,
        ),
        bodyMedium: TextStyle(
          color: Colors.black87, // Medium body text
          fontSize: 14,
        ),
      ),
    );
  }

  // Dark theme configuration
  static ThemeData get darkTheme {
    return ThemeData(
      primarySwatch: Colors.green, // Same primary color as light theme

      brightness: Brightness.dark, // Enables dark mode

      scaffoldBackgroundColor: Colors.black, // Dark background for scaffold

      appBarTheme: const AppBarTheme(
        backgroundColor: Colors.black, // AppBar matches dark background
        elevation: 0,
        iconTheme: IconThemeData(color: Colors.white), // Icons in white for visibility
        titleTextStyle: TextStyle(
          color: Colors.white, // AppBar title in white
          fontSize: 20,
          fontWeight: FontWeight.bold,
        ),
      ),

      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.green, // Green button for accent
          foregroundColor: Colors.white, // White text/icon for contrast
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
        ),
      ),

      textTheme: const TextTheme(
        headlineLarge: TextStyle(
          color: Colors.white, // Large heading text in white
          fontSize: 24,
          fontWeight: FontWeight.bold,
        ),
        headlineMedium: TextStyle(
          color: Colors.white, // Medium heading in white
          fontSize: 20,
          fontWeight: FontWeight.bold,
        ),
        bodyLarge: TextStyle(
          color: Colors.white70, // Slightly dimmed white for body text
          fontSize: 16,
        ),
        bodyMedium: TextStyle(
          color: Colors.white70, // Consistent medium body text
          fontSize: 14,
        ),
      ),
    );
  }
}
