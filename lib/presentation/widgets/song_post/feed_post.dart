import 'package:flutter/material.dart';



// ================= SongControlWidget =================
class SongControlWidget extends StatelessWidget {
  const SongControlWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      flex: 131,
      child: Container(
        margin: const EdgeInsets.all(4.0),
        child: const Center(
          child: Text(
            'Song',
            style: TextStyle(
              color: Colors.white,
              fontSize: 16,
            ),
          ),
        ),
      ),
    );
  }
}

// ================= TrackDetailWidget =================
class TrackDetailWidget extends StatelessWidget {
  final String? songName;
  final String? artists;

  const TrackDetailWidget({super.key, this.songName, this.artists});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      flex: 359,
      child: Container(
        margin: const EdgeInsets.all(4.0),
        child: const Center(
          child: Text(
            'Track Details',
            style: TextStyle(
              color: Colors.white,
              fontSize: 16,
            ),
          ),
        ),
      ),
    );
  }
}

// ================= UserDetailWidget =================
class UserDetailWidget extends StatelessWidget {
  final Map<String, dynamic>? details;

  const UserDetailWidget({super.key, this.details});

  @override
  Widget build(BuildContext context) {
    final textColor = Theme.of(context).colorScheme.onPrimary;
    // demo data
    final data = details ?? {
      'username': 'ishaanKhatter',
      'song': 'august - Taylor Swift',
      'avatar': 'assets/images/hehe.png',
    };

    return Expanded(
      flex: 359,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // Large Profile Picture
            CircleAvatar(
              radius: 32,
              backgroundColor: Colors.transparent,
              backgroundImage: AssetImage(data['avatar']),
            ),
            const SizedBox(width: 18),
            // Username only, vertically centered
            Expanded(
              child: Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  data['username'],
                  style: TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.w600,
                    fontSize: 18,
                    letterSpacing: 0.2,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ================= InteractionWidget =================
class InteractionWidget extends StatelessWidget {
  final VoidCallback? onLike;
  final VoidCallback? onComment;
  final VoidCallback? onPlay;
  final bool isLiked;
  final bool isPlaying;
  final int likesCount;
  final int commentsCount;

  const InteractionWidget({
    super.key,
    this.onLike,
    this.onComment,
    this.onPlay,
    this.isLiked = false,
    this.isPlaying = false,
    this.likesCount = 0,
    this.commentsCount = 0,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      flex: 131,
      child: Container(
        margin: const EdgeInsets.all(4.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            // Like button
            GestureDetector(
              onTap: onLike,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    isLiked ? Icons.favorite : Icons.favorite_border,
                    color: isLiked ? Colors.red : Colors.white,
                    size: 20,
                  ),
                  if (likesCount > 0)
                    Text(
                      '$likesCount',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 12,
                      ),
                    ),
                ],
              ),
            ),
            // Comment button
            GestureDetector(
              onTap: onComment,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(
                    Icons.comment_outlined,
                    color: Colors.white,
                    size: 20,
                  ),
                  if (commentsCount > 0)
                    Text(
                      '$commentsCount',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 12,
                      ),
                    ),
                ],
              ),
            ),
            // Play button
            GestureDetector(
              onTap: onPlay,
              child: Icon(
                isPlaying ? Icons.pause : Icons.play_arrow,
                color: Colors.white,
                size: 20,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ================= PostArtWidget =================
class PostArtWidget extends StatelessWidget {
  const PostArtWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        // Calculate square size: width minus left and right margins
        double squareSize =
            constraints.maxWidth - 18.0; // 9.0 left + 9.0 right margins
        return Container(
          height: squareSize, // Height equals width to make it square
          margin: const EdgeInsets.only(
            left: 9.0,
            right: 9.0,
            top: 9.0,
            bottom: 9.0,
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(8.0),
            child: Image.asset(
              'assets/images/song.png',
              fit: BoxFit.cover,
              width: double.infinity,
              height: double.infinity,
            ),
          ),
        );
      },
    );
  }
}

// ================= FooterWidget =================
class FooterWidget extends StatelessWidget {
  final String? songName;
  final String? artists;
  final VoidCallback? onLike;
  final VoidCallback? onComment;
  final VoidCallback? onPlay;
  final bool isLiked;
  final bool isPlaying;
  final int likesCount;
  final int commentsCount;

