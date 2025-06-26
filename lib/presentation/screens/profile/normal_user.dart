import 'dart:math';
import 'package:flutter/material.dart';

class NormalUserProfilePage extends StatefulWidget {
  const NormalUserProfilePage({Key? key}) : super(key: key);

  @override
  State<NormalUserProfilePage> createState() => _NormalUserProfilePageState();
}

class _NormalUserProfilePageState extends State<NormalUserProfilePage> {
  final String profileImage =
      'https://i.scdn.co/image/ab6761610000e5eb02e3c8b0e6e6e6e6e6e6e6e6';
  final String username = 'spotify_user';
  final int posts = 12;
  final int followers = 1200;
  final int following = 180;

  final List<String> albumArts = [
    'https://i.scdn.co/image/ab67616d0000b273e0e0e0e0e0e0e0e0e0e0e0e0',
    'https://i.scdn.co/image/ab67616d0000b273f1f1f1f1f1f1f1f1f1f1f1f1',
    'https://i.scdn.co/image/ab67616d0000b273a2a2a2a2a2a2a2a2a2a2a2a2',
    'https://i.scdn.co/image/ab67616d0000b273b3b3b3b3b3b3b3b3b3b3b3b3',
    'https://i.scdn.co/image/ab67616d0000b273c4c4c4c4c4c4c4c4c4c4c4c4',
    'https://i.scdn.co/image/ab67616d0000b273d5d5d5d5d5d5d5d5d5d5d5d5',
    'https://i.scdn.co/image/ab67616d0000b273e6e6e6e6e6e6e6e6e6e6e6e6',
    'https://i.scdn.co/image/ab67616d0000b273f7f7f7f7f7f7f7f7f7f7f7f7',
    'https://i.scdn.co/image/ab67616d0000b2731234567890abcdef12345678',
    'https://i.scdn.co/image/ab67616d0000b273abcdefabcdefabcdefabcdefab',
    'https://i.scdn.co/image/ab67616d0000b273111111111111111111111111',
    'https://i.scdn.co/image/ab67616d0000b273222222222222222222222222',
  ];

  final List<String> randomDescriptions = [
    "Music is my escape 🎶",
    "Living life one song at a time.",
    "Album art collector & playlist curator.",
    "Lost in the rhythm.",
    "Streaming good vibes only.",
    "Turn up the volume!",
    "Soundtrack of my life.",
    "Discovering new beats daily.",
    "Let the music speak.",
    "Chasing melodies.",
  ];

  String getRandomDescription() {
    final random = Random();
    return randomDescriptions[random.nextInt(randomDescriptions.length)];
  }

  @override
  Widget build(BuildContext context) {
    final description = getRandomDescription();
    return Scaffold(
      appBar: AppBar(
        title: Text(username),
        centerTitle: true,
        backgroundColor: Colors.black,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Profile header
            Padding(
              padding:
                  const EdgeInsets.symmetric(vertical: 24.0, horizontal: 16.0),
              child: Row(
                children: [
                  CircleAvatar(
                    radius: 44,
                    backgroundImage: NetworkImage(profileImage),
                  ),
                  Expanded(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        _buildStatColumn('Posts', posts),
                        _buildStatColumn('Followers', followers),
                        _buildStatColumn('Following', following),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            // Username and description
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      username,
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                    ),
                    SizedBox(height: 6),
                    Text(
                      description,
                      style: TextStyle(fontSize: 15),
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(height: 16),
            // Posts grid
            GridView.builder(
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(),
              itemCount: albumArts.length,
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3,
                mainAxisSpacing: 2,
                crossAxisSpacing: 2,
                childAspectRatio: 1,
              ),
              itemBuilder: (context, index) {
                return Image.network(
                  albumArts[index],
                  fit: BoxFit.cover,
                );
              },
            ),
          ],
        ),
      ),
      backgroundColor: Colors.black,
    );
  }

  Widget _buildStatColumn(String label, int count) {
    return Column(
      children: [
        Text(
          count.toString(),
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 18,
            color: Colors.white,
          ),
        ),
        SizedBox(height: 4),
        Text(
          label,
          style: TextStyle(
            fontSize: 14,
            color: Colors.grey[400],
          ),
        ),
      ],
    );
  }
}
