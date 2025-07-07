import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';

class FanbaseInterations extends StatelessWidget {
  final int numLikes;
  final int numPosts;
  final int numShares;

  const FanbaseInterations({
    required this.numLikes,
    required this.numPosts,
    required this.numShares,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Container(
          child: Row(
            children: [
              Icon(LucideIcons.heart, color: Theme.of(context).colorScheme.onPrimary, size: 16.0),
              const SizedBox(width: 8.0),
              Text(
                '$numLikes Likes',
                style: TextStyle(
                  color: Theme.of(context).colorScheme.onPrimary,
                  fontSize: 14.5,
                ),
              ),
            ],
          ),
        ),
        Container(
          child: Row(
            children: [
              const SizedBox(width: 16.0),
              Icon(LucideIcons.messageSquare, color: Theme.of(context).colorScheme.onPrimary, size: 16.0),
              const SizedBox(width: 8.0),
              Text(
                '$numPosts Posts',
                style: TextStyle(
                  color: Theme.of(context).colorScheme.onPrimary,
                  fontSize: 14.5, 
                ),
              ),
            ],
          ),
        ),
        Container(
          child: Row(
            children: [
              const SizedBox(width: 16.0),
              Icon(LucideIcons.share, color: Theme.of(context).colorScheme.onPrimary,
                  size: 16.0),
              const SizedBox(width: 8.0),
              Text(
                '$numShares Shares',
                style: TextStyle(   
                  color: Theme.of(context).colorScheme.onPrimary,
                  fontSize: 14.5,
                ),
              ),
            ],
          ),
        )
        
        
      ],
    );
  }
}
