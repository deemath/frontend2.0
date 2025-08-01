import 'dart:math';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import 'tabs/album_art_posts_tab.dart';
import 'tabs/description_posts_tab.dart';
import 'tabs/tagged_posts_tab.dart';
import 'settings/edit_profile.dart';

import 'settings/create_profile.dart';
import './settings/options.dart';
import 'followers_list.dart';
import 'following_list.dart';
import 'profile_feed_screen.dart';

import '../../../data/services/profile_service.dart';
import '../../../data/models/profile_model.dart';
import '../../../core/providers/auth_provider.dart';
import '../../../data/models/post_model.dart';
import '../../widgets/common/bottom_bar.dart';

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

  bool profileNotFound = false;
  int postCount = 0;

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
    // Convert each map to a Post object
    final postObjects = postsResult.map((json) => Post.fromJson(json)).toList();
    final albumImagesResult = await profileService.getUserAlbumImages(userId!);

    // --- Fetch post count from backend ---
    final postCountResult = await profileService.getUserPostCount(userId!);
    int fetchedPostCount = 0;
    if (postCountResult != null && postCountResult['postCount'] != null) {
      fetchedPostCount = postCountResult['postCount'];
    }

    if (profileResult['success'] == true && profileResult['data'] != null) {
      setState(() {
        profile = ProfileModel.fromJson(profileResult['data']);
        posts = postObjects;
        albumImages = albumImagesResult;
        postCount = fetchedPostCount;

        profileNotFound = false;
        isLoading = false;
      });
    } else if (profileResult['message'] == 'Profile not found') {
      setState(() {
        profile = null;
        profileNotFound = true;

        isLoading = false;
      });
    } else {
      setState(() {
        profile = null;
        profileNotFound = false;

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

    if (profile == null && profileNotFound) {
      return Scaffold(
        appBar: AppBar(
          title: const Text('Profile'),
          centerTitle: true,
          backgroundColor: Colors.black,
        ),
        backgroundColor: Colors.black,
        body: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Padding(
                padding: EdgeInsets.symmetric(vertical: 32.0),
                child: Text(
                  'No profile found for this user.',
                  style: TextStyle(color: Colors.white, fontSize: 18),
                ),
              ),
              SizedBox(
                width: 160,
                child: OutlinedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const CreateProfilePage()),
                    );
                  },
                  style: OutlinedButton.styleFrom(
                    side: const BorderSide(color: Colors.white),
                  ),
                  child: const Text(
                    'Create Profile',
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ),
            ],
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
        // Remove leading, add actions for right top
        title: Text(profile?.username ?? 'Profile'),
        centerTitle: true,
        backgroundColor: Colors.black,
        actions: [
          IconButton(
            icon: const Icon(Icons.menu),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const OptionsPage(),
                ),
              );
            },
          ),
        ],
      ),
      body: Column(
        children: [
          // Profile details (header, stats, description)
          AlbumArtPostsTab(
            username: profile?.username ?? '',
            fullName: profile?.fullName ?? '',
            posts: postCount,
            followers: profile?.followers.length ?? 0,
            following: profile?.following.length ?? 0,
            albumImages: albumImages,
            description: profile?.bio ?? '',
            showGrid: false,
            profileImage: profile?.profileImage ?? '',
            postsList: posts,

            // --- Add gesture detectors for followers/following ---
            onFollowersTap: () async {
              if (profile != null) {
                final profileService = ProfileService();
                final followersList = await profileService
                    .getFollowersListWithDetails(profile!.userId);
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => FollowersListPage(
                      followers: followersList,
                    ),
                  ),
                );
              }
            },
            onFollowingTap: () async {
              if (profile != null) {
                final profileService = ProfileService();
                final followingList = await profileService
                    .getFollowingListWithDetails(profile!.userId);
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => FollowingListPage(
                      following: followingList,
                    ),
                  ),
                );
              }
            },
            // Make posts clickable
            onPostTap: (postId) {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => ProfileFeedScreen(
                    userId: userId!,
                    initialPostId: postId,
                  ),
                ),
              );
            },
          ),
          // --- Add Edit Profile Button ---
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 8.0),
            child: SizedBox(
              width: 160,
              child: OutlinedButton(
                onPressed: () async {
                  final result = await Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const EditProfilePage()),
                  );
                  if (result == true) {
                    // Only fetch if profile was updated
                    await _fetchProfileData();
                  }
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
            child: profile != null
                ? TabBarView(
                    controller: _tabController,
                    children: [
                      AlbumArtPostsTab(
                        username: profile!.username,
                        fullName: profile!.fullName,
                        posts: postCount,
                        followers: profile!.followers.length,
                        following: profile!.following.length,
                        albumImages: albumImages,
                        description: profile!.bio,
                        showGrid: true,
                        profileImage: profile!.profileImage,
                        postsList: posts,
                        // Make posts clickable in grid tab as well
                        onPostTap: (postId) {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => ProfileFeedScreen(
                                userId: userId!,
                                initialPostId: postId,
                              ),
                            ),
                          );
                        },
                      ),
                      const DescriptionPostsTab(),
                      const TaggedPostsTab(),
                    ],
                  )
                : const Center(
                    child: Text(
                      'No profile data available.',
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
          ),
        ],
      ),
      backgroundColor: Colors.black,
      bottomNavigationBar: const BottomBar(),
    );
  }
}
