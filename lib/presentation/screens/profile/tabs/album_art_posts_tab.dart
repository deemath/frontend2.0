import 'package:flutter/material.dart';
import '../../../widgets/profile/profile_stat_column.dart';

class AlbumArtPostsTab extends StatelessWidget {
  final String username;
  final int posts;
  final int followers;
  final int following;
  final List<String> albumArts;
  final String description;
  final bool showGrid;

  const AlbumArtPostsTab({
    Key? key,
    required this.username,
    required this.posts,
    required this.followers,
    required this.following,
    required this.albumArts,
    required this.description,
    this.showGrid = true,
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
                    backgroundImage: AssetImage('assets/images/hehe.png'),
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
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                    ),
                    SizedBox(height: 6),
                    Text(
                      description,
                      style: TextStyle(fontSize: 15),
                    ),
                  ],
                ),
              ),
            ),
          ],
          if (showGrid) ...[
            SizedBox(height: 16),
            GridView.builder(
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(),
              itemCount: albumArts.length,
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3,
                mainAxisSpacing: 2,
                crossAxisSpacing: 2,
                childAspectRatio: 1,
              ),
              itemBuilder: (context, index) {
                return Image.network(
                  albumArts[index],
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
