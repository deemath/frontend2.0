import 'package:flutter/material.dart';

class DescriptionPostsTab extends StatelessWidget {
  const DescriptionPostsTab({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Text(
        'Description-based posts will appear here.',
        style: TextStyle(color: Colors.white),
      ),
    );
  }
}
