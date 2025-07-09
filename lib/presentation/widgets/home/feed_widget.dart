import 'package:flutter/material.dart';
import 'package:palette_generator/palette_generator.dart';
import '../song_post/post.dart';
import '../song_post/post_shape.dart';

/// A feed widget that displays song posts
class FeedWidget extends StatefulWidget {
  const FeedWidget({Key? key}) : super(key: key);

  @override
  State<FeedWidget> createState() => _FeedWidgetState();
}

class _FeedWidgetState extends State<FeedWidget> {
  // Hardcoded feed posts data
  final List<Map<String, dynamic>> feedPosts = [
    {
      "_id": "686b967060b0a052ded69195",
      "trackId": "12VqMTtUAuHwsWRSGYTZRE",
      "songName": "ATLAS",
      "artists": "Pretty Patterns",
      "albumImage":
          "https://i.scdn.co/image/ab67616d0000b273371ea9340b6b2157e8adc10f",
      "caption": "guliguli",
      "username": "owl",
    },
    {
      "_id": "686b966920b0a052ded69192",
      "trackId": "6K6wDKxAKY3yRoWnf7O2fT",
      "songName": "BLUESTAR",
      "artists": "Pretty Patterns",
      "albumImage":
          "https://i.scdn.co/image/ab67616d0000b27358b2eb8669e1197a203afb3f",
      "caption": "hehe",
      "username": "owl",
    },
    {
      "_id": "686b966060b0a052ded69190",
      "trackId": "406IpEtZPvbxApWTGM3twY",
      "songName": "HOT",
      "artists": "LE SSERAFIM",
      "albumImage":
          "https://i.scdn.co/image/ab67616d0000b27386efcf81bf1382daa2d2afe6",
      "caption": "huh",
      "username": "owl",
    }
  ];

  // Map to store extracted colors for each album image
  final Map<String, Color> _extractedColors = {};
  final Color _defaultColor = Color.fromARGB(255, 17, 37, 37);

  @override
  void initState() {
    super.initState();
    _extractColorsFromAlbumImages();
  }

  // Method to extract dark colors from album images
  Future<void> _extractColorsFromAlbumImages() async {
    for (final post in feedPosts) {
      final albumImageUrl = post['albumImage'] as String;
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
    return Column(
      children: [
        // const Padding(
        //   padding: EdgeInsets.all(16.0),
        //   child: Text(
        //     'Feed',
        //     style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
        //   ),
        // ),
        Expanded(
          child: ListView.builder(
            itemCount: feedPosts.length,
            itemBuilder: (context, index) {
              final post = feedPosts[index];
              return _buildPostItem(post);
            },
          ),
        ),
      ],
    );
  }

  Widget _buildPostItem(Map<String, dynamic> post) {
    // Define the aspect ratio for consistency
    const postAspectRatio = 490 / 595;

    // Get the extracted color for this post or use default if not available yet
    final albumImageUrl = post['albumImage'] as String;
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
              trackId: post['trackId'],
              songName: post['songName'],
              artists: post['artists'],
              albumImage: post['albumImage'],
              caption: post['caption'],
              username: post['username'] ?? 'Unknown User',
              userImage:
                  'assets/images/profile_picture.jpg', // Default profile image
              onLike: () {
                // Placeholder for like action
                print('Liked post: ${post['_id']}');
              },
              onComment: () {
                // Placeholder for comment action
                print('Comment on post: ${post['_id']}');
              },
              onPlay: () {
                // Placeholder for play action
                print('Play post: ${post['_id']}');
              },
              isLiked: false,
              isPlaying: false,
            ),
            // Have a AutoSizeText widget for post['username'] and post['caption']
            // Have a bottom margin before next widget
          ],
        ),
      ),
    );
  }
}
