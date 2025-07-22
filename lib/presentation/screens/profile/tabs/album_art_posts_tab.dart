import 'package:flutter/material.dart';
import '../../../widgets/profile/profile_stat_column.dart';
import '../../../widgets/profile/profile_header.dart';

class AlbumArtPostsTab extends StatelessWidget {
  final String username;
  final String fullName;
  final int posts;
  final int followers;
  final int following;
  final List<String> albumImages;
  final String description;
  final bool showGrid;
  final String? profileImage;
  final VoidCallback? onFollowersTap;
  final VoidCallback? onFollowingTap;

  const AlbumArtPostsTab({
    Key? key,
    required this.username,
    required this.fullName,
    required this.posts,
    required this.followers,
    required this.following,
    required this.albumImages,
    required this.description,
    this.showGrid = true,
    this.profileImage,
    this.onFollowersTap,
    this.onFollowingTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          if (!showGrid) ...[
            ProfileHeader(
              username: username,
              fullName: fullName,
              posts: posts,
              followers: followers,
              following: following,
              profileImage: profileImage,
              description: description,
              onFollowersTap: onFollowersTap,
              onFollowingTap: onFollowingTap,
            ),
          ],
          if (showGrid) ...[
            const SizedBox(height: 16),
            albumImages.isEmpty
                ? const Padding(
                    padding: EdgeInsets.all(32.0),
                    child: Center(
                      child: Text(
                        'No album arts to display.',
                        style: TextStyle(color: Colors.white54),
                      ),
                    ),
                  )
                : GridView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: albumImages.length,
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 3,
                      mainAxisSpacing: 2,
                      crossAxisSpacing: 2,
                      childAspectRatio: 1,
                    ),
                    itemBuilder: (context, index) {
                      return Image.network(
                        albumImages[index],
                        fit: BoxFit.cover,
                      );
                    },
                  ),
          ],
        ],
      ),
    );
  }
}
