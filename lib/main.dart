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
        scaffoldBackgroundColor: AppTheme.PrimaryColor,
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