  const FooterWidget({
    super.key,
    this.songName,
    this.artists,
    this.onLike,
    this.onComment,
    this.onPlay,
    this.isLiked = false,
    this.isPlaying = false,
    this.likesCount = 0,
    this.commentsCount = 0,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      flex: 73,
      child: Row(
        children: [
          TrackDetailWidget(
            songName: songName,
            artists: artists,
          ),
          InteractionWidget(
            onLike: onLike,
            onComment: onComment,
            onPlay: onPlay,
            isLiked: isLiked,
            isPlaying: isPlaying,
            likesCount: likesCount,
            commentsCount: commentsCount,
          ),
        ],
      ),
    );
  }
}

// ================= HeaderWidget =================
class HeaderWidget extends StatelessWidget {
  const HeaderWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return const Expanded(
      flex: 72,
      child: Row(
        children: [
          UserDetailWidget(),
          SongControlWidget(),
        ],
      ),
    );
  }
}

// ================= DemoContentWidget =================
class DemoContentWidget extends StatelessWidget {
  const DemoContentWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      child: const Column(
        children: [
          // Row 1: 2 columns
          HeaderWidget(),
          // Gap between Row 1 and Row 2
          // const SizedBox(height: 5.0),
          // Row 2: 1 column (full width) - Square shape
          PostArtWidget(),
          // Gap between Row 2 and Row 3
          // const SizedBox(height: 5.0),
          // Row 3: 2 columns
          FooterWidget(),
        ],
      ),
    );
  }
}

// ================= FeedPostWidget =================
class FeedPostWidget extends StatelessWidget {
  final Map<String, dynamic> post;
  final VoidCallback onLike;
  final VoidCallback onComment;
  final VoidCallback onPlay;
  final bool isLiked;
  final bool isPlaying;

  const FeedPostWidget({
    super.key,
    required this.post,
    required this.onLike,
    required this.onComment,
    required this.onPlay,
    required this.isLiked,
    required this.isPlaying,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        children: [
          // Header with user details
          Expanded(
            flex: 72,
            child: Row(
              children: [
                // User details
                Expanded(
                  flex: 359,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        // Profile Picture
                        CircleAvatar(
                          radius: 32,
                          backgroundColor: Colors.transparent,
                          backgroundImage: AssetImage(post['userAvatar'] ?? 'assets/images/hehe.png'),
                        ),
                        const SizedBox(width: 18),
                        // Username
                        Expanded(
                          child: Align(
                            alignment: Alignment.centerLeft,
                            child: Text(
                              post['username'] ?? 'Unknown User',
                              style: const TextStyle(
                                color: Colors.black,
                                fontWeight: FontWeight.w600,
                                fontSize: 18,
                                letterSpacing: 0.2,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                // Song control
                Expanded(
                  flex: 131,
                  child: GestureDetector(
                    onTap: onPlay,
                    child: Container(
                      margin: const EdgeInsets.all(4.0),
                      child: Icon(
                        isPlaying ? Icons.pause : Icons.play_arrow,
                        color: Colors.white,
                        size: 24,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          // Post art
          PostArtWidget(),
          // Footer with track details and interactions
          FooterWidget(
            songName: post['trackName'] ?? 'Unknown Track',
            artists: post['artistName'] ?? 'Unknown Artist',
            onLike: onLike,
            onComment: onComment,
            onPlay: onPlay,
            isLiked: isLiked,
            isPlaying: isPlaying,
            likesCount: post['likes'] ?? 0,
            commentsCount: post['comments']?.length ?? 0,
          ),
        ],
      ),
    );
  }
}