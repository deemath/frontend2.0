import 'package:flutter/material.dart';
import './feed_bg_container.dart';
import './feed_post.dart';
import '../../../data/services/song_post_service.dart';

class FeedPage extends StatefulWidget {
  const FeedPage({super.key});

  @override
  State<FeedPage> createState() => _FeedPageState();
}

class _FeedPageState extends State<FeedPage> {
  final SongPostService _songPostService = SongPostService();
  List<Map<String, dynamic>> _posts = [];
  bool _isLoading = true;
  String? _error;

  @override
  void initState() {
    super.initState();
    _loadPosts();
  }

  Future<void> _loadPosts() async {
    try {
      setState(() {
        _isLoading = true;
        _error = null;
      });

      final result = await _songPostService.getAllPosts();
      
      if (result['success']) {
        setState(() {
          _posts = List<Map<String, dynamic>>.from(result['data']);
          _isLoading = false;
        });
      } else {
        setState(() {
          _error = result['message'];
          _isLoading = false;
        });
      }
    } catch (e) {
      setState(() {
        _error = 'Error loading posts: $e';
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Container(
        margin: const EdgeInsets.all(16.0),
        child: Stack(
          children: [
            // Background container with fixed aspect ratio
            AspectRatio(
              aspectRatio: 490 / 595,
              child: CustomPaint(
                painter: BackgroundContainer(),
                child: Container(),
              ),
            ),
            // Container layer on top of background
            AspectRatio(
              aspectRatio: 490 / 595, // Same aspect ratio for overlay
              child: _buildContent(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildContent() {
    if (_isLoading) {
      return const Center(
        child: CircularProgressIndicator(
          color: Color(0xFF8E08EF),
        ),
      );
    }

    if (_error != null) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Error: $_error',
              style: const TextStyle(color: Colors.red),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: _loadPosts,
              child: const Text('Retry'),
            ),
          ],
        ),
      );
    }

    if (_posts.isEmpty) {
      return const Center(
        child: Text(
          'No posts yet',
          style: TextStyle(
            fontSize: 18,
            color: Colors.grey,
          ),
        ),
      );
    }

    // For now, show the first post. Later you can implement pagination or scrolling
    return FeedPostWidget(
      post: _posts.first,
      onLike: () {
        // TODO: Implement like functionality
        print('Liked post: ${_posts.first['_id']}');
      },
      onComment: () {
        // TODO: Implement comment functionality
        print('Comment on post: ${_posts.first['_id']}');
      },
      onPlay: () {
        // TODO: Implement play functionality
        print('Play song: ${_posts.first['trackId']}');
      },
      isLiked: false, // TODO: Get from user's liked posts
      isPlaying: false, // TODO: Get from current playing state
    );
  }
}
