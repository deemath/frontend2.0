import 'package:flutter/material.dart';
import 'layer/track_detail_widget.dart';
import 'layer/interaction_widget.dart';

class FooterWidget extends StatelessWidget {
  const FooterWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return const Expanded(
      flex: 73,
      child: Row(
        children: [
          TrackDetailWidget(),
          InteractionWidget(),
        ],
      ),
    );
  }
}
