import 'package:flutter/material.dart';

class PostActions extends StatelessWidget {
  final Map<String, dynamic> post;

  const PostActions({super.key, required this.post});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        Row(
          children: [
            const Icon(Icons.arrow_upward),
            const SizedBox(width: 4),
            Text('${post['votes'] ~/ 1000}K'),
          ],
        ),
        Row(
          children: [
            const Icon(Icons.mode_comment_outlined),
            const SizedBox(width: 4),
            Text('${post['comments'] ~/ 1000}K'),
          ],
        ),
        Row(
          children: [
            const Icon(Icons.emoji_events_outlined),
            const SizedBox(width: 4),
            Text('${post['award']}'),
          ],
        ),
        const Icon(Icons.share_outlined),
      ],
    );
  }
}
