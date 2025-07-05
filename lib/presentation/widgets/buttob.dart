import 'package:flutter/material.dart';

class CustomBottomBar extends StatelessWidget {
  final VoidCallback onSharePost;
  final VoidCallback onShareThoughts;

  const CustomBottomBar({
    Key? key,
    required this.onSharePost,
    required this.onShareThoughts,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Custom purple color
    const Color customPurple = Color(0xFF8E08EF);

    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: ElevatedButton(
              onPressed: onSharePost,
              style: ElevatedButton.styleFrom(
                backgroundColor: customPurple,
                foregroundColor: Colors.white,
                textStyle: const TextStyle(fontWeight: FontWeight.bold),
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: Text('Share Post'),
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: ElevatedButton(
              onPressed: onShareThoughts,
              style: ElevatedButton.styleFrom(
                backgroundColor: customPurple,
                foregroundColor: Colors.white,
                textStyle: const TextStyle(fontWeight: FontWeight.bold),
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: Text('Share Thoughts'),
            ),
          ),
        ],
      ),
    );
  }
}
