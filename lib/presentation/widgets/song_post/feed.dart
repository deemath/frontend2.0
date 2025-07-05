import 'package:flutter/material.dart';
import './feed_bg_container.dart';
import '../../widgets/feed_post.dart';

class FeedPage extends StatelessWidget {
  const FeedPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Container(
        margin: const EdgeInsets.all(16.0),
        child: Stack(
          children: [
            // Background container with fixed aspect ratio
            AspectRatio(
              aspectRatio: 490 / 595,
              child: CustomPaint(
                painter: BackgroundContainer(),
                child: Container(),
              ),
            ),
            // Container layer on top of background
            AspectRatio(
              aspectRatio: 490 / 595, // Same aspect ratio for overlay
              child: const DemoContentWidget(),
            ),
          ],
        ),
      ),
    );
  }
}
