import 'package:flutter/material.dart';
// import 'package:provider/provider.dart';
import 'dart:io';
import 'package:image_picker/image_picker.dart';

import 'package:frontend/data/models/fanbase/fanbase_model.dart';
import 'package:frontend/data/services/fanbase/fanbase_service.dart';
import 'package:frontend/presentation/widgets/fanbases/fanbase_card.dart';
// import 'package:frontend/presentation/widgets/common/musicplayer_bar.dart';
import 'package:frontend/presentation/widgets/common/bottom_bar.dart';
import 'package:frontend/presentation/widgets/home/header_bar.dart';
// import 'package:frontend/core/providers/auth_provider.dart';

class FanbasePage extends StatefulWidget {
  final bool inShell;

  const FanbasePage({super.key, this.inShell = false});

  @override
  State<FanbasePage> createState() => _FanbasePageState();
}

class _FanbasePageState extends State<FanbasePage> {
  late Future<List<Fanbase>> futureFanbases;
  bool _showMusicPlayer = false;

  @override
  void initState() {
    super.initState();
    // Remove the immediate call, do it in didChangeDependencies
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // Load fanbases after context is available
    _loadFanbases();
  }

  void _loadFanbases() {
    setState(() {
      futureFanbases = FanbaseService.getAllFanbases(context);
    });
  }

