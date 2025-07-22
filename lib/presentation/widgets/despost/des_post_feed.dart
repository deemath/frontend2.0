import 'package:flutter/material.dart';
import 'package:palette_generator/palette_generator.dart';
import './widgets/TMP_des_post_content_widget.dart';
import './widgets/TMP_des_post_bg_container.dart';

class FeedWidget extends StatefulWidget {
  const FeedWidget({Key? key}) : super(key: key);

  @override
  State<FeedWidget> createState() => _FeedWidgetState();
}

class _FeedWidgetState extends State<FeedWidget> {
  final List<Map<String, dynamic>> feedPosts = [
    {
      "_id": "686b967060b0a052ded69195",
      "trackId": "12VqMTtUAuHwsWRSGYTZRE",
      "songName": "ATLAS",
      "artists": "Pretty Patterns",
      "albumImage":
          "https://i.scdn.co/image/ab67616d0000b273371ea9340b6b2157e8adc10f",
      "caption": "guliguli", // WHAT IS A CAPTION? - RAVINDU
      "username": "owl",
      "title": "This song hits different",
      "description":
          "It’s 2AM and I’ve got ATLAS on repeat—there’s something about this song that just hits different when the world is quiet. The synths feel like they’re wrapping around me, and every little detail stands out in the dark. It’s like drifting through space, but somehow it makes everything feel closer and more real. The way the melodies weave together is almost hypnotic, and I catch myself getting lost in it every time. Pretty Patterns really nailed that late-night vibe—this track is my go-to for those moments when I just want to think, dream, or just exist for a while.",
    },
    {
      "_id": "686b966920b0a052ded69192",
      "trackId": "6K6wDKxAKY3yRoWnf7O2fT",
      "songName": "BLUESTAR",
      "artists": "Pretty Patterns",
      "albumImage":
          "https://i.scdn.co/image/ab67616d0000b27358b2eb8669e1197a203afb3f",
      "caption": "hehe", // WHAT IS A CAPTION? -RAVINDU
      "username": "owl",
      "title": "This song is just amazing",
      "description":
          "BLUESTAR just leaves me speechless every time. The vocals are honestly angelic—there’s this softness and clarity that makes every word feel like it’s floating. And when the piano comes in, it hits you in ways you can’t even explain. It’s not just a melody, it’s like an emotion you can feel in your bones. The whole track feels weightless, but somehow it still lands with so much impact. Pretty Patterns really knows how to make a song that sticks with you long after it ends.",
    },
    {
      "_id": "686b966060b0a052ded69190",
      "trackId": "406IpEtZPvbxApWTGM3twY",
      "songName": "HOT",
      "artists": "LE SSERAFIM",
      "albumImage":
          "https://i.scdn.co/image/ab67616d0000b27386efcf81bf1382daa2d2afe6",
      "caption": "huh", // WHAT IS A CAPTION? - RAVINDU
      "username": "owl",
      "title":
          "I didnt think i would get this addicted to a Kpop song of all songs",
      "description":
          "HOT by LE SSERAFIM is just pure energy from start to finish. The beat instantly gets your heart racing, and the way the vocals ride over those punchy synths is addictive. Every time the chorus drops, I can’t help but move—there’s this confidence and attitude in the delivery that makes you feel unstoppable. It’s the kind of song that makes you want to blast it with friends or put on repeat when you need a boost. I never thought I’d get hooked on a Kpop track, but HOT totally changed my mind. It’s bold, catchy, and honestly impossible to sit still while it’s playing.",
    }
  ];

  final Map<String, Color> _extractedColors = {};
  final Color _defaultColor = const Color.fromARGB(255, 17, 37, 37);

  @override
  void initState() {
    super.initState();
    _extractColorsFromAlbumImages();
  }

  Future<void> _extractColorsFromAlbumImages() async {
    for (final post in feedPosts) {
      final albumImageUrl = post['albumImage'] as String;
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

  @override
  Widget build(BuildContext context) {
    return Center(
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 600),
        child: ListView.builder(
          padding: const EdgeInsets.symmetric(vertical: 12),
          itemCount: feedPosts.length,
          itemBuilder: (context, index) {
            final post = feedPosts[index];
            return _buildPostItem(post);
          },
        ),
      ),
    );
  }

  Widget _buildPostItem(Map<String, dynamic> post) {
    final albumImageUrl = post['albumImage'] as String;
    final backgroundColor = _extractedColors[albumImageUrl] ?? _defaultColor;
    const double postAspectRatio = 490 / 223; // Old Aspect ratio was 496 / 455

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
                  trackId: post['trackId'] ?? '',
                  postId: post['_id'],
                  songName: post['songName'] ?? '',
                  artists: post['artists'] ?? '',
                  albumImage: post['albumImage'] ?? '',
                  caption: post['caption'] ?? '',
                  username: post['username'] ?? '',
                  userImage: 'assets/images/profile_picture.jpg',
                  descriptionTitle: post['title'],
                  description: post['description'],
                  onLike: () => print('Liked post: ${post['_id']}'),
                  onComment: () => print('Comment: ${post['_id']}'),
                  isLiked: false,
                  isPlaying: false,
                  backgroundColor: backgroundColor, // Add this line
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

//   Widget _buildPostItem(Map<String, dynamic> post) {
//   final albumImageUrl = post['albumImage'] as String;
//   final backgroundColor = _extractedColors[albumImageUrl] ?? _defaultColor;

//   return Padding(
//     padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
//     child: LayoutBuilder(
//       builder: (context, constraints) {
//         return ConstrainedBox(
//           constraints: const BoxConstraints(
//             minHeight: 220,
//             maxHeight: 455, // allows growth but caps it
//           ),
//           child: Container(
//             clipBehavior: Clip.hardEdge,
//             decoration: const BoxDecoration(),
//             child: Stack(
//               children: [
//                 // Background painter fills height naturally
//                 Positioned.fill(
//                   child: CustomPaint(
//                     painter: PostShape(backgroundColor: backgroundColor),
//                   ),
//                 ),
//                 Padding(
//                   padding: const EdgeInsets.all(12.0),
//                   child: Post(
//                     trackId: post['trackId'],
//                     songName: post['songName'],
//                     artists: post['artists'],
//                     albumImage: post['albumImage'],
//                     caption: post['caption'],
//                     username: post['username'] ?? 'Unknown User',
//                     userImage: 'assets/images/profile_picture.jpg',
//                     descriptionTitle: post['title'],
//                     description: post['description'],
//                     onLike: () => print('Liked post: ${post['_id']}'),
//                     onComment: () => print('Comment: ${post['_id']}'),
//                     isLiked: false,
//                     isPlaying: false,
//                   ),
//                 ),
//               ],
//             ),
//           ),
//         );
//       },
//     ),
//   );
// }
}
