import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:race_tracking_app/models/participant.dart';

class ParticipantGrid extends StatelessWidget {
  final String title;
  final Map<String, DateTime?> namesWithTime;
  final void Function(String)? onTap;
  final Color avatarColor;
  final List<Participant> participants;

  const ParticipantGrid({
    super.key,
    required this.title,
    required this.namesWithTime,
    this.onTap,
    required this.avatarColor,
    required this.participants,
  });

  @override
  Widget build(BuildContext context) {
    final nameList = namesWithTime.keys.toList();

    return Card(
      margin: const EdgeInsets.all(12),
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 12.0),
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
                crossAxisCount: 2, // fewer columns for larger rectangular cards
                childAspectRatio: 1.6,
                crossAxisSpacing: 12,
                mainAxisSpacing: 12,
              ),
              itemCount: nameList.length,
              itemBuilder: (context, index) {
                final name = nameList[index];
                final time = namesWithTime[name];

                final participant = participants.firstWhere(
                  (p) => p.name == name,
                  orElse: () => Participant(id: '', name: name, bib: index + 1),
                );

                final displayName = participant.name;
                final bib = participant.bib;
                final timeString = time != null
                    ? DateFormat('HH:mm:ss').format(time)
                    : '00:00:00';

                return GestureDetector(
                  onTap: onTap != null ? () => onTap!(name) : null,
                  child: Container(
                    decoration: BoxDecoration(
                      color: avatarColor.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: avatarColor, width: 2),
                    ),
                    padding: const EdgeInsets.symmetric(
                      vertical: 12,
                      horizontal: 8,
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          "#$bib",
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: avatarColor,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          displayName,
                          style: const TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 4),
                        Text(
                          timeString,
                          style: const TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.normal,
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
  }
}
