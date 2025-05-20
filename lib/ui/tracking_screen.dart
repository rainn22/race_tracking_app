import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:race_tracking_app/models/segment.dart';
import 'package:race_tracking_app/models/status.dart';
import 'package:race_tracking_app/providers/participant_provider.dart';
import 'package:race_tracking_app/providers/race_stage_provider.dart';
import 'package:race_tracking_app/providers/segment_time_provider.dart';
import 'package:race_tracking_app/ui/widgets/participant_grid.dart';
import 'package:race_tracking_app/utils/constants.dart';
import 'package:race_tracking_app/utils/status_color.dart';
import 'package:race_tracking_app/utils/widgets/race_time_stamp.dart';
import 'package:race_tracking_app/utils/widgets/segment_button.dart';

import 'result_screen.dart';

class TrackingScreen extends StatefulWidget {
  const TrackingScreen({super.key});

  @override
  State<TrackingScreen> createState() => _TrackingScreenState();
}

class _TrackingScreenState extends State<TrackingScreen> {
  Segment currentStage = Segment.swimming;
  Map<Segment, Set<String>> trackedParticipants = {
    Segment.swimming: <String>{},
    Segment.cycling: <String>{},
    Segment.running: <String>{},
  };

  void onParticipantTap(BuildContext context, String participantId) async {
    final provider = context.read<SegmentTimeProvider>();
    final isTrackedInCurrentStage = trackedParticipants[currentStage]!.contains(participantId);

    if (isTrackedInCurrentStage) {
      trackedParticipants[currentStage]!.remove(participantId);
      provider.removeSegmentEndTime(
        participantId: participantId,
        segment: currentStage.label,
      );
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Participant untracked for this stage"),
          duration: Duration(milliseconds: 800),
        ),
      );
    } else {
      trackedParticipants[currentStage]!.add(participantId);
      await provider.updateSegmentEndTime(
        participantId: participantId,
        segment: currentStage.label,
      );
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Participant tracked for this stage"),
          duration: Duration(milliseconds: 800),
        ),
      );
    }
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final timerProvider = context.watch<RaceStageProvider>();
    final participantProvider = context.watch<ParticipantProvider>();

    final raceStart = timerProvider.raceStage?.startTime;
    final status = timerProvider.raceStage?.status ?? Status.notStarted;
    final endTime = timerProvider.raceStage?.endTime;
    final allParticipants = participantProvider.participantState?.data ?? [];

    final trackedInCurrent = trackedParticipants[currentStage]!;
    final allInCurrent = allParticipants.where((p) => !trackedInCurrent.contains(p.id)).toList();
    final trackedCurrent = allParticipants.where((p) => trackedInCurrent.contains(p.id)).toList();

    Segment? nextStage;
    if (currentStage == Segment.swimming) {
      nextStage = Segment.cycling;
    } else if (currentStage == Segment.cycling) {
      nextStage = Segment.running;
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text("Triathlon Tracker"),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(AppSpacing.padding),
        child: LayoutBuilder(
          builder: (context, constraints) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Card(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  color: AppColors.white,
                  elevation: 2,
                  child: Padding(
                    padding: EdgeInsets.symmetric(
                      vertical: constraints.maxWidth > 600 ? 20.0 : 16.0,
                      horizontal: AppSpacing.padding,
                    ),
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Text(" ", style: AppTextStyles.textLg),
                            RaceStatus(value: status.label),
                          ],
                        ),
                        SizedBox(height: constraints.maxWidth > 600 ? 10 : 5),
                        RaceTimeStamp(
                          start: raceStart,
                          end: status == Status.finished ? endTime : DateTime.now(),
                        ),
                      ],
                    ),
                  ),
                ),
                SizedBox(height: constraints.maxWidth > 600 ? 30 : 20),
                SegmentButtons(
                  currentStage: currentStage,
                  onSegmentSelected: (index) {
                    setState(() {
                      currentStage = Segment.values[index];
                    });
                  },
                ),
                SizedBox(height: constraints.maxWidth > 600 ? 20 : 10),
                Expanded(
                  child: constraints.maxWidth > 600 // Wider screen: display side-by-side
                      ? Row(
                          children: [
                            Expanded(
                              child: ParticipantGrid(
                                title: 'All Participants',
                                segment: currentStage.label,
                                participants: allInCurrent,
                                onTap: (participant) {
                                  onParticipantTap(context, participant.id);
                                },
                                avatarColor: Colors.grey,
                                raceStartTime: raceStart,
                              ),
                            ),
                            SizedBox(width: constraints.maxWidth * 0.02), // Some spacing
                            Expanded(
                              child: ParticipantGrid(
                                title: 'Tracked Participants',
                                segment: currentStage.label,
                                participants: trackedCurrent,
                                onTap: (participant) {
                                  onParticipantTap(context, participant.id);
                                },
                                avatarColor: currentStage == Segment.swimming
                                    ? Colors.orange
                                    : currentStage == Segment.cycling
                                        ? Colors.yellow
                                        : Colors.green,
                                raceStartTime: raceStart,
                              ),
                            ),
                          ],
                        )
                      : Column( // Smaller screen: display above and below
                          children: [
                            Expanded(
                              child: ParticipantGrid(
                                title: 'All Participants',
                                segment: currentStage.label,
                                participants: allInCurrent,
                                onTap: (participant) {
                                  onParticipantTap(context, participant.id);
                                },
                                avatarColor: Colors.grey,
                                raceStartTime: raceStart,
                              ),
                            ),
                            SizedBox(height: constraints.maxWidth > 600 ? 16 : 8),
                            Expanded(
                              child: ParticipantGrid(
                                title: 'Tracked Participants',
                                segment: currentStage.label,
                                participants: trackedCurrent,
                                onTap: (participant) {
                                  onParticipantTap(context, participant.id);
                                },
                                avatarColor: currentStage == Segment.swimming
                                    ? Colors.orange
                                    : currentStage == Segment.cycling
                                        ? Colors.yellow
                                        : Colors.green,
                                raceStartTime: raceStart,
                              ),
                            ),
                          ],
                        ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}