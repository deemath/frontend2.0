import 'package:flutter/material.dart';

class BottomBar extends StatelessWidget {
  const BottomBar({super.key});

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
              Icons.home,
              size: 32,
              color: Theme.of(context).iconTheme.color,
            ),
            onPressed: () {},
          ),

          // Search
          IconButton(
            icon: Icon(Icons.search,
                size: 32, color: Theme.of(context).iconTheme.color),
            onPressed: () {
              Navigator.pushNamed(context, '/search');
            },
          ),

          // Create (e.g., Add or Post)
          IconButton(
            icon: Icon(
              Icons.add_circle_outline,
              size: 32,
              color: Theme.of(context).iconTheme.color,
            ),
            onPressed: () {
              Navigator.pushNamed(context, '/create');
            },
          ),
          // Fanbase (e.g., Group of people)
          IconButton(
            icon: Icon(Icons.groups,
                size: 32, color: Theme.of(context).iconTheme.color),
            onPressed: () {},
          ),

          // Profile
          GestureDetector(
            onTap: () {
              Navigator.pushNamed(context, '/profile');
            },
            child: Stack(
              children: [
                CircleAvatar(
                  radius: 16,
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
