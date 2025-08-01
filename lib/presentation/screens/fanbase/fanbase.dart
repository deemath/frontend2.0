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
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setModalState) {
            Future<void> _pickImage() async {
              final picker = ImagePicker();
              final pickedFile =
                  await picker.pickImage(source: ImageSource.gallery);

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
                    title: const Text('Enter the fanbase Photo URL.'),
                    content: TextField(
                      controller: urlController,
                      decoration:
                          const InputDecoration(hintText: 'https://...'),
                      keyboardType: TextInputType.url,
                    ),
                    actions: [
                      TextButton(
                        child: const Text('Cancel'),
                        onPressed: () => Navigator.pop(context),
                      ),
                      ElevatedButton(
                        child: const Text('Enter'),
                        onPressed: () {
                          setModalState(() {
                            networkImageUrl = urlController.text.trim();
                            selectedImage = null;
                          });
                          Navigator.pop(context);
                        },
                      ),
                    ],
                  );
                },
              );
            }

            return Padding(
              padding: EdgeInsets.only(
                bottom: MediaQuery.of(context).viewInsets.bottom,
                top: 24,
                left: 16,
                right: 16,
              ),
              child: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Text(
                      'Create Fanbase',
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                    ),
                    const SizedBox(height: 16),

                    // ─── Circular Avatar with + Button ───────────────────────────────
                    Stack(
                      children: [
                        CircleAvatar(
                          radius: 30,
                          backgroundColor: Colors.grey[300],
                          backgroundImage: selectedImage != null
                              ? FileImage(selectedImage!)
                              : (networkImageUrl != null &&
                                      networkImageUrl!.isNotEmpty)
                                  ? NetworkImage(networkImageUrl!)
                                      as ImageProvider
                                  : const AssetImage(
                                      'assets/images/spotify.png'),
                        ),
                        Positioned(
                          bottom: -8,
                          right: -8,
                          child: PopupMenuButton<String>(
                            icon: CircleAvatar(
                              radius: 12,
                              backgroundColor: Colors.white,
                              child: const Icon(Icons.add, size: 18),
                            ),
                            onSelected: (value) {
                              if (value == 'gallery') {
                                _pickImage();
                              } else if (value == 'url') {
                                _showUrlInputDialog();
                              }
                            },
                            itemBuilder: (context) => [
                              const PopupMenuItem(
                                value: 'gallery',
                                child: Row(
                                  children: [
                                    Icon(Icons.photo_library),
                                    SizedBox(width: 8),
                                    Text('Choose from Gallery'),
                                  ],
                                ),
                              ),
                              const PopupMenuItem(
                                value: 'url',
                                child: Row(
                                  children: [
                                    Icon(Icons.link),
                                    SizedBox(width: 8),
                                    Text('Enter URL'),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 20),

                    // ─── Fanbase Name Input ─────────────────────────────────────────
                    TextField(
                      controller: nameController,
                      decoration: InputDecoration(
                        labelText: 'Fanbase Name',
                        filled: true,
                        fillColor: Colors.grey[100],
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(20),
                          borderSide: BorderSide.none,
                        ),
                      ),
                    ),

                    const SizedBox(height: 12),

                    // ─── Fanbase Topic Input ───────────────────────────────────────
                    TextField(
                      controller: topicController,
                      maxLines: 2,
                      decoration: InputDecoration(
                        labelText: 'What is this fanbase about?',
                        filled: true,
                        fillColor: Colors.grey[100],
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(20),
                          borderSide: BorderSide.none,
                        ),
                      ),
                    ),

                    const SizedBox(height: 20),

                    // ─── Buttons ────────────────────────────────────────────────────
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        TextButton.icon(
                          onPressed: () => Navigator.pop(context),
                          icon: const Icon(Icons.close, color: Colors.grey),
                          label: const Text('Cancel'),
                          style: TextButton.styleFrom(
                            foregroundColor: Colors.grey[700],
                          ),
                        ),
                        const SizedBox(width: 8),
                        ElevatedButton.icon(
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
                          icon: const Icon(Icons.check),
                          label: const Text('Create'),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.deepPurpleAccent,
                            foregroundColor: Colors.white,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 12),
                  ],
                ),
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
