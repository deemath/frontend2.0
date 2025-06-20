/* Note:
SafeArea should be applied inside each screen's Scaffold body (e.g., HomeScreen, CreatePostPage)
to prevent UI from being obscured by device notches, status bars, or system UI elements.

class ExampleScreen extends StatelessWidget {
  const ExampleScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: Text('Hello, SafeArea!'),
        ),
      ),
    );
  }
}

*/

import 'package:flutter/material.dart';
import 'presentation/screens/home_screen.dart';
import 'presentation/screens/create_post.dart';
import 'core/styles/theme.dart';
import 'data/services/spotify_service.dart';
import 'core/constants/app_constants.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Noot',
      debugShowCheckedModeBanner: false,

      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: ThemeMode.system, // Or ThemeMode.light / dark

      home: const HomeScreen(),
      routes: {
        '/create': (context) => CreatePostPage(
          spotifyService: SpotifyService(
            accessToken: AppConstants.spotifyAccessToken,
          ),
        ),
      },
    );
  }
}
