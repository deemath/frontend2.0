import 'package:flutter/material.dart';
import 'package:frontend/data/models/fanbase/fanbase_model.dart';
import 'package:frontend/data/services/fanbase/fanbase_service.dart';
import 'package:lucide_icons/lucide_icons.dart';

class FanbaseDetailScreen extends StatefulWidget {
  final String fanbaseId;

  const FanbaseDetailScreen({super.key, required this.fanbaseId});

  @override
  State<FanbaseDetailScreen> createState() => _FanbaseDetailScreenState();
}

class _FanbaseDetailScreenState extends State<FanbaseDetailScreen> {
  late Future<Fanbase> _fanbaseFuture;
  bool isJoined = false;

  @override
  void initState() {
    super.initState();
    _fanbaseFuture = FanbaseService.getFanbaseById(widget.fanbaseId);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final color = theme.colorScheme;

    return Scaffold(
      body: FutureBuilder<Fanbase>(
        future: _fanbaseFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError || !snapshot.hasData) {
            return const Center(child: Text('Error loading fanbase'));
          }

          final fanbase = snapshot.data!;

          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // ===== Top Container =====
              Container(
                alignment: Alignment.bottomLeft,
                padding: const EdgeInsets.fromLTRB(8.0, 30.0, 8.0, 8.0),
                // padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 30),
                color: Theme.of(context).colorScheme.onPrimary,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  // mainAxisAlignment: MainAxisAlignment.center,
                  // crossAxisAlignment: CrossAxisAlignment.baseline,
                  children: [
                    // Profile Image and Name
                    CircleAvatar(
                      backgroundImage: NetworkImage(fanbase.fanbasePhotoUrl),
                      radius: 24,
                      backgroundColor: Theme.of(context).colorScheme.surface,
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        fanbase.fanbaseName,
                        style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                          color: Theme.of(context).colorScheme.primary,
                        ),
                      ),
                    ),
                    // Create Post Button
                    OutlinedButton.icon(
                      onPressed: () {},
                      icon: const Icon(LucideIcons.plus, size: 16),
                      label: const Text("Create Post"),
                      style: OutlinedButton.styleFrom(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    // Join / Joined Button with fixed width
                    SizedBox(
                      width: 100, // Fixed width
                      child: OutlinedButton(
                        onPressed: () => setState(() => isJoined = !isJoined),
                        style: OutlinedButton.styleFrom(
                          backgroundColor: isJoined ? Colors.transparent : Colors.purple,
                          foregroundColor:
                              isJoined ? Theme.of(context).colorScheme.primary : Colors.white,
                          side: const BorderSide(color: Colors.purple),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20),
                          ),
                        ),
                        child: Text(isJoined ? 'Joined' : 'Join'),
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 16),

              // ===== Fanbase Topic / Description =====
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Text(
                  fanbase.fanbaseTopic,
                  style: Theme.of(context).textTheme.bodyLarge,
                ),
              ),

              const SizedBox(height: 24),

            ],
          );
        },
      ),
    );
  }

}
