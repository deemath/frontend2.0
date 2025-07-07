import 'package:flutter/material.dart';

class TrackDetailWidget extends StatelessWidget {
  const TrackDetailWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      flex: 359,
      child: Container(
        margin: const EdgeInsets.all(4.0),
        decoration: BoxDecoration(
          color: Colors.black.withOpacity(0.1),
          borderRadius: BorderRadius.circular(8.0),
          border: Border.all(color: Colors.black.withOpacity(0.3)),
        ),
        child: const Center(
          child: Text(
            'Track Details',
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
