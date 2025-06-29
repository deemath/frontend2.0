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
          const SizedBox(width: 30),
          IconButton(
            icon: Icon(Icons.skip_previous, size: 30, color: Theme.of(context).colorScheme.secondary),
            onPressed: () {},
          ),
          const SizedBox(width: 30),
          IconButton(
            icon: Icon(Icons.pause, size: 30, color: Theme.of(context).colorScheme.secondary),
            onPressed: () {},
          ),
          const SizedBox(width: 30),
          IconButton(
            icon: Icon(Icons.skip_next, size: 30, color: Theme.of(context).colorScheme.secondary),
            onPressed: () {},
          ),
          const SizedBox(width: 30),
          IconButton(
            icon: Icon(Icons.volume_up, size: 30, color: Theme.of(context).colorScheme.secondary),
            onPressed: () {},
          ),
        ],
      ),
    );
  }
}
