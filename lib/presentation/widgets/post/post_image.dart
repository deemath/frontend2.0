import 'package:flutter/material.dart';

class PostImage extends StatelessWidget {
  const PostImage({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 500,
      child: Image.asset(
        'assets/images/song.png',
        fit: BoxFit.cover,
      ),
    );
  }
}
