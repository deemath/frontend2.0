import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';

import '../../widgets/home/header_bar.dart';

class PostDetailPage extends StatelessWidget {
  final String postId;
  final String trackId;
  final String songName;
  final String artists;
  final String albumImage;
  final List<Map<String, String>> comments;
  final String username;
  final String userImage;
  final String title;
  final String description;
  final bool isLiked;
  final bool isPlaying;
  final bool isCurrentTrack;
  final Color backgroundColor;

  const PostDetailPage({
    super.key,
    required this.postId,
    required this.trackId,
    required this.songName,
    required this.artists,
    required this.albumImage,
    required this.comments,
    required this.username,
    required this.userImage,
    required this.title,
    required this.description,
    required this.isLiked,
    required this.isPlaying,
    required this.isCurrentTrack,
    required this.backgroundColor,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).primaryColor,
      appBar: NootAppBar(),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // AppBar content moved here
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
              IconButton(
                icon: Icon(Icons.arrow_back, color: Theme.of(context).colorScheme.onPrimary),
                onPressed: () => Navigator.pop(context),
              ),
              Text(
                "Post",
                style: TextStyle(
                color: Theme.of(context).colorScheme.onPrimary,
                fontWeight: FontWeight.w500,
                fontSize: 20,
                ),
              ),
              ],
            ),
            const SizedBox(height: 10),
            // Song Card
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: backgroundColor,
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    blurRadius: 6,
                    offset: const Offset(0, 3),
                  )
                ],
              ),
              child: Row(
                children: [
                  ClipRRect(
                    borderRadius: const BorderRadius.only(
                        topLeft: Radius.circular(12),
                        bottomLeft: Radius.circular(12)),
                    child: Image.network(
                      albumImage,
                      width: 70,
                      height: 70,
                      fit: BoxFit.cover,
                      errorBuilder: (_, __, ___) => Image.asset(
                        'assets/images/song.png',
                        width: 70,
                        height: 70,
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          songName,
                          style: const TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 16),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          artists,
                          style: TextStyle(
                              color: Colors.grey.shade400, fontSize: 14),
                        ),
                      ],
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.play_circle_fill,
                        color: Colors.purple, size: 32),
                    onPressed: () {},
                  ),
                  IconButton(
                    icon: Image.asset(
                      'assets/images/spotify.png',
                      height: 24,
                    ),
                    onPressed: () {},
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),

            // Post Title
            Text(
              title,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 18,
                color: Theme.of(context).colorScheme.onPrimary,
              ),
            ),
            const SizedBox(height: 8),

            // Post Description
            Text(
              description,
              style: TextStyle(
                fontSize: 15,
                color: Colors.grey.shade500,
                height: 1.4,
              ),
            ),
            const SizedBox(height: 20),

            // Comments
            Text(
              "Comments (${comments.length})",
              style: const TextStyle(
                fontWeight: FontWeight.w600,
                fontSize: 15,
              ),
            ),
            const SizedBox(height: 12),
            for (var c in comments) ...[
              Padding(
                padding: const EdgeInsets.only(bottom: 12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      c['username'] ?? '',
                      style: const TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 14,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      c['text'] ?? '',
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey.shade800,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
