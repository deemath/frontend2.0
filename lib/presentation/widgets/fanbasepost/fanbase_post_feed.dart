import 'package:flutter/material.dart';
import 'package:palette_generator/palette_generator.dart';
import 'package:provider/provider.dart';
import '../../../data/services/fanbase_post_service.dart';
import '../../../data/models/fanbase_post_model.dart';
import 'widgets/fanbase_post_content_widget.dart';
import './widgets/fanbase_post_bg_container.dart';

class FanbasePostFeedWidget extends StatefulWidget {
  final String fanbaseId;

  const FanbasePostFeedWidget({
    Key? key,
    required this.fanbaseId,
  }) : super(key: key);

  @override
  State<FanbasePostFeedWidget> createState() => _FanbasePostFeedWidgetState();
}

class _FanbasePostFeedWidgetState extends State<FanbasePostFeedWidget> {
  List<FanbasePost> _posts = [];
  bool _isLoading = true;
  bool _hasError = false;
  String _errorMessage = '';
  int _currentPage = 1;
  bool _hasMorePosts = true;
  bool _isLoadingMore = false;

  final ScrollController _scrollController = ScrollController();
  final Map<String, Color> _extractedColors = {};
  final Color _defaultColor = const Color.fromARGB(255, 17, 37, 37);

  @override
  void initState() {
    super.initState();
    _loadPosts();
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _onScroll() {
    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent - 200) {
      if (!_isLoadingMore && _hasMorePosts) {
        _loadMorePosts();
      }
    }
  }

