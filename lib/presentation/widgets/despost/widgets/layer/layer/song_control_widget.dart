import 'package:flutter/material.dart';

class SongControlWidget extends StatelessWidget {
  const SongControlWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      flex: 131,
      child: Container(
        margin: const EdgeInsets.all(4.0),
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.1),
          borderRadius: BorderRadius.circular(8.0),
          border: Border.all(color: Colors.white.withOpacity(0.3)),
        ),
        child: const Center(
          child: Text(
            'Song Control',
            style: TextStyle(
              color: Colors.white,
              fontSize: 16,
            ),
          ),
        ),
      ),
    );
  }
}
