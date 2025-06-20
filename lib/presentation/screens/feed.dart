import 'package:flutter/material.dart';

class FeedPage extends StatelessWidget {
  const FeedPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Top bar with profile, username, location, and menu
          Padding(
            padding: const EdgeInsets.only(top: 0, left: 12, right: 12, bottom: 8),
            child: Row(
              children: [
                // Profile image
                CircleAvatar(
                  radius: 25,
                  backgroundImage: AssetImage('assets/images/hehe.png'), 
                ),
                SizedBox(width: 10),
                // Username and song
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'ishaanKhatter',
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                    Text(
                      'august - Taylor Swift', 
                      style: TextStyle(
                        color: Colors.white70,
                        fontSize: 13,
                      ),
                    ),
                  ],
                )
              ],
            ),
          ),
          // Post image
          Container(
            width: double.infinity,
            height: 500, 
            decoration: BoxDecoration(
              color: Colors.grey[900],
            ),
            child: Image.asset(
              'assets/images/song.png', 
              fit: BoxFit.cover,
            ),
          ),
          // Action icons row
          Padding(
            padding: const EdgeInsets.only(left: 12, top: 12),
            child: Row(
              children: [
                Icon(Icons.favorite_border, color: Colors.white, size: 32),
                SizedBox(width: 4),
                
                Icon(Icons.mode_comment_outlined, color: Colors.white, size: 32),
                SizedBox(width: 4),
                Icon(Icons.share, color: Colors.white, size: 32),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
