import 'package:flutter/material.dart';
import './feed_bg_container.dart';
import './feed_post.dart';
import '../../../data/services/song_post_service.dart';
import '../../../data/models/post_model.dart' as data_model;

class FeedPage extends StatefulWidget {
  final List<data_model.Post>? posts;
  final bool isLoading;
  final String? error;
  final VoidCallback? onRefresh;
  final Function(data_model.Post)? onLike;
  final Function(data_model.Post)? onComment;
  final Function(data_model.Post)? onPlay;
  final String? currentlyPlayingTrackId;
  final bool isPlaying;

  const FeedPage({
    super.key,
    this.posts,
    this.isLoading = false,
    this.error,
    this.onRefresh,
    this.onLike,
    this.onComment,
    this.onPlay,
    this.currentlyPlayingTrackId,
    this.isPlaying = false,
  });

  @override
  State<FeedPage> createState() => _FeedPageState();
}

class _FeedPageState extends State<FeedPage> {
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
    if (widget.isLoading) {
      return const Center(
        child: CircularProgressIndicator(
          color: Color(0xFF8E08EF),
        ),
      );
    }

    if (widget.error != null) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Error: ${widget.error}',
              style: const TextStyle(color: Colors.red),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: widget.onRefresh,
              child: const Text('Retry'),
            ),
          ],
        ),
      );
    }

    if (widget.posts == null || widget.posts!.isEmpty) {
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

    // Show the first post for now. Later you can implement pagination or scrolling
    final post = widget.posts!.first;
    return FeedPostWidget(
      post: {
        'trackId': post.trackId,
        'songName': post.songName,
        'artists': post.artists,
        'albumImage': post.albumImage,
        'caption': post.caption,
        'username': post.username,
        'userAvatar': 'assets/images/hehe.png', // Default avatar
        'trackName': post.songName,
        'artistName': post.artists,
        '_id': post.id,
      },
      onLike: () {
        if (widget.onLike != null) {
          widget.onLike!(post);
        }
      },
      onComment: () {
        if (widget.onComment != null) {
          widget.onComment!(post);
        }
      },
      onPlay: () {
        if (widget.onPlay != null) {
          widget.onPlay!(post);
        }
      },
      isLiked: post.likedByMe,
      isPlaying: widget.currentlyPlayingTrackId == post.trackId && widget.isPlaying,
    );
  }
}
