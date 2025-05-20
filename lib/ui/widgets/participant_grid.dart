// participant_grid.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:race_tracking_app/models/participant.dart';
import 'package:race_tracking_app/providers/segment_time_provider.dart';

class ParticipantGrid extends StatelessWidget {
  final String title;
  final String segment;
  final List<Participant> participants;
  final void Function(Participant)? onTap;
  final Color avatarColor;
  final DateTime? raceStartTime;

  const ParticipantGrid({
    super.key,
    required this.title,
    required this.segment,
    required this.participants,
    this.onTap,
    required this.avatarColor,
    required this.raceStartTime,
  });

  String _formatElapsed(DateTime? start, DateTime? end) {
    if (start == null || end == null) return "--:--:--";
    final duration = end.difference(start);
    final h = duration.inHours.toString().padLeft(2, '0');
    final m = (duration.inMinutes % 60).toString().padLeft(2, '0');
    final s = (duration.inSeconds % 60).toString().padLeft(2, '0');
    return "$h:$m:$s";
  }

  @override
  Widget build(BuildContext context) {
    final segmentTimeProvider = Provider.of<SegmentTimeProvider>(context);
    final screenWidth = MediaQuery.of(context).size.width;

    int crossAxisCount = 2; 
    double aspectRatio = 2.0; 
    double spacing = 6.0;
    double fontSizeRatio = 0.8;

    if (screenWidth > 900) {
      crossAxisCount = 4;
      aspectRatio = 3;
      fontSizeRatio = 1.0;
      spacing = 8;
    } else if (screenWidth > 600) {
      crossAxisCount = 3;
      aspectRatio = 2.5;
      fontSizeRatio = 0.9;
      spacing = 6;
    } else if (screenWidth > 400) {
      crossAxisCount = 4; 
      aspectRatio = 2.0;
      fontSizeRatio = 0.7;
      spacing = 4;
    } else {
      crossAxisCount = 2;
      aspectRatio = 1.8;
      fontSizeRatio = 0.6;
      spacing = 4;
    }

    return LayoutBuilder(
      builder: (context, constraints) {
        return Card(
          margin: const EdgeInsets.all(8),
          elevation: 4,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 6),
                child: Text(
                  title,
                  style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  textAlign: TextAlign.center,
                ),
              ),
              const Divider(height: 1),
              Expanded(
                child: GridView.builder(
                  padding: const EdgeInsets.all(4),
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: crossAxisCount,
                    childAspectRatio: aspectRatio,
                    crossAxisSpacing: spacing,
                    mainAxisSpacing: spacing,
                  ),
                  itemCount: participants.length,
                  itemBuilder: (context, index) {
                    final participant = participants[index];
                    final id = participant.id;
                    final endTimeIso = segmentTimeProvider.getEndTime(id, segment);
                    final hasTime = endTimeIso != null;
                    DateTime? endTime;

                    if (hasTime) {
                      endTime = DateTime.tryParse(endTimeIso);
                    }

                    final timeStr = hasTime
                        ? _formatElapsed(raceStartTime, endTime)
                        : 'Not Finished';

                    return InkWell(
                      onTap: () {
                        if (onTap != null) {
                          onTap!(participant);
                        }
                      },
                      borderRadius: BorderRadius.circular(50), // Make it capsule
                      child: Container(
                        decoration: BoxDecoration(
                          color: hasTime
                              ? Colors.green.withOpacity(0.2)
                              : avatarColor.withOpacity(0.2),
                          borderRadius: BorderRadius.circular(50), // Make it capsule
                          border: Border.all(
                            color: hasTime ? Colors.green : avatarColor,
                            width: 1,
                          ),
                        ),
                        padding: const EdgeInsets.symmetric(vertical: 2, horizontal: 2), // Adjust padding
                        child: Center( // Center the content
                          child: Column(
                            mainAxisSize: MainAxisSize.min, // Take minimum vertical space
                            children: [
                              Text(
                                "#${participant.bib}",
                                style: TextStyle(
                                  fontSize: 20 * fontSizeRatio,
                                  fontWeight: FontWeight.bold,
                                  color: hasTime ? Colors.green : avatarColor,
                                ),
                              ),
                              const SizedBox(height: 1),
                              Text(
                                participant.name,
                                style: TextStyle(
                                  fontSize: 10 * fontSizeRatio,
                                  fontWeight: FontWeight.w600,
                                ),
                                textAlign: TextAlign.center,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                              const SizedBox(height: 1),
                              Text(
                                timeStr,
                                style: TextStyle(
                                  fontSize: 9 * fontSizeRatio,
                                  fontWeight: hasTime ? FontWeight.bold : FontWeight.normal,
                                  color: hasTime ? Colors.green.shade800 : Colors.grey,
                                ),
                                textAlign: TextAlign.center,
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}