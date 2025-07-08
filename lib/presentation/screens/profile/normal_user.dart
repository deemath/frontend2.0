import 'dart:math';
import 'package:flutter/material.dart';
// import '../../widgets/profile/profile_stat_column.dart';
import 'tabs/album_art_posts_tab.dart';
import 'tabs/description_posts_tab.dart';
import 'tabs/tagged_posts_tab.dart';
import 'settings/edit_profile.dart'; // <-- Add this import

class NormalUserProfilePage extends StatefulWidget {
  static const routeName = '/profile/normal';

  const NormalUserProfilePage({Key? key}) : super(key: key);

  @override
  State<NormalUserProfilePage> createState() => _NormalUserProfilePageState();
}

class _NormalUserProfilePageState extends State<NormalUserProfilePage>
    with SingleTickerProviderStateMixin {
  final String profileImage =
      'https://i.scdn.co/image/ab6761610000e5eb02e3c8b0e6e6e6e6e6e6e6e6';
  final String username = 'spotify_user';
  final int posts = 12;
  final int followers = 1200;
  final int following = 180;

  final List<String> albumArts = [
    'https://i.scdn.co/image/ab67616d0000b27313b3e37318a0c247b550bccd',
    'https://i.scdn.co/image/ab67616d0000b2734e0362c225863f6ae2432651',
    'https://i.scdn.co/image/ab67616d0000b273dcef905cb144d4867119850b',
    'https://i.scdn.co/image/ab67616d0000b27383141000ee8ce3b893a0b425',
    'https://i.scdn.co/image/ab67616d0000b273ccdddd46119a4ff53eaf1f5d',
    'https://i.scdn.co/image/ab67616d0000b273726d48d93d02e1271774f023',
    'https://i.scdn.co/image/ab67616d0000b27364fa1bda999f4fbd2b7c4bb7',
    'https://i.scdn.co/image/ab67616d0000b273062c6573009fdebd43de443b',
    'https://i.scdn.co/image/ab67616d0000b273a0cb974834e04f46b63b99a8',
    'https://i.scdn.co/image/ab67616d0000b2736ff8bc258e3ebc835ffe14ca',
    'https://i.scdn.co/image/ab67616d0000b273712701c5e263efc8726b1464',
    'https://i.scdn.co/image/ab67616d0000b273f02c451189a709b9a952aaec',
    'https://i.scdn.co/image/ab67616d0000b2737fcead687e99583072cc217b',
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
    "In a world of my own with music.",
  ];

  late TabController _tabController;

  String getRandomDescription() {
    final random = Random();
    return randomDescriptions[random.nextInt(randomDescriptions.length)];
  }

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
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
      body: Column(
        children: [
          // Profile details (header, stats, description)
          AlbumArtPostsTab(
            username: username,
            posts: posts,
            followers: followers,
            following: following,
            albumArts: albumArts,
            description: description,
            showGrid: false, // Only show profile details, not grid
          ),
          // --- Add Edit Profile Button ---
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 8.0),
            child: SizedBox(
              width: 160,
              child: OutlinedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const EditProfilePage()),
                  );
                },
                style: OutlinedButton.styleFrom(
                  side: const BorderSide(color: Colors.white),
                ),
                child: const Text(
                  'Edit Profile',
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ),
          ),
          // TabBar under profile details
          Container(
            color: Colors.black,
            child: TabBar(
              controller: _tabController,
              indicatorColor: Colors.white,
              tabs: const [
                Tab(icon: Icon(Icons.grid_on)),
                Tab(icon: Icon(Icons.description)),
                Tab(icon: Icon(Icons.person_pin)),
              ],
            ),
          ),
          // TabBarView for posts
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [
                AlbumArtPostsTab(
                  username: username,
                  posts: posts,
                  followers: followers,
                  following: following,
                  albumArts: albumArts,
                  description: description,
                  showGrid: true, // Only show grid
                ),
                const DescriptionPostsTab(),
                const TaggedPostsTab(),
              ],
            ),
          ),
        ],
      ),
      backgroundColor: Colors.black,
    );
  }
}
