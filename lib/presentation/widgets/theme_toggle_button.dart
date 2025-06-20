import 'package:flutter/material.dart';

class ThemeToggleButton extends StatelessWidget {
  final VoidCallback onToggle;

  const ThemeToggleButton({Key? key, required this.onToggle}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: const Icon(Icons.brightness_6),
      onPressed: onToggle,
      tooltip: 'Toggle Theme',
    );
  }
}