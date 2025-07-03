import 'package:flutter/material.dart';

class SegmentDivider extends StatelessWidget {
  final List<String> segments;
  final int selectedIndex;
  final ValueChanged<int> onSegmentSelected;

  const SegmentDivider({
    Key? key,
    required this.segments,
    required this.selectedIndex,
    required this.onSegmentSelected,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final backgroundColor =
        isDark ? theme.colorScheme.surface : Colors.grey[100];
    final unselectedTextColor = isDark ? Colors.white70 : Colors.black87;

    return Container(
      color: backgroundColor,
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: List.generate(segments.length, (index) {
          final isSelected = index == selectedIndex;
          return GestureDetector(
            onTap: () => onSegmentSelected(index),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              // No background color change for selected
              child: Text(
                segments[index],
                style: TextStyle(
                  color: unselectedTextColor,
                  fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                ),
              ),
            ),
          );
        }),
      ),
    );
  }
}
