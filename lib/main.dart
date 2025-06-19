/*
 * main.dart
 * 
 * This is the entry point of the Flutter application that initializes the app.
 * It sets up the basic theme and routing structure for the entire application.
 * 
 * Key responsibilities:
 * - Initializes the Flutter application
 * - Sets up the MaterialApp widget which provides the basic app structure
 * - Configures the initial route to HomeScreen
 * - Imports necessary dependencies for the app
 */

// This is the entry point of the Flutter application that initializes the app
// Sets up the basic theme and routing structure
// Contains a sample counter app implementation that demonstrates state management
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
      theme: ThemeData.dark().copyWith(
        scaffoldBackgroundColor: Colors.black,
        appBarTheme: AppBarTheme(
          backgroundColor: Colors.black,
          elevation: 0,
        ),
      ),
      
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