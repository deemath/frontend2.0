import 'package:flutter/material.dart';

class PostActions extends StatelessWidget {
  const PostActions({super.key});

  @override
  Widget build(BuildContext context) {
    final iconColor = Theme.of(context).colorScheme.onPrimary;

    return Padding(
      padding: const EdgeInsets.only(left: 12, top: 12),
      child: Row(
        children: [
          IconButton(
            icon: Icon(Icons.favorite_border, size: 32, color: iconColor),
            onPressed: () {
              // Add like functionality
            },
          ),
          IconButton(
            icon: Icon(Icons.chat_outlined, size: 32, color: iconColor),
            onPressed: () {
              // Add comment functionality
            },
          ),
          IconButton(
            icon: Icon(Icons.share, size: 32, color: iconColor),
            onPressed: () {
              // Add share functionality
            },
          ),
        ],
      ),
    );
  }
}
