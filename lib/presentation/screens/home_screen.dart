import 'package:flutter/material.dart';
import '../widgets/home/header_bar.dart';
import '/presentation/widgets/common/bottom_bar.dart';
import '../widgets/home/feed_widget.dart';
import '../../data/models/post_model.dart' as data_model;
import '../../data/models/feed_item.dart';
import '../../data/models/thoughts_model.dart';
import '../../data/services/thoughts_service.dart';
import '../widgets/thoughts/thoughts_feed_card.dart';
import '../../data/services/song_post_service.dart';
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:provider/provider.dart';
import '../../data/services/auth_service.dart';
import 'package:dio/dio.dart';
import '../widgets/song_post/comment.dart';
import 'package:share_plus/share_plus.dart';
import './profile/user_profiles.dart';
import '../widgets/song_post/post_options_menu.dart';

class HomeScreen extends StatefulWidget {
  final String? accessToken;

  /// Whether this screen is being displayed inside the ShellScreen.
  /// When true, navigation elements (app bar, bottom bar, music player) are not shown
  /// as they are already provided by the ShellScreen.
  final bool inShell;

  const HomeScreen({Key? key, this.accessToken, this.inShell = false})
      : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final SongPostService _songPostService = SongPostService();
  final ThoughtsService _thoughtsService = ThoughtsService();

  List<FeedItem> _feedItems = [];
  bool _isLoading = true;
  String? _error;
  String? _currentlyPlayingTrackId;
  bool _isPlaying = false;
  String? userId;

  @override
  void initState() {
    super.initState();
    _loadUserIdAndPosts();
  }

  Future<void> _loadUserIdAndPosts() async {
    final prefs = await SharedPreferences.getInstance();
    final userDataString = prefs.getString('user_data');
    final userData = userDataString != null
        ? jsonDecode(userDataString)
        : {'id': '685fb750cc084ba7e0ef8533'}; // Fallback for testing
    setState(() {
      userId = userData['id'];
    });
    await _loadPosts();
  }

  // Refresh posts after creating a new post
  Future<void> refreshPostsAfterCreation() async {
    print('Refreshing posts after new post creation...');
    await _loadPosts();
  }

  // Load posts from the backend
  Future<void> _loadPosts() async {
    try {
      setState(() {
        _isLoading = true;
        _error = null;
      });

      if (userId == null) {
        setState(() {
          _error = 'User ID not found. Please log in again.';
          _isLoading = false;
        });
        return;
      }

      final songResult = await _songPostService.getFollowerPosts(userId!);
      final thoughtsResult = await _thoughtsService.getFollowerThoughts(userId!);
      //print('Fetched thoughtsResult: ' + thoughtsResult.toString());

      List<FeedItem> feedItems = [];

      if (songResult['success']) {
        final List<dynamic> postsData = songResult['data'];
        final posts = postsData.map((json) {
          final post = data_model.Post.fromJson(json);
          post.likedByMe =
              (json['likedBy'] as List<dynamic>?)?.contains(userId) ?? false;
          return FeedItem.song(post);
        });
        feedItems.addAll(posts);
      }

      if (thoughtsResult['success']) {
        final List<dynamic> thoughtsData = thoughtsResult['data'];
        //print('Parsed thoughtsData: ' + thoughtsData.toString());
        final thoughtsPosts = thoughtsData.map((json) {
          final post = ThoughtsPost.fromJson(json);
          //print('Parsed ThoughtsPost: ' + post.toString());
          return FeedItem.thought(post);
        });
        feedItems.addAll(thoughtsPosts);
      }


      // Sort all by createdAt, newest first
      feedItems.sort((a, b) => b.createdAt.compareTo(a.createdAt));

      setState(() {
        _feedItems = feedItems;
        _isLoading = false;
      });
    } catch (e) {
      print('Error in _loadPosts: $e');
      setState(() {
        _error = 'Error loading posts: $e';
        _isLoading = false;
      });
    }
  }

