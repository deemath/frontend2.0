import 'package:flutter/material.dart';
import 'fanbase_post_layers.dart';

// ========== Post ==========
class Post extends StatelessWidget {
  final String trackId;
  final String postId;
  final String songName;
  final String artists;
  final String albumImage;
  final String caption;
  final String username;
  final String userImage;
  final String descriptionTitle;
  final String description;
  final VoidCallback? onLike;
  final VoidCallback? onComment;
  final VoidCallback? onShare;
  final VoidCallback? onPlayPause;
  final VoidCallback? onUsernameTap;
  final bool isLiked;
  final bool isPlaying;
  final bool isCurrentTrack;
  final Color backgroundColor;

  const Post({
    super.key,
    this.trackId = '',
    this.postId = '',
    this.songName = '',
    this.artists = '',
    this.albumImage = '',
    this.caption = '',
    required this.username,
    this.userImage = '',
    this.descriptionTitle = '',
    this.description = '',
    this.onLike,
    this.onComment,
    this.onShare,
    this.onPlayPause,
    this.onUsernameTap,
    this.isLiked = false,
    this.isPlaying = false,
    this.isCurrentTrack = false,
    this.backgroundColor = Colors.black,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        HeaderWidget(
          username: username,
          userImage: userImage,
          trackId: trackId,
        ),
        PostArtWidget(
          albumImage: albumImage,
          title: descriptionTitle,
          description: description,
          postId: postId,
          trackId: trackId,
          songName: songName,
          artists: artists,
          comments: [],
          username: username,
          userImage: userImage,
          isLiked: isLiked,
          isPlaying: isPlaying,
          isCurrentTrack: isCurrentTrack,
          backgroundColor: backgroundColor,
        ),
        FooterWidget(
          songName: songName,
          artists: artists,
        ),
      ],
    );
  }
}
