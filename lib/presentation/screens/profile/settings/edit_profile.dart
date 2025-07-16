import 'package:flutter/material.dart';

class EditProfilePage extends StatefulWidget {
  const EditProfilePage({Key? key}) : super(key: key);

  @override
  State<EditProfilePage> createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<EditProfilePage> {
  final TextEditingController _nameController =
      TextEditingController(text: "Spotify User");
  final TextEditingController _usernameController =
      TextEditingController(text: "spotify_user");
  final TextEditingController _bioController =
      TextEditingController(text: "Music is my escape 🎶");
  String profileImage =
      'https://i.scdn.co/image/ab6761610000e5eb02e3c8b0e6e6e6e6e6e6e6e6';

  void _pickImage() async {
    // Mock image picker: just toggle between two images for demo
    setState(() {
      profileImage = profileImage.endsWith('e6e6e6e6e6e6e6e6')
          ? 'https://i.scdn.co/image/ab6761610000e5ebc4e8e8e8e8e8e8e8e8e8e8e8'
          : 'https://i.scdn.co/image/ab6761610000e5eb02e3c8b0e6e6e6e6e6e6e6e6';
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Edit Profile'),
        backgroundColor: Colors.black,
        actions: [
          TextButton(
            onPressed: () {
              // Save logic here
              Navigator.pop(context);
            },
            child: const Text('Save', style: TextStyle(color: Colors.white)),
          ),
        ],
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
              controller: _nameController,
              style: const TextStyle(color: Colors.white),
              decoration: InputDecoration(
                labelText: 'Name',
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
            const SizedBox(height: 32),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                OutlinedButton(
                  onPressed: () => Navigator.pop(context),
                  style: OutlinedButton.styleFrom(
                    side: const BorderSide(color: Colors.white),
                  ),
                  child: const Text('Cancel',
                      style: TextStyle(color: Colors.white)),
                ),
                ElevatedButton(
                  onPressed: () {
                    // Save logic here
                    Navigator.pop(context);
                  },
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
}
