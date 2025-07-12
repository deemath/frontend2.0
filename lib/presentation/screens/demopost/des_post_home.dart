import 'package:flutter/material.dart';
import '../../widgets/despost/des_post_feed.dart';
import '../../widgets/common/bottom_bar.dart';

class HomeScreen2 extends StatefulWidget {
  final String? accessToken;
  final bool inShell;
  
  const HomeScreen2({Key? key, this.accessToken, this.inShell = false})
      : super(key: key);

  @override
  
  State<HomeScreen2> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen2> {
  @override
  Widget build(BuildContext context) {
    Widget content = const FeedWidget();

    // In-shell mode: Don't render app bar or nav bar
    if (widget.inShell) {
      return content;
    }

    //Debugging
    print("Destination: HomeScreen2");

    
    return Scaffold(
      body: Column(
        children: [
          content,
        ],
      ),
      bottomNavigationBar: const BottomBar(),
    );
  }
}
