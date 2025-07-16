import 'dart:math';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import 'tabs/album_art_posts_tab.dart';
import 'tabs/description_posts_tab.dart';
import 'tabs/tagged_posts_tab.dart';
import 'settings/edit_profile.dart';
import '../../../data/services/profile_service.dart';
import '../../../data/models/profile_model.dart';
import '../../../core/providers/auth_provider.dart';

class NormalUserProfilePage extends StatefulWidget {
  static const routeName = '/profile/normal';

  const NormalUserProfilePage({Key? key}) : super(key: key);

  @override
  State<NormalUserProfilePage> createState() => _NormalUserProfilePageState();
}

class _NormalUserProfilePageState extends State<NormalUserProfilePage>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  String? userId;
  ProfileModel? profile;
  List<dynamic> posts = [];
  List<String> albumImages = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    WidgetsBinding.instance.addPostFrameCallback((_) => _initUserIdAndFetch());
  }

  Future<void> _initUserIdAndFetch() async {
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    String? id = authProvider.user?.id;
    if (id == null) {
      // Try loading from SharedPreferences
      final prefs = await SharedPreferences.getInstance();
      final userDataString = prefs.getString('user_data');
      if (userDataString != null) {
        final userData = jsonDecode(userDataString);
        id = userData['id'] as String?;
      }
    }
    setState(() {
      userId = id;
    });
    _fetchProfileData();
  }

  Future<void> _fetchProfileData() async {
    if (userId == null) {
      setState(() {
        isLoading = false;
      });
      return;
    }
    setState(() {
      isLoading = true;
    });
    final profileService = ProfileService();
    final profileResult = await profileService.getUserProfile(userId!);
    final postsResult = await profileService.getUserPosts(userId!);
    final albumImagesResult = await profileService.getUserAlbumImages(userId!);

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

    if (userId == null) {
      return const Scaffold(
        backgroundColor: Colors.black,
        body: Center(
          child: Text(
            'User not found. Please log in again.',
            style: TextStyle(color: Colors.white),
          ),
        ),
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
