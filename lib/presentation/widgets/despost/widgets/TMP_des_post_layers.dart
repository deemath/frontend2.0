import 'package:flutter/material.dart';
import 'package:auto_size_text/auto_size_text.dart';

// ========== HeaderWidget ==========
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
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Expanded(
          child: UserDetailWidget(
            username: username,
            userImage: userImage,
          ),
        ),
        const SongControlWidget(),
      ],
    );
  }
}

// ========== UserDetailWidget ==========
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
    final brightness = Theme.of(context).brightness;
    final isDark = brightness == Brightness.dark;
    final textColor = isDark ? Colors.white : Colors.black;

    return Row(
      children: [
        Container(
          width: 40,
          height: 40,
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
        const SizedBox(width: 12),
        Expanded(
          child: AutoSizeText(
            username ?? 'Unknown User',
            style: TextStyle(
              color: textColor,
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
      ],
    );
  }
}

class PostArtWidget extends StatefulWidget {
  final String? albumImage;
  final String? title;
  final String? description;

  const PostArtWidget({
    super.key,
    this.albumImage,
    this.title,
    this.description,
  });

  @override
  State<PostArtWidget> createState() => _PostArtWidgetState();
}

class _PostArtWidgetState extends State<PostArtWidget> {
  bool _showFull = false;

  @override
  Widget build(BuildContext context) {
    final description = widget.description ?? '';
    final title = widget.title ?? '';
    const fixedFontSize = 14.0;

    final descriptionStyle = const TextStyle(
      color: Colors.white70,
      fontSize: fixedFontSize,
      height: 1.4,
    );

    // Truncate title and description
    String displayTitle =
        title.length > 30 ? title.substring(0, 30) + '...' : title;
    String displayDescription = description.length > 100
        ? description.substring(0, 100) + '...'
        : description;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 16.0),
      child: LayoutBuilder(
        builder: (context, constraints) {
          final double totalWidth = constraints.maxWidth;
          final double imageSize = totalWidth * 0.20;
          // final double textWidth = totalWidth - imageSize - 12;

          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Top row: image + title + side text
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Album image
                  ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: Container(
                      width: imageSize,
                      height: imageSize,
                      color: Colors.grey.shade800,
                      child: widget.albumImage != null &&
                              widget.albumImage!.startsWith('http')
                          ? Image.network(
                              widget.albumImage!,
                              fit: BoxFit.cover,
                              errorBuilder: (_, __, ___) => Image.asset(
                                'assets/images/song.png',
                                fit: BoxFit.cover,
                              ),
                            )
                          : Image.asset(
                              'assets/images/song.png',
                              fit: BoxFit.cover,
                            ),
                    ),
                  ),
                  const SizedBox(width: 12),

                  // Right side text
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        AutoSizeText(
                          displayTitle,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: 6),
                        AutoSizeText(
                          displayDescription,
                          style: descriptionStyle,
                          maxLines: 3,
                          minFontSize: 12,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          );
        },
      ),
    );
  }
}

// ========== FooterWidget ==========
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
    return Row(
      children: [
        const SizedBox(width: 8),
        Expanded(
          flex: 3,
          child: TrackDetailWidget(
            songName: songName,
            artists: artists,
          ),
        ),
        const SizedBox(width: 8),
        const Flexible(
          flex: 1,
          child: InteractionWidget(),
        ),
      ],
    );
  }
}

// ========== TrackDetailWidget ==========
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
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          songName ?? '',
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 14,
          ),
          overflow: TextOverflow.ellipsis,
          maxLines: 1,
        ),
        const SizedBox(height: 2),
        Text(
          artists ?? '',
          style: TextStyle(
            fontSize: 13,
            color: Colors.grey[600],
          ),
          overflow: TextOverflow.ellipsis,
          maxLines: 1,
        ),
      ],
    );
  }
}

// ========== SongControlWidget ==========
class SongControlWidget extends StatefulWidget {
  final String? trackId;
  final bool isPlaying;
  final bool isCurrentTrack;
  final VoidCallback? onPlayPause;

  const SongControlWidget({
    super.key,
    this.trackId,
    this.isPlaying = false,
    this.isCurrentTrack = false,
    this.onPlayPause,
  });

  @override
  State<SongControlWidget> createState() => _SongControlWidgetState();
}

class _SongControlWidgetState extends State<SongControlWidget> {
  @override
  Widget build(BuildContext context) {
    const iconColor = Colors.white;

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Image.network(
          'https://cdn-icons-png.flaticon.com/512/174/174872.png',
          width: 24,
          height: 24,
          color: iconColor,
          errorBuilder: (context, error, stackTrace) {
            return const Icon(
              Icons.music_note,
              color: iconColor,
              size: 24,
            );
          },
        ),
        const SizedBox(width: 8),
        if (widget.onPlayPause != null)
          GestureDetector(
            onTap: widget.onPlayPause,
            child: Icon(
              widget.isCurrentTrack && widget.isPlaying
                  ? Icons.pause
                  : Icons.play_arrow,
              color: iconColor,
              size: 24,
            ),
          ),
      ],
    );
  }
}

// ========== InteractionWidget ==========
class InteractionWidget extends StatelessWidget {
  final VoidCallback? onLike;
  final VoidCallback? onComment;
  final VoidCallback? onShare;
  final bool isLiked;
  final int likesCount;
  final int commentsCount;

  const InteractionWidget({
    super.key,
    this.onLike,
    this.onComment,
    this.onShare,
    this.isLiked = false,
    this.likesCount = 0,
    this.commentsCount = 0,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final iconColor = isDark ? Colors.white : Colors.black;
    final likedColor = isDark ? Colors.purple : Colors.deepPurple;
    final textColor = isDark ? Colors.white : Colors.black;

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        GestureDetector(
          onTap: onLike,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                isLiked ? Icons.favorite : Icons.favorite_border,
                color: isLiked ? likedColor : iconColor,
                size: 18,
              ),
              if (likesCount > 0)
                Text(
                  '$likesCount',
                  style: TextStyle(
                    color: textColor,
                    fontSize: 9,
                  ),
                ),
            ],
          ),
        ),
        const SizedBox(width: 12),
        GestureDetector(
          onTap: onComment,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                Icons.comment_outlined,
                color: iconColor,
                size: 18,
              ),
              if (commentsCount > 0)
                Text(
                  '$commentsCount',
                  style: TextStyle(
                    color: textColor,
                    fontSize: 9,
                  ),
                ),
            ],
          ),
        ),
        const SizedBox(width: 12),
        GestureDetector(
          onTap: onShare,
          child: Icon(
            Icons.share,
            color: iconColor,
            size: 18,
          ),
        ),
      ],
    );
  }
}
