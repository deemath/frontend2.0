import 'package:flutter/material.dart';
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

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const Padding(
          padding: EdgeInsets.all(16.0),
          child: Text(
            'Feed',
            style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
          ),
        ),
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
    return Container(
      margin: const EdgeInsets.only(bottom: 24.0),
      height: 600, // Fixed height for the post
      child: Scaffold(
        // backgroundColor: Colors.white,
        body: Container(
          margin: const EdgeInsets.all(16.0),
          child: Stack(
            children: [
              // Layer for post_shape widget
              AspectRatio(
                aspectRatio: 490 / 595,
                child: CustomPaint(
                  painter: PostShape(backgroundColor: const Color(0xff423E4E)),
                  child: Container(),
                ),
              ),
              // Layer for post widget
              AspectRatio(
                aspectRatio: 490 / 595, // Same aspect ratio for overlay
                child: Post(
                  trackId: post['trackId'],
                  songName: post['songName'],
                  artists: post['artists'],
                  albumImage: post['albumImage'],
                  caption: post['caption'],
                  username: post['username'] ?? 'Unknown User',
                  userImage: 'assets/images/hehe.png', // Default profile image
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
              ),
            ],
          ),
        ),
      ),
    );
  }
}