  void _handleLike(data_model.Post post) async {
    String? currentUserId = userId;
    if (currentUserId == null) {
      final prefs = await SharedPreferences.getInstance();
      final userDataString = prefs.getString('user_data');
      final userData = userDataString != null
          ? jsonDecode(userDataString)
          : {'id': '685fb750cc084ba7e0ef8533'}; // Fallback for testing
      currentUserId = userData['id']; 
    }
    if (currentUserId == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('User ID not found. Please log in again.'),
          backgroundColor: Theme.of(context).colorScheme.error,
        ),
      );
      return;
    }

    setState(() {
      if (post.likedByMe) {
        post.likedByMe = false;
        post.likes--;
      } else {
        post.likedByMe = true;
        post.likes++;
      }
    });

    final result = await _songPostService.likePost(post.id, currentUserId);
    if (result['success']) {
      if (post.userId != null) {
        await _songPostService.addRecentlyLikedUser(
          currentUserId,
          post.userId!,
        );
      }
    }
    if (!result['success']) {
      setState(() {
        if (post.likedByMe) {
          post.likedByMe = false;
          post.likes--;
        } else {
          post.likedByMe = true;
          post.likes++;
        }
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(result['message'] ?? 'Failed to like post'),
          backgroundColor: Theme.of(context).colorScheme.error,
        ),
      );
    }
  }

  void _handleComment(data_model.Post post) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => SizedBox(
        height: MediaQuery.of(context).size.height * 0.75,
        child: CommentSection(
          comments: post.comments,
          onAddComment: (text) async {
            final prefs = await SharedPreferences.getInstance();
            final userDataString = prefs.getString('user_data');
            final userData = userDataString != null
                ? jsonDecode(userDataString)
                : {'id': '685fb750cc084ba7e0ef8533', 'name': 'owl'};
            final result = await _songPostService.addComment(
                post.id, userData['id'], userData['name'], text);
            if (result['success']) {
              final updatedComments =
                  (result['data']['comments'] as List<dynamic>)
                      .map((c) => data_model.Comment.fromJson(c))
                      .toList();
              setState(() {
                post.comments = updatedComments;
              });
              return updatedComments; 
            } else {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(result['message'] ?? 'Failed to add comment'),
                  backgroundColor: Theme.of(context).colorScheme.error,
                ),
              );
              return post.comments; 
            }
          },
          postId: post.id,
          currentUserId: userId ?? '',
          songPostService: _songPostService,
        ),
      ),
    );
  }

  Future<void> _handlePlay(data_model.Post post) async {
    if (_currentlyPlayingTrackId == post.trackId && _isPlaying) {
      setState(() {
        _isPlaying = false;
      });
      try {
        await _pausePlayback();
      } catch (e) {
        setState(() {
          _isPlaying = true;
        });
      }
    } else {
      setState(() {
        _currentlyPlayingTrackId = post.trackId;
        _isPlaying = true;
      });
      try {
        await _playTrack(post);
      } catch (e) {
        setState(() {
          _isPlaying = false;
        });
      }
    }
  }

  Future<void> _playTrack(data_model.Post post) async {
    try {
      final authService = Provider.of<AuthService>(context, listen: false);
      final dio = authService.dio;
      final response = await dio.post(
        '/spotify/player/post/play',
        data: {'track_id': post.trackId},
      );
      if (response.statusCode == 200 ||
          response.statusCode == 202 ||
          response.statusCode == 204) {
        setState(() {
          _currentlyPlayingTrackId = post.trackId;
          _isPlaying = true;
        });
      }
    } catch (e) {
      String errorMsg = 'Failed to play track';
      if (e is DioError && e.response != null && e.response?.data != null) {
        final data = e.response?.data;
        if (data is Map && data['message'] != null) {
          errorMsg = data['message'];
        } else if (data is String) {
          errorMsg = data;
        }
      }
    }
  }

  Future<void> _pausePlayback() async {
    try {
      final authService = Provider.of<AuthService>(context, listen: false);
      final dio = authService.dio;
      final response = await dio.put('/spotify/player/post/pause');
      if (response.statusCode == 200 || response.statusCode == 204) {
        setState(() {
          _isPlaying = false;
        });
      }
    } catch (e) {
      
    }
  }

  void _handleShare(data_model.Post post) {
    final shareText =
        'Check out this song: ${post.songName} by ${post.artists}';
    Share.share(shareText, subject: 'Music from Noot');
  }

  void _handlePostOptions(data_model.Post post) {
    print('HomeScreen _handlePostOptions - Post ID: ${post.id}');
    print('HomeScreen _handlePostOptions - Post User ID: ${post.userId}');
    print('HomeScreen _handlePostOptions - Current User ID: $userId');

    // Check if either ID is null or empty
    if (post.userId == null || post.userId!.isEmpty) {
      print('WARNING: Post userId is null or empty');
    }
    if (userId == null || userId!.isEmpty) {
      print('WARNING: Current userId is null or empty');
    }

    bool isUsersOwnPost = false;
    if (post.userId != null && userId != null) {
      isUsersOwnPost = post.userId == userId;
      print('Calculated isUsersOwnPost: $isUsersOwnPost');
    } else {
      print('Cannot determine if post is user\'s own due to null IDs');
    }

    PostOptionsMenu.show(
      context,
      postUserId: post.userId,
      currentUserId: userId,
      isOwnPost: isUsersOwnPost, // Explicitly set based on our calculation
      // ...existing code...
    );
  }

  String _formatTimestamp(DateTime timestamp) {
    final now = DateTime.now();
    final difference = now.difference(timestamp);

    if (difference.inDays > 0) {
      return '${difference.inDays}d';
    } else if (difference.inHours > 0) {
      return '${difference.inHours}h';
    } else if (difference.inMinutes > 0) {
      return '${difference.inMinutes}m';
    } else {
      return 'now';
    }
  }

  @override
  Widget build(BuildContext context) {
    
    Widget content = FeedWidget(
      feedItems: _feedItems,
      isLoading: _isLoading,
      error: _error,
      onRefresh: _loadPosts,
      onSongLike: (data_model.Post post) => _handleLike(post),
      onSongComment: (data_model.Post post) => _handleComment(post),
      onSongPlay: (data_model.Post post) => _handlePlay(post),
      onSongShare: (data_model.Post post) => _handleShare(post),
      onThoughtLike: (ThoughtsPost post) {}, // TODO: implement
      onThoughtComment: (ThoughtsPost post) {}, // TODO: implement
      currentlyPlayingTrackId: _currentlyPlayingTrackId,
      isPlaying: _isPlaying,
      onUserTap: (String userId) {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => UserProfilePage(userId: userId),
          ),
        );
      },
      onPostOptions: _handlePostOptions,
    );

    // When in shell mode, only render the content without navigation elements
    if (widget.inShell) {
      return content;
    }

    // LEGACY NAVIGATION SUPPORT - This code will eventually be removed
    // when all screens are migrated to the ShellScreen
    return Scaffold(
      // OLD NAVIGATION: App bar will be provided by ShellScreen in the future
      appBar: NootAppBar(),
      body: Column(
        children: [
          Expanded(
            child: content,
          ),
        ],
      ),
      // OLD NAVIGATION: Bottom bar will be provided by ShellScreen in the future
      bottomNavigationBar: const BottomBar(),
    );
    // END LEGACY NAVIGATION SUPPORT
  }
}
