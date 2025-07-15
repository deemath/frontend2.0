import 'package:flutter/material.dart';
import 'package:palette_generator/palette_generator.dart';
import '../song_post/post.dart';
import '../song_post/post_shape.dart';
import '../../../data/models/post_model.dart' as data_model;

/// A feed widget that displays song posts
class FeedWidget extends StatefulWidget {
  final List<data_model.Post>? posts;
  final bool isLoading;
  final String? error;
  final VoidCallback? onRefresh;
  final Function(data_model.Post)? onLike;
  final Function(data_model.Post)? onComment;
  final Function(data_model.Post)? onPlay;
  final Function(data_model.Post)? onShare;
  final String? currentlyPlayingTrackId;
  final bool isPlaying;

  const FeedWidget({
    Key? key,
    this.posts,
    this.isLoading = false,
    this.error,
    this.onRefresh,
    this.onLike,
    this.onComment,
    this.onPlay,
    this.onShare,
    this.currentlyPlayingTrackId,
    this.isPlaying = false,
  }) : super(key: key);

  @override
  State<FeedWidget> createState() => _FeedWidgetState();
}

class _FeedWidgetState extends State<FeedWidget> {
  // Map to store extracted colors for each album image
  final Map<String, Color> _extractedColors = {};
  Color get _defaultColor {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return isDark ? const Color.fromARGB(255, 17, 37, 37) : const Color(0xFFF5F5F5);
  }

  @override
  void initState() {
    super.initState();
    _extractColorsFromAlbumImages();
  }

  @override
  void didUpdateWidget(FeedWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.posts != widget.posts) {
      _extractColorsFromAlbumImages();
    }
  }

  // Method to extract dark colors from album images
  Future<void> _extractColorsFromAlbumImages() async {
    if (widget.posts == null) return;
    
    for (final post in widget.posts!) {
      final albumImageUrl = post.albumImage;
      if (albumImageUrl == null || albumImageUrl.isEmpty) continue;
      
      if (!_extractedColors.containsKey(albumImageUrl)) {
        try {
          final PaletteGenerator paletteGenerator =
              await PaletteGenerator.fromImageProvider(
            NetworkImage(albumImageUrl),
            size: Size(100, 100), // Smaller size for faster processing
            maximumColorCount: 10, // Extract up to 10 colors
          );

          // Try to get the dark muted color first, then fall back to other options
          Color? extractedColor = paletteGenerator.darkMutedColor?.color;

          // If no dark muted color, try dark vibrant or just the dominant color
          if (extractedColor == null) {
            extractedColor = paletteGenerator.darkVibrantColor?.color;
            if (extractedColor == null) {
              extractedColor = paletteGenerator.dominantColor?.color;
            }
          }

          // If color was extracted, store it, otherwise use default
          if (extractedColor != null) {
            // Ensure the color is dark enough
            if (_isDarkEnough(extractedColor)) {
              setState(() {
                _extractedColors[albumImageUrl] = extractedColor!;
              });
            } else {
              // Darken the color if it's not dark enough
              setState(() {
                _extractedColors[albumImageUrl] = _darkenColor(extractedColor!);
              });
            }
          } else {
            setState(() {
              _extractedColors[albumImageUrl] = _defaultColor;
            });
          }
        } catch (e) {
          print('Error extracting color from $albumImageUrl: $e');
          setState(() {
            _extractedColors[albumImageUrl] = _defaultColor;
          });
        }
      }
    }
  }

  // Helper method to check if a color is dark enough
  bool _isDarkEnough(Color color) {
    // Calculate relative luminance (0 for black, 1 for white)
    double luminance =
        0.299 * color.red + 0.587 * color.green + 0.114 * color.blue;
    luminance = luminance / 255;

    // Return true if the color is dark enough (luminance < 0.5)
    return luminance < 0.4; // Lower threshold for darker colors
  }

  // Helper method to darken a color
  Color _darkenColor(Color color) {
    const double darkenFactor = 0.6; // Higher values make the color darker
    return Color.fromARGB(
      color.alpha,
      (color.red * darkenFactor).round(),
      (color.green * darkenFactor).round(),
      (color.blue * darkenFactor).round(),
    );
  }

  @override
  Widget build(BuildContext context) {
    print('FeedWidget build - isLoading: ${widget.isLoading}, posts count: ${widget.posts?.length ?? 0}');
    
    if (widget.isLoading) {
      return const Center(
        child: CircularProgressIndicator(
          color: Color(0xFF8E08EF),
        ),
      );
    }

    if (widget.error != null) {
      print('FeedWidget error: ${widget.error}');
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.error_outline, color: Colors.white, size: 48),
            const SizedBox(height: 16),
            Text(
              widget.error!,
              style: TextStyle(
                color: Theme.of(context).brightness == Brightness.dark
                    ? Colors.white
                    : Colors.black,
              ),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: widget.onRefresh,
              child: const Text('Try Again'),
            ),
          ],
        ),
      );
    }

    if (widget.posts == null || widget.posts!.isEmpty) {
      print('FeedWidget: No posts to display');
      return const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.music_note, color: Colors.white, size: 48),
            SizedBox(height: 16),
            Text('No posts yet', style: TextStyle(fontSize: 18)),
            Text('Be the first to share your favorite music!'),
          ],
        ),
      );
    }

    print('FeedWidget: Displaying ${widget.posts!.length} posts from all users');
    return RefreshIndicator(
      onRefresh: () async {
        print('FeedWidget: Pull to refresh triggered');
        if (widget.onRefresh != null) {
          widget.onRefresh!();
        }
      },
      child: ListView.builder(
        itemCount: widget.posts!.length,
        itemBuilder: (context, index) {
          final post = widget.posts![index];
          print('FeedWidget: Building post ${index + 1}/${widget.posts!.length} from user: ${post.username}');
          return _buildPostItem(post);
        },
      ),
    );
  }

  Widget _buildPostItem(data_model.Post post) {
    // Define the aspect ratio for consistency
    const postAspectRatio = 490 / 595;

    // Get the extracted color for this post or use default if not available yet
    final albumImageUrl = post.albumImage ?? '';
    final backgroundColor = _extractedColors[albumImageUrl] ?? _defaultColor;

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
      // Use AspectRatio to ensure proper sizing
      child: AspectRatio(
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
              trackId: post.trackId,
              songName: post.songName,
              artists: post.artists,
              albumImage: post.albumImage,
              caption: post.caption,
              username: post.username,
              userImage: 'assets/images/profile_picture.jpg', // Default profile image
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
              onPlayPause: () {
                if (widget.onPlay != null) {
                  widget.onPlay!(post);
                }
              },
              onShare: () {
                if (widget.onShare != null) {
                  widget.onShare!(post);
                }
              },
              isLiked: post.likedByMe,
              isPlaying: widget.isPlaying,
              isCurrentTrack: widget.currentlyPlayingTrackId == post.trackId,
            ),
          ],
        ),
      ),
    );
  }
}
