import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'package:provider/provider.dart';
import 'package:frontend/data/services/auth_service.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:url_launcher/url_launcher.dart';
import 'dart:html' as html; // Only used on web
import '../../widgets/auth/custom_button.dart';

class LinkSpotifyScreen extends StatelessWidget {
  const LinkSpotifyScreen({Key? key}) : super(key: key);

  Future<void> _handleLinkSpotify(BuildContext context) async {
    try {
      if (kIsWeb) {
        // On web, redirect the browser to your backend endpoint
        final backendUrl = 'http://localhost:3000/spotify/login/alt';
        html.window.open(backendUrl, 'SpotifyAuth');
        return;
      }
      final authService = Provider.of<AuthService>(context, listen: false);
      final dio = authService.dio; // Authenticated Dio instance
      final response = await dio.post('/spotify/login');
      if (response.statusCode == 200 || response.statusCode == 302) {
        final data = response.data;
        final regex = RegExp(r'Redirecting to (https?://\S+)');
        final match = regex.firstMatch(data.toString());
        final url = match != null ? match.group(1) : null;
        if (url != null) {
          if (await canLaunchUrl(Uri.parse(url))) {
            await launchUrl(Uri.parse(url),
                mode: LaunchMode.externalApplication);
          }
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Failed to get Spotify redirect URL.')),
          );
        }
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to initiate Spotify login.')),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Background image
          SizedBox.expand(
            child: Image.asset(
              'assets/backgrounds/black-and-green-background.jpg',
              fit: BoxFit.cover,
            ),
          ),
          // 50% opacity black overlay
          Container(
            color: Colors.black.withOpacity(0.8),
          ),
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 60),
            decoration: BoxDecoration(
              color: Colors.black.withOpacity(0.9),
              borderRadius: BorderRadius.circular(40),
            ),
          ),
          // Existing widget content
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'Link account',
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 10),
                Container(
                  margin: const EdgeInsets.symmetric(horizontal: 36.0),
                  child: Text(
                    'Inorder to access more features, a spotify account is required.',
                    textAlign: TextAlign.center,
                    style: const TextStyle(color: Colors.white, fontSize: 14),
                  ),
                ),
                const SizedBox(height: 30),
                // Replace ElevatedButton with CustomButton
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10.0),
                  child: CustomButton(
                    onPressed: () => _handleLinkSpotify(context),
                    isLoading: false,
                    text: 'Link Spotify',
                    padding: const EdgeInsets.symmetric(
                        horizontal: 32.0, vertical: 18.0),
                  ),
                ),
                const SizedBox(height: 10),
                Center(
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.pushNamed(context, '/home');
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.transparent,
                      elevation: 0,
                      shadowColor: Colors.transparent,
                      padding: const EdgeInsets.symmetric(
                          horizontal: 16.0, vertical: 8.0),
                    ),
                    child: const Text(
                      "Skip for now",
                      style: TextStyle(color: Colors.grey),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
