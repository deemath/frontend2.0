import 'package:flutter/material.dart';
import 'widgets/bg_container.dart';
import 'widgets/demo_content_widget.dart';

class DemoScreen2 extends StatelessWidget {
  const DemoScreen2({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Container(
        margin: const EdgeInsets.all(16.0),
        child: Stack(
          children: [
            // Background container with fixed aspect ratio
            //this layer contains the background shape
            AspectRatio(
              aspectRatio: 496 / 455,
              child: CustomPaint(
                painter: BackgroundContainer(),
                child: Container(), // Empty child to allow layout
              ),
            ),
            // Container layer on top of background
            //squre infront of the background shape
            AspectRatio(
              aspectRatio: 496 / 455, // Same aspect ratio for overlay
              child: const DemoContentWidget(),
            ),
          ],
        ),
      ),
    );
  }// Background container with fixed aspect ratio
}

// import 'package:flutter/material.dart';
// import 'widgets/bg_container.dart';

// class DemoScreen2 extends StatelessWidget {
//   const DemoScreen2({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
      
//       backgroundColor: Colors.white,
//       body: Stack( 
//         children: [
//           AspectRatio(
//           aspectRatio: 484 / 449,
//           child: CustomPaint(
//             painter: BackgroundContainer(),
//             child: Container(), // Empty child to allow layout
//           ),
//         ),
//         ]
//       ),
//     );
//   }
// }