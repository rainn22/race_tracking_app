import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:race_tracking_app/models/segment.dart';
import 'package:race_tracking_app/models/status.dart';
import 'package:race_tracking_app/providers/race_stage_provider.dart';
import 'package:race_tracking_app/providers/participant_provider.dart';
import 'package:race_tracking_app/providers/segment_time_provider.dart';
import 'package:race_tracking_app/ui/widgets/participant_grid.dart';
import 'package:race_tracking_app/utils/constants.dart';
import 'package:race_tracking_app/utils/widgets/race_time_stamp.dart';
import 'package:race_tracking_app/utils/status_color.dart';
import 'package:race_tracking_app/utils/widgets/segment_button.dart';

class TrackingScreen extends StatefulWidget {
  const TrackingScreen({super.key});

  @override
  State<TrackingScreen> createState() => _TrackingScreenState();
}

class _TrackingScreenState extends State<TrackingScreen> {
  Segment currentStage = Segment.swimming;

  void onParticipantTap(BuildContext context, String participantId) async {
    final provider = context.read<SegmentTimeProvider>();

    final endTime = provider.getEndTime(participantId, currentStage.label);

    if (endTime != null) return;

    await provider.updateSegmentEndTime(
      participantId: participantId,
      segment: currentStage.label,
    );
    setState(() {}); // Refresh UI after tap
  }

  @override
  Widget build(BuildContext context) {
    final timerProvider = context.watch<RaceStageProvider>();
    final participantProvider = context.watch<ParticipantProvider>();
    final segmentTimeProvider = context.watch<SegmentTimeProvider>();

    final status = timerProvider.raceStage?.status ?? Status.notStarted;
    final startTime = timerProvider.raceStage?.startTime;
    final endTime = timerProvider.raceStage?.endTime;
    final participants = participantProvider.participantState?.data ?? [];

    final trackedParticipantIds = <String>[];
    final allParticipantIds = <String>[];

    for (final participant in participants) {
      final endTimeForSegment = segmentTimeProvider.getEndTime(participant.id, currentStage.label);
      if (endTimeForSegment != null) {
        trackedParticipantIds.add(participant.id);
      } else {
        allParticipantIds.add(participant.id);
      }
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text("Triathlon Tracker"),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(AppSpacing.padding),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Card(
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              color: AppColors.white,
              elevation: 2,
              child: Padding(
                padding: const EdgeInsets.symmetric(
                    vertical: 20.0, horizontal: AppSpacing.padding),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text("Race Status: ", style: AppTextStyles.textLg),
                        RaceStatus(value: status.label),
                      ],
                    ),
                    const SizedBox(height: 20),
                    RaceTimeStamp(
                      start: startTime,
                      end: status == Status.finished ? endTime : DateTime.now(),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 20),
            SegmentButton(
              selectedSegment: currentStage,
              onSegmentChanged: (segment) {
                setState(() {
                  currentStage = segment;
                });
              },
            ),
            const SizedBox(height: 10),
            Text(
              '${currentStage.label} Stage',
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            Expanded(
              child: Row(
                children: [
                  Expanded(
                    child: ParticipantGrid(
                      title: 'All Participants',
                      segment: currentStage.label,
                      participantIds: allParticipantIds,
                      onTap: (id) => onParticipantTap(context, id),
                      avatarColor: Colors.grey,
                      participants: participants,
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: ParticipantGrid(
                      title: 'Tracked Participants',
                      segment: currentStage.label,
                      participantIds: trackedParticipantIds,
                      onTap: null, // no tap in tracked
                      avatarColor: currentStage == Segment.swimming
                          ? Colors.orange
                          : currentStage == Segment.cycling
                              ? Colors.yellow
                              : Colors.green,
                      participants: participants,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
