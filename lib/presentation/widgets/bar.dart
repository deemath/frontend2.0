import 'package:flutter/material.dart';
import '../widgets/toggle_button.dart';

class NootAppBar extends StatelessWidget implements PreferredSizeWidget {
  @override
  Size get preferredSize => Size.fromHeight(60);

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return AppBar(
      backgroundColor: Theme.of(context).colorScheme.primary,
      elevation: 0,
      titleSpacing: 0,
      title: Row(
        children: [
          // App Icon and Name
          Padding(
            padding: const EdgeInsets.only(left: 16.0, right: 8.0),
            child: Row(
              children: [
                Image.asset(
                  isDark ? 'assets/images/logo_white.png' :'assets/images/logo_black.png',
                  width: 100,
                  height: 40,
                ),
              ],
            ),
          ),
          Spacer(),
          // temparary toggle button
          ToggleButton(),
          SizedBox(width: 10),
          // Heart Icon
          IconButton(
            icon: Icon(Icons.favorite_border, color: Theme.of(context).colorScheme.onPrimary, size: 32),
            onPressed: () {},
          ),
          // Message Icon
          IconButton(
            icon: Icon(Icons.chat, color: Theme.of(context).colorScheme.onPrimary, size: 28),
            onPressed: () {},
          ),
          SizedBox(width: 10),
        ],
      ),
    );
  }
}
