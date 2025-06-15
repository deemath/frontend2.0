import 'package:flutter/material.dart';

class PlayingBar extends StatelessWidget {
  const PlayingBar({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Spotify icon
          Image.asset(
            'assets/images/spotify.png',
            width: 24,
            height: 24,
          ),
          SizedBox(width: 32),
          Icon(Icons.skip_previous, size: 30, color: Colors.grey),
          SizedBox(width: 32),
          Icon(Icons.pause, size: 30, color: Colors.grey),
          SizedBox(width: 32),
          Icon(Icons.skip_next, size: 30, color: Colors.grey),
          SizedBox(width: 32),
          Icon(Icons.volume_up, size: 30, color: Colors.grey),
        ],
      ),
    );
  }
}
