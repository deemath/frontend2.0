import 'package:flutter/material.dart';
import '../../widgets/home/header_bar.dart';
import '../../widgets/common/bottom_bar.dart';
import '../../widgets/home/feed_widget.dart';
import 'package:scrollable_positioned_list/scrollable_positioned_list.dart';
import '../../../data/models/post_model.dart' as data_model;
import '../../../data/services/profile_service.dart';
import '../../../data/models/profile_model.dart';

class ProfileFeedScreen extends StatefulWidget {
  final String userId;
  final String? initialPostId; // Make this nullable

  const ProfileFeedScreen({
    Key? key,
    required this.userId,
    this.initialPostId, // Remove required keyword
  }) : super(key: key);

  @override
  State<ProfileFeedScreen> createState() => _ProfileFeedScreenState();
}

class _ProfileFeedScreenState extends State<ProfileFeedScreen> {
  List<data_model.Post> _posts = [];
  bool _isLoading = true;
  String? _error;
  int _initialIndex = 0;
  final ItemScrollController _itemScrollController = ItemScrollController();
  final ItemPositionsListener _itemPositionsListener =
      ItemPositionsListener.create();

  @override
  void initState() {
    super.initState();
    _loadProfilePosts();
  }

  Future<void> _loadProfilePosts() async {
    setState(() {
      _isLoading = true;
      _error = null;
    });
    try {
      final profileService = ProfileService();
      final postsResult = await profileService.getUserPosts(widget.userId);
      final posts = postsResult
          .map<data_model.Post>((json) => data_model.Post.fromJson(json))
          .toList();

      // Fetch username for the profile
      String? username;
      try {
        final profileResult =
            await profileService.getUserProfile(widget.userId);
        if (profileResult['success'] == true && profileResult['data'] != null) {
          final profile = ProfileModel.fromJson(profileResult['data']);
          username = profile.username;
        }
      } catch (_) {}

      // Handle the case where initialPostId might be null
      int initialIndex = 0;
      if (widget.initialPostId != null && widget.initialPostId!.isNotEmpty) {
        initialIndex = posts.indexWhere((p) => p.id == widget.initialPostId);
        if (initialIndex == -1) initialIndex = 0;
      }

      // Patch username if missing and copyWith is available
      final postsWithUsername = posts.map((post) {
        if ((post.username == null || post.username!.isEmpty) &&
            username != null) {
          return post.copyWith(username: username);
        }
        return post;
      }).toList();

      setState(() {
        _posts = postsWithUsername;
        _initialIndex = initialIndex;
        _isLoading = false;
      });

      // Scroll to the tapped post after the first frame using scrollable_positioned_list
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (_itemScrollController.isAttached && initialIndex > 0) {
          _itemScrollController.jumpTo(index: initialIndex);
        }
      });
    } catch (e) {
      setState(() {
        _error = 'Failed to load posts: $e';
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Scaffold(
        backgroundColor: Colors.black,
        body: Center(child: CircularProgressIndicator()),
      );
    }
    if (_error != null) {
      return Scaffold(
        backgroundColor: Colors.black,
        body: Center(
            child: Text(_error!, style: const TextStyle(color: Colors.white))),
      );
    }
    return Scaffold(
      appBar: NootAppBar(),
      body: FeedWidget(
        posts: _posts,
        isLoading: false,
        error: null,
        onRefresh: _loadProfilePosts,
        onLike: (_) {},
        onComment: (_) {},
        onPlay: (_) {},
        onShare: (_) {},
        currentlyPlayingTrackId: null,
        isPlaying: false,
        onUserTap: (_) {},
        // Use scrollable_positioned_list controllers
        itemScrollController: _itemScrollController,
        itemPositionsListener: _itemPositionsListener,
        initialIndex: _initialIndex,
      ),
      bottomNavigationBar: const BottomBar(),
      backgroundColor: Colors.black,
    );
  }
}
