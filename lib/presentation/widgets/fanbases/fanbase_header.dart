import 'package:flutter/material.dart';

class PostHeader extends StatelessWidget {
  final Map<String, dynamic> post;

  const PostHeader({super.key, required this.post});

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Text Section
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                post['title'],
                style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
              ),
              const SizedBox(height: 4),
              Text(post['subtitle'], style: TextStyle(color: Theme.of(context).colorScheme.onPrimary)),
              const SizedBox(height: 4),
              GestureDetector(
                onTap: () {
                  // Add url_launcher if needed
                },
                child: Text(
                  post['url'],
                  style: const TextStyle(color: Colors.blue, fontSize: 13),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
        ),

        const SizedBox(width: 10),

        // Optional Image
        if (post['image'] != null &&
            post['image'] is List &&
            (post['image'] as List).isNotEmpty &&
            post['image'][0] is String &&
            (post['image'][0] as String).isNotEmpty)
          ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: Image.network(
              post['image'][0],
              width: 90,
              height: 70,
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) => const Icon(Icons.broken_image),
            ),
          ),
      ],
    );
  }
}
