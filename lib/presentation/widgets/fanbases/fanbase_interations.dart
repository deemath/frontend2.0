import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';

class FanbaseInterations extends StatelessWidget {
  final int numLikes;
  final int numPosts;
  final bool isLiked;
  final bool isLikeLoading;
  final VoidCallback? onLikeTap;

  const FanbaseInterations({
    required this.numLikes,
    required this.numPosts,
    required this.isLiked,
    this.isLikeLoading = false,
    this.onLikeTap,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        GestureDetector(
          onTap: onLikeTap,
          child: Container(
            child: Row(
              children: [
                isLikeLoading
                    ? SizedBox(
                        width: 16,
                        height: 16,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          valueColor: AlwaysStoppedAnimation<Color>(
                            Theme.of(context).colorScheme.onPrimary,
                          ),
                        ),
                      )
                    : Icon(
                        isLiked ? Icons.favorite : Icons.favorite_border,
                        color: isLiked ? Colors.purple : Theme.of(context).colorScheme.onPrimary,
                        size: 16.0,
                      ),
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
        ),
        Container(
          child: Row(
            children: [
              const SizedBox(width: 16.0),
              Icon(LucideIcons.messageSquare,
                  color: Theme.of(context).colorScheme.onPrimary, size: 16.0),
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
      ],
    );
  }
}
