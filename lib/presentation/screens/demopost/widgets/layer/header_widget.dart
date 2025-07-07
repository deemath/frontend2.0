import 'package:flutter/material.dart';
import 'layer/user_detail_widget.dart';
import 'layer/song_control_widget.dart';

class HeaderWidget extends StatelessWidget {
  const HeaderWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return const Expanded(
      flex: 72,
      child: Row(
        children: [
          UserDetailWidget(),
          SongControlWidget(),
        ],
      ),
    );
  }
}
