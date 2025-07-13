import 'package:flutter/material.dart';
import '../../../widgets/profile/profile_stat_column.dart';

class AlbumArtPostsTab extends StatelessWidget {
  final String username;
  final int posts;
  final int followers;
  final int following;
  final List<String> albumImages;
  final String description;
  final bool showGrid;
  final String? profileImage;

  const AlbumArtPostsTab({
    Key? key,
    required this.username,
    required this.posts,
    required this.followers,
    required this.following,
    required this.albumImages,
    required this.description,
    this.showGrid = true,
    this.profileImage,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          if (!showGrid) ...[
            Padding(
              padding:
                  const EdgeInsets.symmetric(vertical: 24.0, horizontal: 16.0),
              child: Row(
                children: [
                  CircleAvatar(
                    radius: 44,
                    backgroundImage:
                        profileImage != null && profileImage!.isNotEmpty
                            ? NetworkImage(profileImage!)
                            : const AssetImage('assets/images/hehe.png')
                                as ImageProvider,
                  ),
                  Expanded(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        ProfileStatColumn(label: 'Posts', count: posts),
                        ProfileStatColumn(label: 'Followers', count: followers),
                        ProfileStatColumn(label: 'Following', count: following),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      username,
                      style: const TextStyle(
                          fontWeight: FontWeight.bold, fontSize: 18),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      description,
                      style: const TextStyle(fontSize: 15),
                    ),
                  ],
                ),
              ),
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
