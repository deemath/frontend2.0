import 'package:flutter/material.dart';

class PostShape extends CustomPainter {
  final Color backgroundColor;

  PostShape({this.backgroundColor = const Color(0xff423E4E)});

  @override
  void paint(Canvas canvas, Size size) {
    // Configure paint with the background color provided
    Paint paint = Paint()
      ..color = backgroundColor
      ..style = PaintingStyle.fill;
    Path path = Path();

    // Path number 1
    path = Path();
    path.lineTo(size.width * 0.69, size.height * 0.09);
    path.cubicTo(size.width * 0.71, size.height * 0.09, size.width * 0.73,
        size.height * 0.08, size.width * 0.73, size.height * 0.06);
    path.cubicTo(size.width * 0.73, size.height * 0.06, size.width * 0.73,
        size.height * 0.03, size.width * 0.73, size.height * 0.03);
    path.cubicTo(size.width * 0.73, size.height * 0.01, size.width * 0.75, 0,
        size.width * 0.77, 0);
    path.cubicTo(
        size.width * 0.77, 0, size.width * 0.96, 0, size.width * 0.96, 0);
    path.cubicTo(size.width * 0.98, 0, size.width, size.height * 0.01,
        size.width, size.height * 0.03);
    path.cubicTo(size.width, size.height * 0.03, size.width, size.height * 0.87,
        size.width, size.height * 0.87);
    path.cubicTo(size.width, size.height * 0.89, size.width * 0.98,
        size.height * 0.91, size.width * 0.96, size.height * 0.91);
    path.cubicTo(size.width * 0.96, size.height * 0.91, size.width * 0.77,
        size.height * 0.91, size.width * 0.77, size.height * 0.91);
    path.cubicTo(size.width * 0.75, size.height * 0.91, size.width * 0.73,
        size.height * 0.92, size.width * 0.73, size.height * 0.94);
    path.cubicTo(size.width * 0.73, size.height * 0.94, size.width * 0.73,
        size.height * 0.97, size.width * 0.73, size.height * 0.97);
    path.cubicTo(size.width * 0.73, size.height, size.width * 0.71, size.height,
        size.width * 0.69, size.height);
    path.cubicTo(size.width * 0.69, size.height, size.width * 0.04, size.height,
        size.width * 0.04, size.height);
    path.cubicTo(
        size.width * 0.02, size.height, 0, size.height, 0, size.height * 0.97);
    path.cubicTo(
        0, size.height * 0.97, 0, size.height * 0.12, 0, size.height * 0.12);
    path.cubicTo(0, size.height * 0.11, size.width * 0.02, size.height * 0.09,
        size.width * 0.04, size.height * 0.09);
    path.cubicTo(size.width * 0.04, size.height * 0.09, size.width * 0.69,
        size.height * 0.09, size.width * 0.69, size.height * 0.09);
    path.close(); // Close the path for proper rendering

    // Draw the path with the background color from feed_widget.dart
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant PostShape oldDelegate) {
    // Repaint if the background color changes
    return backgroundColor != oldDelegate.backgroundColor;
  }
}