  Future<void> _loadPosts() async {
    try {
      setState(() {
        _isLoading = true;
        _hasError = false;
      });

      final posts = await FanbasePostService.getFanbasePosts(
        widget.fanbaseId,
        context,
        page: 1,
        limit: 10,
      );

      if (mounted) {
        setState(() {
          _posts = posts;
          _isLoading = false;
          _currentPage = 1;
          _hasMorePosts = posts.length >= 10;
        });

        // Extract colors for album images
        _extractColorsFromAlbumImages();
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _isLoading = false;
          _hasError = true;
          _errorMessage = e.toString();
        });
      }
    }
  }

  Future<void> _loadMorePosts() async {
    if (_isLoadingMore || !_hasMorePosts) return;

    try {
      setState(() {
        _isLoadingMore = true;
      });

      final newPosts = await FanbasePostService.getFanbasePosts(
        widget.fanbaseId,
        context,
        page: _currentPage + 1,
        limit: 10,
      );

      if (mounted) {
        setState(() {
          _posts.addAll(newPosts);
          _currentPage++;
          _hasMorePosts = newPosts.length >= 10;
          _isLoadingMore = false;
        });

        // Extract colors for new album images
        _extractColorsFromAlbumImages();
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _isLoadingMore = false;
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error loading more posts: $e')),
        );
      }
    }
  }

  Future<void> _refreshPosts() async {
    await _loadPosts();
  }

  Future<void> _extractColorsFromAlbumImages() async {
    for (final post in _posts) {
      if (post.albumArt != null && post.albumArt!.isNotEmpty) {
        final albumImageUrl = post.albumArt!;
        if (!_extractedColors.containsKey(albumImageUrl)) {
          try {
            final PaletteGenerator paletteGenerator =
                await PaletteGenerator.fromImageProvider(
              NetworkImage(albumImageUrl),
              size: const Size(100, 100),
              maximumColorCount: 10,
            );

            Color? extractedColor = paletteGenerator.darkMutedColor?.color ??
                paletteGenerator.darkVibrantColor?.color ??
                paletteGenerator.dominantColor?.color;

            if (extractedColor != null) {
              setState(() {
                _extractedColors[albumImageUrl] = _isDarkEnough(extractedColor)
                    ? extractedColor
                    : _darkenColor(extractedColor);
              });
            } else {
              setState(() {
                _extractedColors[albumImageUrl] = _defaultColor;
              });
            }
          } catch (e) {
            print('Error extracting color: $e');
            setState(() {
              _extractedColors[albumImageUrl] = _defaultColor;
            });
          }
        }
      }
    }
  }

  bool _isDarkEnough(Color color) {
    double luminance =
        (0.299 * color.red + 0.587 * color.green + 0.114 * color.blue) / 255;
    return luminance < 0.4;
  }

  Color _darkenColor(Color color) {
    const double factor = 0.6;
    return Color.fromARGB(
      color.alpha,
      (color.red * factor).round(),
      (color.green * factor).round(),
      (color.blue * factor).round(),
    );
  }

  Future<void> _handleLike(FanbasePost post) async {
    try {
      final updatedPost = await FanbasePostService.likeFanbasePost(
        post.id,
        context,
      );

      setState(() {
        final index = _posts.indexWhere((p) => p.id == post.id);
        if (index != -1) {
          _posts[index] = updatedPost;
        }
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error liking post: $e')),
      );
    }
  }

  Future<void> _handleComment(FanbasePost post) async {
    // Navigate to post detail page or show comment dialog
    // You can implement this based on your app's navigation structure
    print('Comment on post: ${post.id}');
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Center(
        child: CircularProgressIndicator(),
      );
    }

    if (_hasError) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.error_outline,
              size: 64,
              color: Theme.of(context).colorScheme.error,
            ),
            const SizedBox(height: 16),
            Text(
              'Error loading posts',
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            const SizedBox(height: 8),
            Text(
              _errorMessage,
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.bodyMedium,
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
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.post_add,
              size: 64,
              color: Theme.of(context).colorScheme.onSurface.withOpacity(0.6),
            ),
            const SizedBox(height: 16),
            Text(
              'No posts yet',
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            const SizedBox(height: 8),
            Text(
              'Be the first to create a post in this fanbase!',
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.bodyMedium,
            ),
          ],
        ),
      );
    }

    return RefreshIndicator(
      onRefresh: _refreshPosts,
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 600),
          child: ListView.builder(
            controller: _scrollController,
            padding: const EdgeInsets.symmetric(vertical: 12),
            itemCount: _posts.length + (_hasMorePosts ? 1 : 0),
            itemBuilder: (context, index) {
              if (index >= _posts.length) {
                // Loading indicator for more posts
                return _isLoadingMore
                    ? const Center(
                        child: Padding(
                          padding: EdgeInsets.all(16),
                          child: CircularProgressIndicator(),
                        ),
                      )
                    : const SizedBox.shrink();
              }

              final post = _posts[index];
              return _buildPostItem(post);
            },
          ),
        ),
      ),
    );
  }

  Widget _buildPostItem(FanbasePost post) {
    final albumImageUrl = post.albumArt ?? '';
    final backgroundColor = _extractedColors[albumImageUrl] ?? _defaultColor;
    const double postAspectRatio = 490 / 223;

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
      child: Column(
        children: [
          AspectRatio(
            aspectRatio: postAspectRatio,
            child: Stack(
              fit: StackFit.expand,
              children: [
                // Layer for post_shape widget
                CustomPaint(
                  painter: PostShape(backgroundColor: backgroundColor),
                  child: Container(),
                ),
                // Layer for post widget
                Post(
                  trackId: post.spotifyTrackId ?? '',
                  postId: post.id,
                  songName: post.songName ?? '',
                  artists: post.artistName ?? '',
                  albumImage: post.albumArt ?? '',
                  caption: '', // Remove caption as it's not in the new model
                  username: post.createdBy['userName'] ?? 'Unknown User',
                  userImage: 'assets/images/profile_picture.jpg',
                  descriptionTitle: post.topic,
                  description: post.description,
                  onLike: () => _handleLike(post),
                  onComment: () => _handleComment(post),
                  isLiked: post.isLiked,
                  isPlaying:
                      false, // You can implement music playing logic here
                  backgroundColor: backgroundColor,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
