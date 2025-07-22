import 'package:flutter/material.dart';

class PostDetailPage extends StatelessWidget {
  final String? postId;
  final String? trackId;
  final String? songName;
  final String? artists;
  final String? albumImage;
  final String? caption;
  final String? username;
  final String? userImage;
  final String? descriptionTitle;
  final String? description;
  final bool? isLiked;
  final bool? isPlaying;
  final bool? isCurrentTrack;
  final Color? backgroundColor;

  const PostDetailPage({
    Key? key,
    this.postId,
    this.trackId,
    this.songName,
    this.artists,
    this.albumImage,
    this.caption,
    this.username,
    this.userImage,
    this.descriptionTitle,
    this.description,
    this.isLiked,
    this.isPlaying,
    this.isCurrentTrack,
    this.backgroundColor,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(descriptionTitle ?? 'Post Details'),
        backgroundColor: backgroundColor ?? Colors.black,
        foregroundColor: Colors.white,
      ),
      extendBodyBehindAppBar: true,
      backgroundColor: Colors.transparent,
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              backgroundColor ?? Colors.black,
              Colors.black,
            ],
          ),
        ),
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(16.0, 100.0, 16.0, 16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // User Info Section
              Row(
                children: [
                  CircleAvatar(
                    radius: 25,
                    backgroundImage: userImage != null
                        ? (userImage!.startsWith('http')
                            ? NetworkImage(userImage!) as ImageProvider
                            : AssetImage(userImage!))
                        : const AssetImage('assets/images/profile_picture.jpg'),
                  ),
                  const SizedBox(width: 12),
                  Text(
                    username ?? 'Unknown User',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),

              // Album Art and Song Info
              if (albumImage != null) ...[
                Center(
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: Container(
                      width: 200,
                      height: 200,
                      child: albumImage!.startsWith('http')
                          ? Image.network(
                              albumImage!,
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
                ),
                const SizedBox(height: 20),
              ],

              // Post Title
              if (descriptionTitle != null) ...[
                // const Text(
                //   'Post Title:',
                //   style: TextStyle(
                //     color: Colors.white70,
                //     fontSize: 14,
                //     fontWeight: FontWeight.w500,
                //   ),
                // ),
                // const SizedBox(height: 4),
                Text(
                  descriptionTitle!,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 16),
              ],

              // Post Description
              if (description != null) ...[
                // const Text(
                //   'Description:',
                //   style: TextStyle(
                //     color: Colors.white70,
                //     fontSize: 14,
                //     fontWeight: FontWeight.w500,
                //   ),
                // ),
                // const SizedBox(height: 4),
                Text(
                  description!,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    height: 1.4,
                  ),
                ),
                const SizedBox(height: 16),
              ],

              // Song Details
              if (songName != null) ...[
                const Text(
                  'Song:',
                  style: TextStyle(
                    color: Colors.white70,
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  songName!,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 16),
              ],

              if (artists != null) ...[
                const Text(
                  'Artist(s):',
                  style: TextStyle(
                    color: Colors.white70,
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  artists!,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                  ),
                ),
                const SizedBox(height: 16),
              ],

              // Caption
              if (caption != null) ...[
                const Text(
                  'Caption:',
                  style: TextStyle(
                    color: Colors.white70,
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  caption!,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    height: 1.4,
                  ),
                ),
                const SizedBox(height: 16),
              ],

              // Post Status
              Row(
                children: [
                  if (isLiked == true) ...[
                    const Icon(
                      Icons.favorite,
                      color: Colors.red,
                      size: 20,
                    ),
                    const SizedBox(width: 8),
                    const Text(
                      'Liked',
                      style: TextStyle(color: Colors.white70),
                    ),
                    const SizedBox(width: 16),
                  ],
                  if (isPlaying == true) ...[
                    const Icon(
                      Icons.play_circle,
                      color: Colors.green,
                      size: 20,
                    ),
                    const SizedBox(width: 8),
                    const Text(
                      'Playing',
                      style: TextStyle(color: Colors.white70),
                    ),
                  ],
                ],
              ),

              const SizedBox(height: 20),

              // Color info display
              // if (backgroundColor != null) ...[
              //   Container(
              //     padding: const EdgeInsets.all(12),
              //     decoration: BoxDecoration(
              //       color: Colors.white.withOpacity(0.1),
              //       borderRadius: BorderRadius.circular(8),
              //     ),
              //     child: Column(
              //       crossAxisAlignment: CrossAxisAlignment.start,
              //       children: [
              //         const Text(
              //           'Theme Color:',
              //           style: TextStyle(
              //             color: Colors.white70,
              //             fontSize: 14,
              //             fontWeight: FontWeight.bold,
              //           ),
              //         ),
              //         const SizedBox(height: 8),
              //         Row(
              //           children: [
              //             Container(
              //               width: 40,
              //               height: 40,
              //               decoration: BoxDecoration(
              //                 color: backgroundColor,
              //                 borderRadius: BorderRadius.circular(8),
              //                 border: Border.all(color: Colors.white24),
              //               ),
              //             ),
              //             const SizedBox(width: 12),
              //             Text(
              //               'Generated from album art',
              //               style: const TextStyle(
              //                 color: Colors.white70,
              //                 fontSize: 12,
              //               ),
              //             ),
              //           ],
              //         ),
              //       ],
              //     ),
              //   ),
              //   const SizedBox(height: 16),
              // ],

              // Debug Info (you can remove this in production)
              // if (postId != null) ...[
              //   Container(
              //     padding: const EdgeInsets.all(12),
              //     decoration: BoxDecoration(
              //       color: Colors.grey[900],
              //       borderRadius: BorderRadius.circular(8),
              //     ),
              //     child: Column(
              //       crossAxisAlignment: CrossAxisAlignment.start,
              //       children: [
              //         const Text(
              //           'Debug Info:',
              //           style: TextStyle(
              //             color: Colors.white70,
              //             fontSize: 12,
              //             fontWeight: FontWeight.bold,
              //           ),
              //         ),
              //         const SizedBox(height: 4),
              //         Text(
              //           'Post ID: $postId',
              //           style: const TextStyle(
              //             color: Colors.white70,
              //             fontSize: 12,
              //           ),
              //         ),
              //         if (trackId != null)
              //           Text(
              //             'Track ID: $trackId',
              //             style: const TextStyle(
              //               color: Colors.white70,
              //               fontSize: 12,
              //             ),
              //           ),
              //       ],
              //     ),
              //   ),
              // ],
            ],
          ),
        ),
      ),
    );
  }
}
