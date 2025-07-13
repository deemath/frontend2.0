import 'package:flutter/material.dart';
import '../widgets/home/header_bar.dart';
import '/presentation/widgets/common/bottom_bar.dart';
import '../widgets/home/feed_widget.dart';
import '../../data/models/post_model.dart' as data_model;
import '../../data/services/song_post_service.dart';
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:provider/provider.dart';
import '../../data/services/auth_service.dart';
import 'package:dio/dio.dart';
import '../widgets/song_post/comment.dart';
import 'package:share_plus/share_plus.dart';

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
  
  List<data_model.Post> _posts = [];
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

      print('Loading posts for user: $userId');
      final result = await _songPostService.getAllPosts();
      print('Posts loading result: $result');
      
      if (result['success']) {
        final List<dynamic> postsData = result['data'];
        print('Received ${postsData.length} posts from all users');
        
        final posts = postsData.map((json) {
          final post = data_model.Post.fromJson(json);
          post.likedByMe = (json['likedBy'] as List<dynamic>?)?.contains(userId) ?? false;
          print('Post from user: ${post.username}, liked by me: ${post.likedByMe}');
          return post;
        }).toList();
        
        setState(() {
          _posts = posts;
          _isLoading = false;
        });
        
        print('Successfully loaded ${posts.length} posts from all users');
      } else {
        print('Failed to load posts: ${result['message']}');
        setState(() {
          _error = result['message'];
          _isLoading = false;
        });
      }
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
      currentUserId = userData['id']; // Use 'id' instead of '_id'
    }
    if (currentUserId == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('User ID not found. Please log in again.')),
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
        SnackBar(content: Text(result['message'] ?? 'Failed to like post')),
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
            final userData = userDataString != null ? jsonDecode(userDataString) : {'id': '685fb750cc084ba7e0ef8533', 'name': 'owl'};
            final result = await _songPostService.addComment(post.id, userData['id'], userData['name'], text);
            if (result['success']) {
              setState(() {
                post.comments = (result['data']['comments'] as List<dynamic>).map((c) => data_model.Comment.fromJson(c)).toList();
              });
              Navigator.of(context).pop();
              _handleComment(post); // reopen to refresh
            } else {
              ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(result['message'] ?? 'Failed to add comment')));
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
      if (response.statusCode == 200 || response.statusCode == 202 || response.statusCode == 204) {
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
      // Handle error silently
    }
  }

  void _handleShare(data_model.Post post) {
    final shareText = 'Check out this song: ${post.songName} by ${post.artists}';
    Share.share(shareText, subject: 'Music from Noot');
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
    // Content with backend data
    Widget content = FeedWidget(
      posts: _posts,
      isLoading: _isLoading,
      error: _error,
      onRefresh: _loadPosts,
      onLike: _handleLike,
      onComment: _handleComment,
      onPlay: _handlePlay,
      onShare: _handleShare,
      currentlyPlayingTrackId: _currentlyPlayingTrackId,
      isPlaying: _isPlaying,
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
