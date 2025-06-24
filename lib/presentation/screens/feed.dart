import 'package:flutter/material.dart';
import '../widgets/post/post_actions.dart';
import '../widgets/post/post_image.dart';
import '../widgets/post/post_details.dart';

class FeedPage extends StatelessWidget {
  const FeedPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.primary, 
      body: const Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          PostProfileDetails(),
          PostImage(),
          PostActions(),
        ],
      ),
    );
  }
}
