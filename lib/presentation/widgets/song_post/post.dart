import 'package:flutter/material.dart';
import 'package:auto_size_text/auto_size_text.dart';

// ================= SongControlWidget =================
class SongControlWidget extends StatelessWidget {
  final String? trackId;

  const SongControlWidget({super.key, this.trackId});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      flex: 131,
      child: Container(
        margin: const EdgeInsets.all(4.0),
        child: const Center(
          child: Text(
            'Song Control',
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

  const TrackDetailWidget({
    super.key,
    this.songName,
    this.artists,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      flex: 359,
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 4.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Song name - larger and bolder
            AutoSizeText(
              songName ?? 'Unknown Track',
              style: const TextStyle(
                color: Colors.white,
                fontSize: 12,
                fontWeight: FontWeight.w500,
              ),
              minFontSize: 8,
              maxFontSize: 12,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              textAlign: TextAlign.left,
            ),
            const SizedBox(height: 2), // Reduced spacing
            // Artists - smaller text
            AutoSizeText(
              artists ?? 'Unknown Artist',
              style: const TextStyle(
                color: Colors.white70,
                fontSize: 10,
                fontWeight: FontWeight.w300,
              ),
              minFontSize: 4,
              maxFontSize: 10,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              textAlign: TextAlign.left,
            ),
          ],
        ),
      ),
    );
  }
}

// ================= UserDetailWidget =================
class UserDetailWidget extends StatelessWidget {
  final Map<String, dynamic>? details;
  final String? username;
  final String? userImage;

  const UserDetailWidget({
    super.key,
    this.details,
    this.username,
    this.userImage,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      flex: 359,
      child: Container(
        margin: const EdgeInsets.only(left: 0, bottom: 4.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // User Image - taking maximum height possible
            AspectRatio(
              aspectRatio: 1,
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.grey.shade300,
                  borderRadius: BorderRadius.circular(16.0),
                  image: userImage != null
                      ? DecorationImage(
                          image: userImage!.startsWith('http')
                              ? NetworkImage(userImage!) as ImageProvider
                              : AssetImage(userImage!),
                          fit: BoxFit.cover,
                        )
                      : null,
                ),
              ),
            ),
            const SizedBox(width: 12),
            // Username in AutoSizeText
            Expanded(
              child: Align(
                alignment: Alignment.centerLeft,
                child: AutoSizeText(
                  username ?? 'Unknown User',
                  style: TextStyle(
                    color: Theme.of(context).brightness == Brightness.dark
                        ? Colors.white
                        : Colors.black,
                    fontWeight: FontWeight.w600,
                    fontSize: 18,
                    letterSpacing: 0.2,
                  ),
                  minFontSize: 14,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  textAlign: TextAlign.left,
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
  const InteractionWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      flex: 131,
      child: Container(
        margin: const EdgeInsets.all(4.0),
        decoration: BoxDecoration(
          color: Colors.black.withOpacity(0.1),
          borderRadius: BorderRadius.circular(8.0),
          border: Border.all(color: Colors.black.withOpacity(0.3)),
        ),
        child: const Center(
          child: Text(
            'Interactions',
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

// ================= PostArtWidget =================
class PostArtWidget extends StatelessWidget {
  final String? albumImage;

  const PostArtWidget({super.key, this.albumImage});

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
            borderRadius: BorderRadius.circular(16.0),
            child: albumImage != null && albumImage!.startsWith('http')
                ? Image.network(
                    albumImage!,
                    fit: BoxFit.cover,
                    width: double.infinity,
                    height: double.infinity,
                    errorBuilder: (context, error, stackTrace) {
                      return Image.asset(
                        'assets/images/song.png',
                        fit: BoxFit.cover,
                        width: double.infinity,
                        height: double.infinity,
                      );
                    },
                  )
                : Image.asset(
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

  const FooterWidget({
    super.key,
    this.songName,
    this.artists,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      flex: 131,
      child: Row(
        children: [
          TrackDetailWidget(
            songName: songName,
            artists: artists,
          ),
          const InteractionWidget(),
        ],
      ),
    );
  }
}

// ================= HeaderWidget =================
class HeaderWidget extends StatelessWidget {
  final String? username;
  final String? userImage;
  final String? trackId;

  const HeaderWidget({
    super.key,
    this.username,
    this.userImage,
    this.trackId,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      flex: 131,
      child: Row(
        children: [
          UserDetailWidget(
            username: username,
            userImage: userImage,
          ),
          SongControlWidget(
            trackId: trackId,
          ),
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
          // Row 2: 1 column (full width) - Square shape
          PostArtWidget(),
          // Row 3: 2 columns
          FooterWidget(),
        ],
      ),
    );
  }
}

// ================= Post Widget =================
class Post extends StatelessWidget {
  final String? trackId;
  final String? songName;
  final String? artists;
  final String? albumImage;
  final String? caption;
  final String username;
  final String? userImage;

  final VoidCallback? onLike;
  final VoidCallback? onComment;
  final VoidCallback? onPlay;
  final bool isLiked;
  final bool isPlaying;

  const Post({
    super.key,
    this.trackId,
    this.songName,
    this.artists,
    this.albumImage,
    this.caption,
    required this.username,
    this.userImage,
    this.onLike,
    this.onComment,
    this.onPlay,
    this.isLiked = false,
    this.isPlaying = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        children: [
          HeaderWidget(
            username: username,
            userImage: userImage,
            trackId: trackId,
          ),
          PostArtWidget(albumImage: albumImage),
          FooterWidget(
            songName: songName,
            artists: artists,
          ),
        ],
      ),
    );
  }
}
