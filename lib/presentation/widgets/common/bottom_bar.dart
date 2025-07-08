import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';

class BottomBar extends StatelessWidget {
  /// The currently selected index for highlighting the active tab
  final int currentIndex;

  /// Callback when a tab is tapped
  final Function(int)? onTap;

  const BottomBar({
    super.key,
    this.currentIndex = 0,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Theme.of(context).colorScheme.primary,
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          // Home
          IconButton(
            icon: Icon(
              LucideIcons.home,
              size: 22,
              color: currentIndex == 0
                  ? Theme.of(context).colorScheme.secondary
                  : Theme.of(context).iconTheme.color,
            ),
            onPressed: () {
              if (onTap != null) {
                onTap!(0);
              } else {
                // Legacy support - will be removed when shell is fully implemented
                Navigator.pushNamed(context, '/home');
              }
            },
          ),

          // Search
          IconButton(
            icon: Icon(
              LucideIcons.search,
              size: 22,
              color: currentIndex == 1
                  ? Theme.of(context).colorScheme.secondary
                  : Theme.of(context).iconTheme.color,
            ),
            onPressed: () {
              if (onTap != null) {
                onTap!(1);
              } else {
                // Legacy support
                Navigator.pushNamed(context, '/search');
              }
            },
          ),

          // Create (e.g., Add or Post)
          IconButton(
            icon: Icon(
              LucideIcons.plusCircle,
              size: 22,
              color: currentIndex == 2
                  ? Theme.of(context).colorScheme.secondary
                  : Theme.of(context).iconTheme.color,
            ),
            onPressed: () {
              if (onTap != null) {
                onTap!(2);
              } else {
                // Legacy support
                Navigator.pushNamed(context, '/create');
              }
            },
          ),
          // Fanbase (e.g., Group of people)
          IconButton(
            icon: Icon(
              LucideIcons.users,
              size: 22,
              color: currentIndex == 3
                  ? Theme.of(context).colorScheme.secondary
                  : Theme.of(context).iconTheme.color,
            ),
            onPressed: () {
              if (onTap != null) {
                onTap!(3);
              } else {
                // Legacy support
                Navigator.pushNamed(context, '/fanbases');
              }
            },
          ),

          // Profile
          GestureDetector(
            onTap: () {
              if (onTap != null) {
                onTap!(4);
              } else {
                // Legacy support
                Navigator.pushNamed(context, '/profile');
              }
            },
            child: Stack(
              children: [
                CircleAvatar(
                  radius: 14,
                  backgroundImage: AssetImage('assets/images/hehe.png'),
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}
