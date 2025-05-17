import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:race_tracking_app/models/participant.dart';
import 'package:race_tracking_app/providers/segment_time_provider.dart';

class ParticipantGrid extends StatelessWidget {
  final String title;
  final String segment;
  final List<String> participantIds;
  final void Function(String)? onTap;
  final Color avatarColor;
  final List<Participant> participants;

  const ParticipantGrid({
    super.key,
    required this.title,
    required this.segment,
    required this.participantIds,
    this.onTap,
    required this.avatarColor,
    required this.participants,
  });

  @override
  Widget build(BuildContext context) {
    final segmentTimeProvider = Provider.of<SegmentTimeProvider>(context);

    return LayoutBuilder(
      builder: (context, constraints) {
        return Card(
          margin: const EdgeInsets.all(12),
          elevation: 4,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 12),
                child: Text(
                  title,
                  style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
              ),
              const Divider(height: 1),
              Expanded(
                child: GridView.builder(
                  padding: const EdgeInsets.all(12),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    childAspectRatio: 1.6,
                    crossAxisSpacing: 12,
                    mainAxisSpacing: 12,
                  ),
                  itemCount: participantIds.length,
                  itemBuilder: (context, index) {
                    final id = participantIds[index];
                    final endTimeIso = segmentTimeProvider.getEndTime(id, segment);
                    final hasTime = endTimeIso != null;
                    DateTime? endTime;

                    if (hasTime) {
                      endTime = DateTime.tryParse(endTimeIso);
                    }

                    final participant = participants.firstWhere(
                      (p) => p.id == id,
                      orElse: () => Participant(id: id, name: 'Unknown', bib: 0),
                    );

                    final timeStr = endTime != null
                        ? DateFormat('HH:mm:ss').format(endTime)
                        : '00:00:00';

                    return InkWell(
                      onTap: () {
                        if (!hasTime && onTap != null) {
                          onTap!(id);
                        }
                      },
                      borderRadius: BorderRadius.circular(16),
                      child: Container(
                        decoration: BoxDecoration(
                          color: hasTime
                              ? Colors.green.withOpacity(0.2)
                              : avatarColor.withOpacity(0.2),
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(
                            color: hasTime ? Colors.green : avatarColor,
                            width: 2,
                          ),
                        ),
                        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              "#${participant.bib}",
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: hasTime ? Colors.green : avatarColor,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              participant.name,
                              style: const TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w600,
                              ),
                              textAlign: TextAlign.center,
                            ),
                            const SizedBox(height: 4),
                            Text(
                              hasTime ? timeStr : 'Not Finished',
                              style: TextStyle(
                                fontSize: 12,
                                fontWeight: hasTime ? FontWeight.bold : FontWeight.normal,
                                color: hasTime ? Colors.green.shade800 : Colors.grey,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ],
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
