import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/providers/theme_provider.dart'; // Ensure this path is correct

class ToggleButton extends StatelessWidget {
  const ToggleButton({super.key});

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);

    return IconButton(
      icon: Icon(
        themeProvider.themeMode == ThemeMode.dark
            ? Icons.dark_mode
            : Icons.light_mode,
      ),
      onPressed: () {
        themeProvider.toggleTheme();
      },
      color: Theme.of(context).colorScheme.onPrimary,
      iconSize: 30,
      tooltip: 'Toggle Theme',
    );
  }
}
