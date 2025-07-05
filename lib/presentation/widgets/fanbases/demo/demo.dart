import 'package:flutter/material.dart';

import './demo_content_widget.dart';
import './bg_container.dart';

class DemoScreen extends StatelessWidget {
  const DemoScreen({super.key});

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
              aspectRatio: 0.8235294118, // 490 / 595 as a constant double
              child: CustomPaint(
                painter: BackgroundContainer(),
                child: Container(),
              ),
            ),
            // Container layer on top of background
            const AspectRatio(
              aspectRatio: 0.8235294118, // 490 / 595 as a constant double
              child: DemoContentWidget(),
            ),
          ],
        ),
      ),
    );
  }
}
