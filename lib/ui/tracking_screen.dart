import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:race_tracking_app/models/segment.dart';
import 'package:race_tracking_app/models/status.dart';
import 'package:race_tracking_app/providers/race_stage_provider.dart';
import 'package:race_tracking_app/providers/participant_provider.dart';
import 'package:race_tracking_app/ui/widgets/participant_grid.dart';
import 'package:race_tracking_app/utils/constants.dart';
import 'package:race_tracking_app/utils/widgets/race_time_stamp.dart';
import 'package:race_tracking_app/utils/status_color.dart';

class TrackingScreen extends StatefulWidget {
  const TrackingScreen({super.key});

  @override
  State<TrackingScreen> createState() => _TrackingScreenState();
}

class _TrackingScreenState extends State<TrackingScreen> {
  Segment currentStage = Segment.swim;

  final Map<Segment, Map<String, DateTime?>> allParticipants = {
    Segment.swim: {},
    Segment.cycling: {},
    Segment.run: {},
  };

  final Map<Segment, Map<String, DateTime?>> trackedParticipants = {
    Segment.swim: {},
    Segment.cycling: {},
    Segment.run: {},
  };

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final participantProvider = context.read<ParticipantProvider>();
    final participants = participantProvider.participantState?.data ?? [];

    if (allParticipants[Segment.swim]!.isEmpty && participants.isNotEmpty) {
      setState(() {
        for (final p in participants) {
          allParticipants[Segment.swim]![p.name] = null;
        }
      });
    }
  }

  void onParticipantTap(String name) {
    final now = DateTime.now();

    setState(() {
      if (!trackedParticipants[currentStage]!.containsKey(name)) {
        // Move from all to tracked
        trackedParticipants[currentStage]![name] = now;
        allParticipants[currentStage]!.remove(name);

        // Prepare next stage
        if (currentStage == Segment.swim) {
          allParticipants[Segment.cycling]![name] = null;
        } else if (currentStage == Segment.cycling) {
          allParticipants[Segment.run]![name] = null;
        }
      } else {
        // Revert if tapped again
        trackedParticipants[currentStage]!.remove(name);
        allParticipants[currentStage]![name] = null;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final timerProvider = context.watch<RaceStageProvider>();
    final status = timerProvider.raceStage?.status ?? Status.notStarted;
    final startTime = timerProvider.raceStage?.startTime;
    final endTime = timerProvider.raceStage?.endTime;

    final participantProvider = context.watch<ParticipantProvider>();
    final participants = participantProvider.participantState?.data ?? [];

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
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
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
            ToggleButtons(
              isSelected: [
                currentStage == Segment.swim,
                currentStage == Segment.cycling,
                currentStage == Segment.run,
              ],
              onPressed: (int index) {
                setState(() {
                  currentStage = Segment.values[index];
                });
              },
              children: const [
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16),
                  child: Text("Swim"),
                ),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16),
                  child: Text("Cycle"),
                ),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16),
                  child: Text("Run"),
                ),
              ],
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
                      namesWithTime: allParticipants[currentStage]!,
                      onTap: onParticipantTap,
                      avatarColor: Colors.grey,
                      participants: participants,
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: ParticipantGrid(
                      title: 'Tracked Participants',
                      namesWithTime: trackedParticipants[currentStage]!,
                      onTap: onParticipantTap,
                      avatarColor: currentStage == Segment.swim
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
