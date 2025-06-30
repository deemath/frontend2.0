import 'package:flutter/material.dart';

class RowThreeWidget extends StatelessWidget {
  const RowThreeWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      flex: 73,
      child: Row(
        children: [
          Expanded(
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
                  'Row 3, Col 1',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                  ),
                ),
              ),
            ),
          ),
          Expanded(
            flex: 131,
            child: Container(
              margin: const EdgeInsets.all(4.0),
              decoration: BoxDecoration(
                color: Colors.black.withOpacity(0.1),
                borderRadius: BorderRadius.circular(8.0),
                border: Border.all(color: Colors.black.withOpacity(0.3)),
              ),
              child: const Center(
                child: Text(
                  'Row 3, Col 2',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
