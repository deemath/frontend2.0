import 'package:flutter/material.dart';
import 'header_widget.dart';
import 'post_art_widget.dart';
import 'footer_widget.dart';

class DemoContentWidget extends StatelessWidget {
  const DemoContentWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.black.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12.0),
        border: Border.all(
          color: Colors.black.withOpacity(0.2),
          width: 1.0,
        ),
      ),
      child: const Column(
        children: [
          // Row 1: 2 columns
          HeaderWidget(),
          // Gap between Row 1 and Row 2
          // const SizedBox(height: 5.0),
          // Row 2: 1 column (full width) - Square shape
          PostArtWidget(),
          // Gap between Row 2 and Row 3
          // const SizedBox(height: 5.0),
          // Row 3: 2 columns
          FooterWidget(),
        ],
      ),
    );
  }
}
