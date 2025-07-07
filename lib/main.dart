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
// import 'package:frontend/presentation/screens/search/search_feed_screen.dart';
import 'presentation/widgets/despost/demo.dart';
import 'presentation/screens/search/search_feed_screen.dart';
import 'presentation/widgets/view_song_post/feed.dart';
import 'presentation/screens/show_all_posts_screen.dart';
import 'presentation/screens/fanbase/fanbase_details.dart';



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

      onGenerateRoute: (settings) {
        final uri = Uri.parse(settings.name ?? '');
        if (uri.pathSegments.length == 2 && uri.pathSegments[0] == 'fanbase') {
          final id = uri.pathSegments[1];
          return MaterialPageRoute(
            builder: (_) => FanbaseDetailScreen(fanbaseId: id),
          );
        }

      // Add other routes
        switch (settings.name) {
          case '/home':
            return MaterialPageRoute(builder: (_) => const HomeScreen());
          case '/login':
            return MaterialPageRoute(builder: (_) => const LoginScreen());
          case '/signup':
            return MaterialPageRoute(builder: (_) => const SignupScreen());
          case '/create':
            return MaterialPageRoute(
              builder: (_) => CreatePostPage(
                spotifyService: SpotifyService(
                  accessToken: AppConstants.spotifyAccessToken,
                ),
              ),
            );
          case '/fanbases':
            return MaterialPageRoute(builder: (_) => FanbasePage());
          case '/profile':
            return MaterialPageRoute(builder: (_) => NormalUserProfilePage());
          case '/search':
            return MaterialPageRoute(builder: (_) => SearchFeedScreen());
          case '/demodespost':
            return MaterialPageRoute(builder: (_) => DemoScreen2());
          case '/feed':
            return MaterialPageRoute(builder: (_) => FeedPage());
          case '/showpost':
            return MaterialPageRoute(builder: (_) => const ShowAllPostsScreen());
          default:
            return MaterialPageRoute(
              builder: (_) => Scaffold(
                body: Center(child: Text('Page not found: ${settings.name}')),
              ),
            );
        }
      },
      // Remove the routes: property if you use onGenerateRoute
      initialRoute: '/home',


      // Start with login screen, then check auth status
      // home: const AuthWrapper(),
      // home: const HomeScreen(),

      // routes: {
      //   '/login': (context) => const LoginScreen(),
      //   '/signup': (context) => const SignupScreen(),
      //   '/home': (context) => const HomeScreen(),
      //   '/create': (context) => CreatePostPage(
      //         spotifyService: SpotifyService(
      //           accessToken: AppConstants.spotifyAccessToken,
      //         ),
      //       ),
      //   '/fanbases': (context) => FanbasePage(),
      //   '/profile': (context) => NormalUserProfilePage(),
      //   '/search': (context) => SearchFeedScreen(),
      //   // '/demo': (context) => DemoScreen(),
      //   '/demodespost': (context) => DemoScreen2(),

      //   '/feed': (context) => FeedPage(),
      //   '/showpost': (context) => const ShowAllPostsScreen(),
      // },
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
