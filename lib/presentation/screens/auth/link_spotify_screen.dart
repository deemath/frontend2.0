import 'package:flutter/material.dart';

class LinkSpotifyScreen extends StatelessWidget {
  const LinkSpotifyScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Background image
          SizedBox.expand(
            child: Image.asset(
              'assets/backgrounds/black-and-green-background.jpg',
              fit: BoxFit.cover,
            ),
          ),
          // 50% opacity black overlay
          Container(
            color: Colors.black.withOpacity(0.8),
          ),
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 60),
            decoration: BoxDecoration(
              color: Colors.black.withOpacity(0.9),
              borderRadius: BorderRadius.circular(40),
            ),
          ),
          // Existing widget content
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'Link your Spotify account',
                  style: const TextStyle(color: Colors.white),
                ),
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () {
                    // Logic to link Spotify account goes here
                  },
                  child: const Text('Link Spotify'),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
