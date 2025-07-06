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
import 'package:provider/provider.dart';
import 'package:uni_links/uni_links.dart';
import 'dart:async';
import 'presentation/screens/home_screen.dart';

import 'presentation/screens/auth/login_screen.dart';
import 'presentation/screens/auth/signup_screen.dart';

import 'presentation/screens/create_noots/search_song.dart';
import 'core/styles/theme.dart';
import 'data/services/spotify_service.dart';
import 'data/services/auth_service.dart';
import 'core/constants/app_constants.dart';

import 'core/providers/theme_provider.dart'; // 👈 Create this file
import 'presentation/screens/fanbase/fanbase.dart';
import 'presentation/screens/profile/normal_user.dart';
import 'presentation/screens/search/search_feed_screen.dart';
import 'presentation/widgets/view_song_post/feed.dart';
import 'presentation/screens/show_all_posts_screen.dart';
import 'presentation/screens/post_detail_screen.dart';



void main() {
  runApp(
    ChangeNotifierProvider(
      create: (_) => ThemeProvider(),
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);

    return MaterialApp(
      title: 'Noot',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: themeProvider.themeMode,

      
      // Start with login screen, then check auth status
      // home: const AuthWrapper(),
      home: const HomeScreen(),

      routes: {
        '/login': (context) => const LoginScreen(),
        '/signup': (context) => const SignupScreen(),
        '/home': (context) => const HomeScreen(),
        '/create': (context) => CreatePostPage(
              spotifyService: SpotifyService(
                accessToken: AppConstants.spotifyAccessToken,
              ),
            ),
        '/fanbases': (context) => FanbasePage(),
        '/profile': (context) => NormalUserProfilePage(),
        '/search': (context) => SearchFeedScreen(),

        '/feed': (context) => FeedPage(),
        '/showpost': (context) => const ShowAllPostsScreen(),
        '/post/:id': (context) {
          final postId = ModalRoute.of(context)!.settings.arguments as String? ?? 
                        Uri.parse(ModalRoute.of(context)!.settings.name!).pathSegments.last;
          return PostDetailScreen(postId: postId);
        },
      },
    );
  }
}

// Wrapper to check authentication status on app start
class AuthWrapper extends StatefulWidget {
  const AuthWrapper({Key? key}) : super(key: key);

  @override
  State<AuthWrapper> createState() => _AuthWrapperState();
}

class _AuthWrapperState extends State<AuthWrapper> {
  bool _isLoading = true;
  bool _isLoggedIn = false;

  @override
  void initState() {
    super.initState();
    _checkAuthStatus();
  }

  Future<void> _checkAuthStatus() async {
    final authService = AuthService();
    final isLoggedIn = await authService.isLoggedIn();
    
    setState(() {
      _isLoggedIn = isLoggedIn;
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return Scaffold(
        backgroundColor: Theme.of(context).colorScheme.primary,
        body: Center(
          child: CircularProgressIndicator(
            color: Theme.of(context).colorScheme.secondary,
          ),
        ),
      );
    }

    return _isLoggedIn ? const HomeScreen() : const LoginScreen();
  }
}