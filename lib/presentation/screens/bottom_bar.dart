import 'package:flutter/material.dart';

class BottomBar extends StatelessWidget {
  const BottomBar({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.black,
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          // Home
          Image.asset('assets/images/home.png', width: 25, height: 25, color: Colors.white),
          // Search
          Image.asset('assets/images/search.png', width: 25, height: 25, color: Colors.white),
          // Create
          Image.asset('assets/images/create.png', width: 25, height: 25, color: Colors.white),
          // Fanbase
          Image.asset('assets/images/fanbase.png', width: 35, height: 35, color: Colors.white),
          // Profile with red dot
          Stack(
            children: [
              CircleAvatar(
                radius: 16,
                backgroundImage: AssetImage('assets/images/me.png'), 
              ),
              Positioned(
                right: 2,
                bottom: 2,
                child: Container(
                  width: 8,
                  height: 8,
                  decoration: BoxDecoration(
                    color: Colors.red,
                    shape: BoxShape.circle,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}