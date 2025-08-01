import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import '../../../../core/providers/auth_provider.dart';
import '../../../../data/models/profile_model.dart';
import '../../../../data/services/profile_service.dart';

class EditProfilePage extends StatefulWidget {
  const EditProfilePage({Key? key}) : super(key: key);

  @override
  State<EditProfilePage> createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<EditProfilePage> {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _bioController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _fullNameController = TextEditingController();
  String profileImage =
      'https://i.scdn.co/image/ab6761610000e5eb02e3c8b0e6e6e6e6e6e6e6e6';

  final ProfileService _service = ProfileService();

  bool _loading = true;
  bool _saving = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _fetchProfile();
    });
  }

  Future<void> _fetchProfile() async {
    setState(() => _loading = true); // Ensure loading state is set
    final userId = Provider.of<AuthProvider>(context, listen: false).user?.id;
    if (userId == null) {
      setState(() => _loading = false);
      return;
    }
    final result = await _service.getUserProfile(userId);

    // Debug: print the result for troubleshooting
    // ignore: avoid_print
    print('Profile fetch result: $result');

    if (result['success'] == false) {
      setState(() => _loading = false);
      return;
    }
    final data = result['data'];
    // No need to check for 'profile' key here, as service already extracts it
    _usernameController.text = data['username'] ?? '';
    _bioController.text = data['bio'] ?? '';
    _emailController.text = data['email'] ?? '';
    _fullNameController.text = data['fullName'] ?? '';
    profileImage = data['profileImage'] ?? profileImage;
    setState(() => _loading = false);
  }

  void _pickImage() async {
    setState(() {
      profileImage = profileImage.endsWith('e6e6e6e6e6e6e6e6')
          ? 'https://i.scdn.co/image/ab6761610000e5ebc4e8e8e8e8e8e8e8e8e8e8e8'
          : 'https://i.scdn.co/image/ab6761610000e5eb02e3c8b0e6e6e6e6e6e6e6e6';
    });
  }

  Future<void> _saveProfile() async {
    setState(() => _saving = true);
    final userId = Provider.of<AuthProvider>(context, listen: false).user?.id;
    if (userId == null) {
      setState(() => _saving = false);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('User not logged in')),
      );
      return;
    }
    final editProfile = EditProfileModel(
      username: _usernameController.text,
      bio: _bioController.text,
      profileImage: profileImage,
      email: _emailController.text,
      fullName: _fullNameController.text,
    );
    final result = await _service.updateProfile(userId, editProfile.toJson());
    setState(() => _saving = false);
    if (result['success'] == true) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Profile updated successfully!')),
        );
        // Do not pop here; stay on the edit page
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
            content: Text(result['message'] ?? 'Failed to update profile')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_loading || _saving) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }
    return Scaffold(
      appBar: AppBar(
        title: const Text('Edit Profile'),
        backgroundColor: Colors.black,
      ),
      backgroundColor: Colors.black,
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          children: [
            const SizedBox(height: 16),
            GestureDetector(
              onTap: _pickImage,
              child: CircleAvatar(
                radius: 48,
                backgroundImage: NetworkImage(profileImage),
                child: Align(
                  alignment: Alignment.bottomRight,
                  child: CircleAvatar(
                    radius: 16,
                    backgroundColor: Colors.white,
                    child:
                        Icon(Icons.camera_alt, color: Colors.black, size: 18),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 24),
            TextField(
              controller: _fullNameController,
              style: const TextStyle(color: Colors.white),
              decoration: InputDecoration(
                labelText: 'Full Name',
                labelStyle: const TextStyle(color: Colors.grey),
                enabledBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: Colors.grey.shade700),
                ),
                focusedBorder: const UnderlineInputBorder(
                  borderSide: BorderSide(color: Colors.white),
                ),
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _usernameController,
              style: const TextStyle(color: Colors.white),
              decoration: InputDecoration(
                labelText: 'Username',
                labelStyle: const TextStyle(color: Colors.grey),
                enabledBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: Colors.grey.shade700),
                ),
                focusedBorder: const UnderlineInputBorder(
                  borderSide: BorderSide(color: Colors.white),
                ),
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _bioController,
              style: const TextStyle(color: Colors.white),
              maxLines: 3,
              decoration: InputDecoration(
                labelText: 'Bio',
                labelStyle: const TextStyle(color: Colors.grey),
                enabledBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: Colors.grey.shade700),
                ),
                focusedBorder: const UnderlineInputBorder(
                  borderSide: BorderSide(color: Colors.white),
                ),
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _emailController,
              style: const TextStyle(color: Colors.white),
              decoration: InputDecoration(
                labelText: 'Email',
                labelStyle: const TextStyle(color: Colors.grey),
                enabledBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: Colors.grey.shade700),
                ),
                focusedBorder: const UnderlineInputBorder(
                  borderSide: BorderSide(color: Colors.white),
                ),
              ),
            ),
            const SizedBox(height: 32),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                OutlinedButton(
                  style: OutlinedButton.styleFrom(
                    side: const BorderSide(color: Colors.white),
                  ),
                  child: const Text('Cancel',
                      style: TextStyle(color: Colors.white)),
                  // Redirect to /profile after clicking
                  // Use pushReplacementNamed to avoid stacking
                  onPressed: () {
                    Navigator.pushReplacementNamed(context, '/profile');
                  },
                ),
                ElevatedButton(
                  onPressed: _saveProfile,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white,
                  ),
                  child:
                      const Text('Save', style: TextStyle(color: Colors.black)),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

// END LEGACY NAVIGATION SUPPORT
}
