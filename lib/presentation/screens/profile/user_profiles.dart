import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import 'dart:math';
import '../../../data/services/profile_service.dart';
import '../../../data/models/profile_model.dart';
import 'tabs/album_art_posts_tab.dart';
import 'tabs/description_posts_tab.dart';
import 'tabs/tagged_posts_tab.dart';
import 'my_profile.dart';
import 'followers_list.dart';
import 'following_list.dart';
import 'profile_feed_screen.dart';

class UserProfilePage extends StatefulWidget {
  final String userId;
  const UserProfilePage({Key? key, required this.userId}) : super(key: key);

  @override
  State<UserProfilePage> createState() => _UserProfilePageState();
}

class _UserProfilePageState extends State<UserProfilePage>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  ProfileModel? profile;
  List<dynamic> posts = [];
  List<String> albumImages = [];
  bool isLoading = true;
  String? loggedUserId;
  int postCount = 0;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    _getLoggedUserIdAndFetch();
  }

  Future<void> _getLoggedUserIdAndFetch() async {
    final prefs = await SharedPreferences.getInstance();
    final userDataString = prefs.getString('user_data');
    String? id;
    if (userDataString != null) {
      final userData = jsonDecode(userDataString);
      id = userData['id'] as String?;
    }
    setState(() {
      loggedUserId = id;
    });
    await _fetchProfileData();
  }

  Future<void> _fetchProfileData() async {
    setState(() {
      isLoading = true;
    });
    final profileService = ProfileService();
    final profileResult = await profileService.getUserProfile(widget.userId);
    final postsResult = await profileService.getUserPosts(widget.userId);
    final albumImagesResult =
        await profileService.getUserAlbumImages(widget.userId);

    // --- Fetch post count from backend ---
    final postCountResult =
        await profileService.getUserPostCount(widget.userId);
    int fetchedPostCount = 0;
    if (postCountResult != null && postCountResult['postCount'] != null) {
      fetchedPostCount = postCountResult['postCount'];
    }

    if (profileResult['success'] == true && profileResult['data'] != null) {
      setState(() {
        profile = ProfileModel.fromJson(profileResult['data']);
        posts = postsResult;
        albumImages = albumImagesResult;
        postCount = fetchedPostCount;
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

    // If viewing own profile, redirect to my profile page
    if (loggedUserId != null && widget.userId == loggedUserId) {
      // Use Future.microtask to avoid build context issues
      Future.microtask(() {
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (_) => const NormalUserProfilePage()),
        );
      });
      return const SizedBox.shrink();
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
          AlbumArtPostsTab(
            username: profile!.username,
            fullName: profile!.fullName,
            posts: postCount,
            followers: profile!.followers.length,
            following: profile!.following.length,
            albumImages: albumImages,
            description: profile!.bio,
            showGrid: false,
            profileImage: profile!.profileImage,
            postsList: posts,
            onFollowersTap: () async {
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
            },
            onFollowingTap: () async {
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
            },
            onPostTap: (postId) {
              final String? id = postId?.toString();
              if (id != null && id.isNotEmpty) {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ProfileFeedScreen(
                      userId: profile!.userId,
                      initialPostId: id,
                    ),
                  ),
                );
              }
            },
          ),
          // Add Follow and Message buttons for other users
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                OutlinedButton(
                  onPressed: () {
                    // TODO: Implement follow functionality
                  },
                  style: OutlinedButton.styleFrom(
                    side: const BorderSide(color: Colors.white),
                  ),
                  child: const Text(
                    'Following',
                    style: TextStyle(color: Colors.white),
                  ),
                ),
                const SizedBox(width: 16),
                OutlinedButton(
                  onPressed: () {
                    // TODO: Implement message functionality
                  },
                  style: OutlinedButton.styleFrom(
                    side: const BorderSide(color: Colors.white),
                  ),
                  child: const Text(
                    'Message',
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ],
            ),
          ),
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
          Expanded(
            child: TabBarView(
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
                  onPostTap: (postId) {
                    final String? id = postId?.toString();
                    if (id != null && id.isNotEmpty) {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => ProfileFeedScreen(
                            userId: profile!.userId,
                            initialPostId: id,
                          ),
                        ),
                      );
                    }
                  },
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
