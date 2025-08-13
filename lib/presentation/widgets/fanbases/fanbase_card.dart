import 'package:flutter/material.dart';
import 'package:frontend/data/models/fanbase/fanbase_model.dart';
import 'package:frontend/data/services/fanbase/fanbase_service.dart';
import './fanbase_interations.dart';
import './fanbase_profilebar.dart';

class FanbaseCard extends StatefulWidget {
  final Fanbase initialFanbase;
  final VoidCallback onJoinStateChanged;

  const FanbaseCard({
    super.key,
    required this.initialFanbase,
    required this.onJoinStateChanged,
  });

  @override
  State<FanbaseCard> createState() => _FanbaseCardState();
}

class _FanbaseCardState extends State<FanbaseCard> {
  late Fanbase _fanbase;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _fanbase = widget.initialFanbase;
  }

  @override
  void didUpdateWidget(covariant FanbaseCard oldWidget) {
    super.didUpdateWidget(oldWidget);
    // This is still important to keep the card's state in sync
    // if the parent list refreshes for any other reason.
    if (widget.initialFanbase != oldWidget.initialFanbase) {
      setState(() {
        _fanbase = widget.initialFanbase;
      });
    }
  }

  String truncateText(String text, int maxLength, {bool addEllipsis = true}) {
    if (text.length <= maxLength) return text;
    return addEllipsis
        ? '${text.substring(0, maxLength)}...'
        : text.substring(0, maxLength);
  }

  /// Handles toggling the join status by trusting the backend response.
  Future<void> _handleJoin() async {
    if (_isLoading) return;

    setState(() => _isLoading = true);

    try {
      // Call the service and wait for the definitive response
      final updatedFanbase =
          await FanbaseService.joinFanbase(_fanbase.id, context);

      print('Updated fanbase: ${updatedFanbase.toJson()}');

      // Trust the backend's response to update the state
      if (mounted) {
        setState(() {
          _fanbase = updatedFanbase;
        });
      }

      // Only notify parent on success, or remove this line entirely
      // widget.onJoinStateChanged();
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: ${e.toString()}')),
        );
      }
      // Notify parent only on error to refresh the list
      widget.onJoinStateChanged();
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context).colorScheme;

    return GestureDetector(
      onTap: () => Navigator.pushNamed(context, '/fanbase/${_fanbase.id}'),
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
        padding: const EdgeInsets.all(12.0),
        decoration: BoxDecoration(
          color: theme.primary,
          borderRadius: BorderRadius.circular(16.0),
          border: Border.all(
            color: theme.outlineVariant,
            width: 1.2,
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            /// Top Row: Profile + Join Button
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                ProfileNameRow(
                  profileImageUrl: _fanbase.fanbasePhotoUrl ?? '',
                  fanbaseName: truncateText(_fanbase.fanbaseName, 15),
                ),
                OutlinedButton(
                  onPressed: _handleJoin,
                  style: OutlinedButton.styleFrom(
                    backgroundColor:
                        _fanbase.isJoined ? Colors.white : Colors.purple,
                    foregroundColor:
                        _fanbase.isJoined ? Colors.purple : Colors.white,
                    side: const BorderSide(color: Colors.purple),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                  ),
                  child: _isLoading
                      ? SizedBox(
                          width: 16,
                          height: 16,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            valueColor: AlwaysStoppedAnimation<Color>(
                              _fanbase.isJoined ? Colors.purple : Colors.white,
                            ),
                          ),
                        )
                      : Text(_fanbase.isJoined ? 'Joined' : 'Join'),
                ),
              ],
            ),

            const SizedBox(height: 14.0),

            /// Topic
            Container(
              width: double.infinity,
              child: Text(
                truncateText(_fanbase.fanbaseTopic, 55),
                style: TextStyle(
                  color: theme.onPrimary,
                  fontSize: 14.5,
                ),
              ),
            ),

            const SizedBox(height: 14.0),

            /// Interaction stats
            FanbaseInterations(
              numLikes: _fanbase.numLikes,
              numPosts: _fanbase.numPosts,
            ),
          ],
        ),
      ),
    );
  }
}
