import 'dart:math';
import 'package:flutter/material.dart';
import 'tabs/album_art_posts_tab.dart';
import 'tabs/description_posts_tab.dart';
import 'tabs/tagged_posts_tab.dart';
import 'settings/edit_profile.dart';
import '../../../data/services/profile_service.dart';
import '../../../data/models/profile_model.dart';

class NormalUserProfilePage extends StatefulWidget {
  static const routeName = '/profile/normal';

  const NormalUserProfilePage({Key? key}) : super(key: key);

  @override
  State<NormalUserProfilePage> createState() => _NormalUserProfilePageState();
}

class _NormalUserProfilePageState extends State<NormalUserProfilePage>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  // Replace with actual userId from auth/session
  final String userId = '685fb750cc084ba7e0ef8533';

  ProfileModel? profile;
  List<dynamic> posts = [];
  // This will hold the list of albumImage URLs from the user's posts
  List<String> albumImages = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    _fetchProfileData();
  }

  Future<void> _fetchProfileData() async {
    setState(() {
      isLoading = true;
    });
    final profileService = ProfileService();
    final profileResult = await profileService.getUserProfile(userId);
    final postsResult = await profileService.getUserPosts(userId);
    // Get albumImage URLs from backend posts
    final albumImagesResult = await profileService.getUserAlbumImages(userId);

    if (profileResult['success'] == true && profileResult['data'] != null) {
      setState(() {
        profile = ProfileModel.fromJson(profileResult['data']);
        posts = postsResult;
        albumImages = albumImagesResult;
        isLoading = false;
      });
    } else {
      setState(() {
        isLoading = false;
      });
      // Optionally show error
    }
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return const Scaffold(
        backgroundColor: Colors.black,
        body: Center(child: CircularProgressIndicator()),
      );
    }

    if (profile == null) {
      return const Scaffold(
        backgroundColor: Colors.black,
        body: Center(
            child: Text('Failed to load profile',
                style: TextStyle(color: Colors.white))),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(profile!.username),
        centerTitle: true,
        backgroundColor: Colors.black,
      ),
      body: Column(
        children: [
          // Profile details (header, stats, description)
          AlbumArtPostsTab(
            username: profile!.username,
            posts: profile!.posts,
            followers: profile!.followers,
            following: profile!.following,
            // Pass albumImages (from albumImage fields in posts)
            albumImages: albumImages,
            description: profile!.bio,
            showGrid: false,
            profileImage: profile!.profileImage,
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
                  username: profile!.username,
                  posts: profile!.posts,
                  followers: profile!.followers,
                  following: profile!.following,
                  // Pass albumImages (from albumImage fields in posts)
                  albumImages: albumImages,
                  description: profile!.bio,
                  showGrid: true,
                  profileImage: profile!.profileImage,
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
