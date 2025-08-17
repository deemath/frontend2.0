import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../core/providers/theme_provider.dart';

enum SnackBarType {
  destructive,
  success,
  primary,
  secondary,
  accent,
}

class CustomSnackBar extends StatelessWidget {
  final String title;
  final String text;
  final SnackBarType type;

  const CustomSnackBar({
    Key? key,
    required this.title,
    required this.text,
    required this.type,
  }) : super(key: key);

  Color _getBorderColor(SnackBarType type) {
    switch (type) {
      case SnackBarType.destructive:
        return Colors.red;
      case SnackBarType.success:
        return Colors.green;
      case SnackBarType.primary:
        return Colors.black;
      case SnackBarType.secondary:
        return Colors.white;
      case SnackBarType.accent:
        return Colors.purple;
    }
  }

  Color _getBackgroundColor(ThemeMode themeMode) {
    switch (themeMode) {
      case ThemeMode.dark:
        return const Color(0xFF212121);
      case ThemeMode.light:
        return Colors.white;
      case ThemeMode.system:
        // Default to dark theme background
        return const Color(0xFF212121);
    }
  }

  Color _getTextColor(ThemeMode themeMode) {
    switch (themeMode) {
      case ThemeMode.dark:
        return Colors.white;
      case ThemeMode.light:
        return Colors.black;
      case ThemeMode.system:
        // Default to dark theme text color
        return Colors.white;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<ThemeProvider>(
      builder: (context, themeProvider, child) {
        final themeMode = themeProvider.themeMode;
        final borderColor = _getBorderColor(type);
        final backgroundColor = _getBackgroundColor(themeMode);
        final textColor = _getTextColor(themeMode);

        return Container(
          margin: const EdgeInsets.all(5.0),
          decoration: BoxDecoration(
            color: backgroundColor,
            border: Border.all(color: borderColor, width: 2.0),
            borderRadius: BorderRadius.circular(20.0),
          ),
          child: Padding(
            padding:
                const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    color: textColor,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  text,
                  style: TextStyle(
                    color: textColor,
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  // Static helper method to show the custom snack bar
  static void show(
    BuildContext context, {
    required String title,
    required String text,
    required SnackBarType type,
    Duration duration = const Duration(seconds: 3),
  }) {
    final snackBar = SnackBar(
      content: CustomSnackBar(title: title, text: text, type: type),
      backgroundColor: Colors.transparent,
      elevation: 0,
      duration: duration,
      behavior: SnackBarBehavior.floating,
      margin: EdgeInsets.zero,
    );

    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }
}
