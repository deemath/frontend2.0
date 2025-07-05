import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';

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
              LucideIcons.home,
              size: 22,
              color: Theme.of(context).iconTheme.color,
            ),
            onPressed: () {},
          ),

          // Search
          IconButton(
            icon: Icon(LucideIcons.search,
              size: 22, color: Theme.of(context).iconTheme.color),
            onPressed: () {
              Navigator.pushNamed(context, '/search');
            },
          ),

          // Create (e.g., Add or Post)
          IconButton(
            icon: Icon(
              LucideIcons.plusCircle,
              size: 22,
              color: Theme.of(context).iconTheme.color,
            ),
            onPressed: () {
              Navigator.pushNamed(context, '/create');
            },
          ),
          // Fanbase (e.g., Group of people)
          IconButton( 
            icon: Icon(
              LucideIcons.users, 
              size: 22, 
              color: Theme.of(context).iconTheme.color),
            onPressed: (){
              Navigator.pushNamed(context, '/fanbases');
            },
          ),

          // Profile
          GestureDetector(
            onTap: () {
              Navigator.pushNamed(context, '/profile');
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
