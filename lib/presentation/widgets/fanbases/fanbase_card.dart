import 'package:flutter/material.dart';
import 'fanbase_header.dart';
import 'fanbase_actions.dart';

class FanbaseCard extends StatelessWidget {
  final Map<String, dynamic> post;

  const FanbaseCard({super.key, required this.post});

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Theme.of(context).colorScheme.primary,
      margin: const EdgeInsets.only(bottom: 16),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      elevation: 3,
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          children: [
            PostHeader(post: post),
            const SizedBox(height: 10),
            PostActions(post: post),
          ],
        ),
      ),
    );
  }
}
