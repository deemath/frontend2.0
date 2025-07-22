import 'package:flutter/material.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:flutter_svg/flutter_svg.dart';

// ================= SongControlWidget =================
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
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final pillColor = isDark ? Colors.black : Colors.white;
    final iconColor = isDark ? Colors.white : Colors.black;
    final spotifyAsset = isDark
        ? 'assets/icons/icons-spotify-dark.svg'
        : 'assets/icons/icons-spotify-light.svg';

    return Expanded(
      flex: 110,
      child: Container(
        margin: const EdgeInsets.only(top: 5.0, left: 5.0, right: 5.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: Container(
                // ADD A WAY TO MAINTAIN HEIGHT WITH RESPECTIVE TO PARENT WIDGET
                decoration: BoxDecoration(
                  color: pillColor,
                  borderRadius: BorderRadius.circular(14.0), // pill shape
                ),
                padding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                child: Row(
                  children: [
                    // Spotify icon SVG
                    // Image.network(
                    //   'https://cdn-icons-png.flaticon.com/512/174/174872.png',
                    //   width: 24,
                    //   height: 24,
                    //   color: iconColor,
                    //   errorBuilder: (context, error, stackTrace) {
                    //     return Icon(
                    //       Icons.music_note,
                    //       color: iconColor,
                    //       size: 24,
                    //     );
                    //   },
                    // ),
                    SizedBox(
                      width: 22,
                      height: 22,
                      child: SvgPicture.asset(
                        spotifyAsset,
                        fit: BoxFit.contain,
                      ),
                    ),
                    const Spacer(),
                    if (widget.onPlayPause != null)
                      GestureDetector(
                        onTap: widget.onPlayPause,
                        child: Container(
                          decoration: BoxDecoration(
                            color: pillColor,
                            borderRadius: BorderRadius.circular(32.0),
                          ),
                          // padding: const EdgeInsets.symmetric(
                          //     horizontal: 8, vertical: 4),
                          child: Icon(
                            widget.isCurrentTrack && widget.isPlaying
                                ? LucideIcons.pause
                                : LucideIcons.play,
                            color: iconColor,
                            size: 22,
                          ),
                        ),
                      ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ================= TrackDetailWidget =================
class TrackDetailWidget extends StatefulWidget {
  final String? songName;
  final String? artists;
  final String? caption;

  const TrackDetailWidget({
    super.key,
    this.songName,
    this.artists,
    this.caption,
  });

  @override
  State<TrackDetailWidget> createState() => _TrackDetailWidgetState();
}

class _TrackDetailWidgetState extends State<TrackDetailWidget> {
  bool _showFullCaption = false;

  @override
  Widget build(BuildContext context) {
    // Always use white for song/artist, white70 for caption
    final textColor = Colors.white;
    final captionColor = Colors.white70;
    return Expanded(
      flex: 300,
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 4.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Song name and artist on one line
            Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      AutoSizeText(
                        widget.songName ?? 'Unknown Track',
                        style: TextStyle(
                          color: textColor,
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                        ),
                        minFontSize: 8,
                        maxFontSize: 14,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        textAlign: TextAlign.left,
                      ),
                      AutoSizeText(
                        widget.artists != null
                            ? (widget.artists!.length > 20
                                ? '${widget.artists!.substring(0, 20)}...'
                                : widget.artists!)
                            : 'Unknown Artist',
                        style: TextStyle(
                          color: textColor.withOpacity(0.8),
                          fontSize: 11,
                          fontWeight: FontWeight.w400,
                        ),
                        minFontSize: 8,
                        maxFontSize: 13,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        textAlign: TextAlign.left,
                      ),
                    ],
                  ),
                ),
              ],
            ),
            // Caption with see more functionality
            if (widget.caption != null && widget.caption!.isNotEmpty) ...[
              const SizedBox(height: 4),
              _buildCaptionText(captionColor),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildCaptionText(Color captionColor) {
    const int maxChars = 50; // Limit for showing "see more"
    final caption = widget.caption!;

    if (caption.length <= maxChars || _showFullCaption) {
      return Text(
        caption,
        style: TextStyle(
          color: captionColor,
          fontSize: 10,
          fontWeight: FontWeight.w300,
        ),
        textAlign: TextAlign.left,
      );
    } else {
      return Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Text(
              '${caption.substring(0, maxChars)}...',
              style: TextStyle(
                color: captionColor,
                fontSize: 10,
                fontWeight: FontWeight.w300,
              ),
              textAlign: TextAlign.left,
            ),
          ),
          GestureDetector(
            onTap: () {
              setState(() {
                _showFullCaption = true;
              });
            },
            child: const Text(
              'see more',
              style: TextStyle(
                color: Colors.purple,
                fontSize: 10,
                fontWeight: FontWeight.w500,
                decoration: TextDecoration.underline,
              ),
            ),
          ),
        ],
      );
    }
  }
}

// ================= UserDetailWidget =================
class UserDetailWidget extends StatelessWidget {
  final Map<String, dynamic>? details;
  final String? username;
  final String? userImage;
  final VoidCallback? onUsernameTap; // <-- Add this

  const UserDetailWidget({
    super.key,
    this.details,
    this.username,
    this.userImage,
    this.onUsernameTap, // <-- Add this
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final textColor = isDark ? Colors.white : Colors.black;
    return Expanded(
      flex: 300,
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
                child: GestureDetector(
                  onTap: onUsernameTap, // <-- Make username clickable
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
  final VoidCallback? onShare;
  final bool isLiked;

  const InteractionWidget({
    super.key,
    this.onLike,
    this.onComment,
    this.onShare,
    this.isLiked = false,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final iconColor = isDark ? Colors.white : Colors.black;
    final likedColor = isDark ? Colors.purple : Colors.deepPurple;
    final textColor = isDark ? Colors.white : Colors.black;
    return Expanded(
      flex: 140,
      child: Container(
        margin: const EdgeInsets.all(4.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.end,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Like button
            GestureDetector(
              onTap: onLike,
              child: SizedBox(
                // height: 32,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // Icon(
                    //   LucideIcons.heart,
                    //   color: isLiked ? likedColor : iconColor,
                    //   size: 22,
                    // ),
                    Icon(
                      isLiked ? Icons.favorite : Icons.favorite_border,
                      color: isLiked ? likedColor : iconColor,
                      size: 24,
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(width: 14),
            // Comment button
            GestureDetector(
              onTap: onComment,
              child: SizedBox(
                // height: 32,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      LucideIcons.messageCircle,
                      color: iconColor,
                      size: 22,
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(width: 14),
            // Share button
            GestureDetector(
              onTap: onShare,
              child: SizedBox(
                // height: 48,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      LucideIcons.share2,
                      color: iconColor,
                      size: 22,
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(width: 14),
          ],
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
            top: 15.0,
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
  final String? caption;
  final VoidCallback? onLike;
  final VoidCallback? onComment;
  final VoidCallback? onShare;
  final bool isLiked;
  final int likeCount;
  final int commentCount;

  const FooterWidget({
    super.key,
    this.songName,
    this.artists,
    this.caption,
    this.onLike,
    this.onComment,
    this.onShare,
    this.isLiked = false,
    this.likeCount = 0,
    this.commentCount = 0,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      flex: 140,
      child: Row(
        children: [
          TrackDetailWidget(
            songName: songName,
            artists: artists,
            caption: caption,
          ),
          InteractionWidget(
            onLike: onLike,
            onComment: onComment,
            onShare: onShare,
            isLiked: isLiked,
          ),
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
  final bool isPlaying;
  final bool isCurrentTrack;
  final VoidCallback? onPlayPause;
  final VoidCallback? onUsernameTap; // <-- Add this

  const HeaderWidget({
    super.key,
    this.username,
    this.userImage,
    this.trackId,
    this.isPlaying = false,
    this.isCurrentTrack = false,
    this.onPlayPause,
    this.onUsernameTap, // <-- Add this
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      flex: 120,
      child: Row(
        children: [
          UserDetailWidget(
            username: username,
            userImage: userImage,
            onUsernameTap: onUsernameTap, // <-- Pass callback
          ),
          SongControlWidget(
            trackId: trackId,
            isPlaying: isPlaying,
            isCurrentTrack: isCurrentTrack,
            onPlayPause: onPlayPause,
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
  final VoidCallback? onShare;
  final VoidCallback? onPlayPause;
  final VoidCallback? onUsernameTap;
  final bool isLiked;
  final bool isPlaying;
  final bool isCurrentTrack;
  final int likeCount;
  final int commentCount;

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
    this.onShare,
    this.onPlayPause,
    this.onUsernameTap,
    this.isLiked = false,
    this.isPlaying = false,
    this.isCurrentTrack = false,
    this.likeCount = 0,
    this.commentCount = 0,
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
            isPlaying: isPlaying,
            isCurrentTrack: isCurrentTrack,
            onPlayPause: onPlayPause,
            onUsernameTap: onUsernameTap, // <-- Pass callback
          ),
          PostArtWidget(albumImage: albumImage),
          FooterWidget(
            songName: songName,
            artists: artists,
            //caption: caption,
            onLike: onLike,
            onComment: onComment,
            onShare: onShare,
            isLiked: isLiked,
            likeCount: likeCount,
            commentCount: commentCount,
          ),
        ],
      ),
    );
  }
}
