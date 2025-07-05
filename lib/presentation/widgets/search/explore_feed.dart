import 'package:flutter/material.dart';

class ExploreFeed extends StatelessWidget {
  final List<String> imageUrls;

  const ExploreFeed({Key? key, required this.imageUrls}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      padding: const EdgeInsets.all(4),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        mainAxisSpacing: 4,
        crossAxisSpacing: 4,
        childAspectRatio: 0.8,
      ),
      itemCount: imageUrls.length,
      itemBuilder: (context, index) {
        return GestureDetector(
          onTap: () {
            // TODO: Open post or reel details
          },
          child: Image.asset(
            imageUrls[index],
            fit: BoxFit.cover,
          ),
        );
      },
    );
  }
}