  // ─────────────────────────────────────────────────────────────────────────────
  // Fanbase List Builder
  Widget _buildFanbaseList() {
    return FutureBuilder<List<Fanbase>>(
      future: futureFanbases,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }
        if (snapshot.hasError) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text('Error: ${snapshot.error}'),
                ElevatedButton(
                  onPressed: _loadFanbases,
                  child: const Text('Retry'),
                ),
              ],
            ),
          );
        }
        if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return const Center(child: Text('No fanbases found.'));
        }

        final fanbases = snapshot.data!;
        return ListView.builder(
          itemCount: fanbases.length,
          itemBuilder: (context, index) {
            final fanbase = fanbases[index];
            return FanbaseCard(
              fanbaseId: fanbase.id,
              profileImageUrl: fanbase.fanbasePhotoUrl ?? '',
              fanbaseName: fanbase.fanbaseName,
              topic: fanbase.fanbaseTopic,
              numLikes: fanbase.numLikes,
              numPosts: fanbase.numPosts,
              isJoined: false,
              onJoin: () {}, // TODO: Implement join logic
            );
          },
        );
      },
    );
  }

  // ─────────────────────────────────────────────────────────────────────────────
  // Floating Action Button Logic
  void _showCreateFanbaseSheet() {
  final nameController = TextEditingController();
  final topicController = TextEditingController();
  final urlController = TextEditingController();

  File? selectedImage;
  String? networkImageUrl;

  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.white,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
    ),
    builder: (context) {
      return StatefulBuilder(
        builder: (context, setModalState) {
          Future<void> _pickImage() async {
            final picker = ImagePicker();
            final pickedFile = await picker.pickImage(source: ImageSource.gallery);
            if (pickedFile != null) {
              setModalState(() {
                selectedImage = File(pickedFile.path);
                networkImageUrl = null;
              });
            }
          }

          void _showUrlInputDialog() {
            showDialog(
              context: context,
              builder: (context) {
                return AlertDialog(
                  title: const Text('Enter the fanbase Photo URL'),
                  content: TextField(
                    controller: urlController,
                    decoration: const InputDecoration(hintText: 'https://...'),
                    keyboardType: TextInputType.url,
                  ),
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.pop(context),
                      child: const Text('Cancel'),
                    ),
                    ElevatedButton(
                      onPressed: () {
                        setModalState(() {
                          networkImageUrl = urlController.text.trim();
                          selectedImage = null;
                        });
                        Navigator.pop(context);
                      },
                      child: const Text('Use URL'),
                    ),
                  ],
                );
              },
            );
          }

          return Padding(
            padding: EdgeInsets.only(
              bottom: MediaQuery.of(context).viewInsets.bottom + 20,
              left: 20,
              right: 20,
              top: 24,
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text(
                  'Create Fanbase',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 20),

                // Avatar + Popup
                Stack(
                  children: [
                    CircleAvatar(
                      radius: 34,
                      backgroundColor: Colors.grey[300],
                      backgroundImage: selectedImage != null
                          ? FileImage(selectedImage!)
                          : (networkImageUrl != null && networkImageUrl!.isNotEmpty)
                              ? NetworkImage(networkImageUrl!) as ImageProvider
                              : const AssetImage('assets/images/spotify.png'),
                    ),
                    Positioned(
                      bottom: -8,
                      right: -8,
                      child: PopupMenuButton<String>(
                        icon: CircleAvatar(
                          radius: 14,
                          backgroundColor: Colors.white,
                          child: Icon(Icons.add, size: 18, color: Colors.black),
                        ),
                        onSelected: (value) {
                          if (value == 'gallery') _pickImage();
                          if (value == 'url') _showUrlInputDialog();
                        },
                        itemBuilder: (context) => [
                          const PopupMenuItem(
                            value: 'gallery',
                            child: Row(
                              children: [Icon(Icons.photo), SizedBox(width: 8), Text("Gallery")],
                            ),
                          ),
                          const PopupMenuItem(
                            value: 'url',
                            child: Row(
                              children: [Icon(Icons.link), SizedBox(width: 8), Text("Enter URL")],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),

                // Name Input
                TextField(
                  controller: nameController,
                  decoration: InputDecoration(
                    labelText: 'Fanbase Name',
                    labelStyle: const TextStyle(color: Color.fromARGB(255, 0, 0, 0)),
                    filled: true,
                    fillColor: const Color(0xFFF0F2FF),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(16),
                      borderSide: BorderSide.none,
                    ),
                  ),
                ),
                const SizedBox(height: 12),

                // Topic Input
                TextField(
                  controller: topicController,
                  maxLines: 4,
                  decoration: InputDecoration(
                    labelText: 'What is this fanbase about?',
                    labelStyle: const TextStyle(color:  Color.fromARGB(255, 0, 0, 0)),
                    filled: true,
                    fillColor: const Color(0xFFF0F2FF),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(16),
                      borderSide: BorderSide.none,
                    ),
                  ),
                ),
                const SizedBox(height: 20),

                // Action Buttons
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    TextButton(
                      onPressed: () => Navigator.pop(context),
                      child: const Text('Cancel'),
                    ),
                    const SizedBox(width: 10),
                    ElevatedButton(
                      onPressed: () async {
                        final name = nameController.text.trim();
                        final topic = topicController.text.trim();
                        if (name.isNotEmpty && topic.isNotEmpty) {
                          try {
                            await FanbaseService.createFanbase(
                              name,
                              topic,
                              context,
                              imageFile: selectedImage,
                              imageUrl: networkImageUrl,
                            );
                            if (!mounted) return;
                            Navigator.pop(context);
                            _loadFanbases();
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(content: Text('Fanbase created successfully')),
                            );
                          } catch (e) {
                            if (!mounted) return;
                            Navigator.pop(context);
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(content: Text('Error: $e')),
                            );
                          }
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFFDB0DF9),
                        foregroundColor: Colors.white,
                        textStyle: const TextStyle(fontWeight: FontWeight.bold),
                        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(14),
                        ),
                      ),
                      child: const Text('Create'),
                    ),
                  ],
                ),
              ],
            ),
          );
        },
      );
    },
  );
}


  // // ─────────────────────────────────────────────────────────────────────────────
  // // Music Player Widget
  // Widget _buildMusicPlayerBar() {
  //   return Consumer<AuthProvider>(
  //     builder: (context, authProvider, _) => AnimatedContainer(
  //       duration: const Duration(milliseconds: 300),
  //       curve: Curves.easeInOut,
  //       height: _showMusicPlayer ? null : 0.0,
  //       constraints: _showMusicPlayer
  //           ? null
  //           : const BoxConstraints(maxHeight: 0.0),
  //       child: SingleChildScrollView(
  //         physics: const NeverScrollableScrollPhysics(),
  //         child: MusicPlayerBar(
  //           isHidden: !_showMusicPlayer,
  //           onSessionStatusChanged: (isActive) {
  //             setState(() {
  //               _showMusicPlayer = isActive;
  //             });
  //           },
  //         ),
  //       ),
  //     ),
  //   );
  // }

  // ─────────────────────────────────────────────────────────────────────────────
  // Main Build
  @override
  Widget build(BuildContext context) {
    final content = _buildFanbaseList();

    // if (widget.inShell) {
    //   return Column(
    //     children: [
    //       Expanded(child: content),
    //       _buildMusicPlayerBar(),
    //     ],
    //   );
    // }

    return Scaffold(
      appBar: NootAppBar(),
      body: Column(
        children: [
          const Padding(
            padding: EdgeInsets.fromLTRB(16.0, 3.0, 0, 4.0),
            child: Align(
              alignment: Alignment.centerLeft,
              child: Text(
                'Fanbases',
                style: TextStyle(fontSize: 16),
              ),
            ),
          ),
          Expanded(child: content),
          Padding(
            padding: const EdgeInsets.only(bottom: 6.0, right: 6.0),
            child: Align(
              alignment: Alignment.bottomRight,
              child: FloatingActionButton.extended(
                onPressed: _showCreateFanbaseSheet,
                icon: const Icon(Icons.add, size: 18),
                label: const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 2.0),
                  child: Text(
                    'Fanbase',
                    style: TextStyle(fontSize: 14),
                  ),
                ),
                backgroundColor: Colors.deepPurple.shade100,
                heroTag: 'add_fanbase_fab',
              ),
            ),
          ),
          // _buildMusicPlayerBar(),
        ],
      ),
      bottomNavigationBar: const BottomBar(),
    );
  }
}
