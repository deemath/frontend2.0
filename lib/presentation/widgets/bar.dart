import 'package:flutter/material.dart';
// import 'package:flutter_svg/flutter_svg.dart';

class NootAppBar extends StatelessWidget implements PreferredSizeWidget {
  @override
  Size get preferredSize => Size.fromHeight(60);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: Colors.black,
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
                  'assets/images/logo.png',
                  width: 100,
                  height: 40,
                ),
              ],
            ),
          ),
          Spacer(),
          // Heart Icon
          IconButton(
            icon: Icon(Icons.favorite_border, color: Colors.white, size: 32),
            onPressed: () {},
          ),
          // Message Icon
          IconButton(
            icon: Icon(Icons.chat, color: Theme.of(context).appBarTheme.iconTheme?.color, size: 28),
            onPressed: () {},
          ),
          SizedBox(width: 10),
        ],
      ),
    );
  }
}
