// tracking_screen.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:race_tracking_app/models/segment.dart';
import 'package:race_tracking_app/models/status.dart';
import 'package:race_tracking_app/providers/race_stage_provider.dart';
import 'package:race_tracking_app/providers/participant_provider.dart';
import 'package:race_tracking_app/ui/widgets/participant_grid.dart';
import 'package:race_tracking_app/utils/constants.dart';
import 'package:race_tracking_app/utils/widgets/segment_button.dart';
import 'package:race_tracking_app/utils/widgets/time_stamp_card.dart';

class TrackingScreen extends StatefulWidget {
  const TrackingScreen({super.key});

  @override
  State<TrackingScreen> createState() => _TrackingScreenState();
}

class _TrackingScreenState extends State<TrackingScreen> {
  // Start with the swimming stage data displayed
  Segment _currentStage = Segment.swimming;

  final Map<Segment, Map<String, DateTime?>> allParticipants = {
    Segment.swimming: {},
    Segment.cycling: {},
    Segment.running: {},
  };

  final Map<Segment, Map<String, DateTime?>> trackedParticipants = {
    Segment.swimming: {},
    Segment.cycling: {},
    Segment.running: {},
  };

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final participantProvider = context.read<ParticipantProvider>();
    final participants = participantProvider.participantState?.data ?? [];

    if (allParticipants[Segment.swimming]!.isEmpty && participants.isNotEmpty) {
      setState(() {
        for (final p in participants) {
          allParticipants[Segment.swimming]![p.name] = null;
        }
      });
    }
  }

  void _onSegmentSelected(int index) {
    setState(() {
      _currentStage = Segment.values[index];
    });
  }

  void _onParticipantTap(String name) {
    final now = DateTime.now();

    setState(() {
      if (!trackedParticipants[_currentStage]!.containsKey(name)) {
        trackedParticipants[_currentStage]![name] = now;
        allParticipants[_currentStage]!.remove(name);
        if (_currentStage == Segment.swimming) {
          allParticipants[Segment.cycling]![name] = null;
        } else if (_currentStage == Segment.cycling) {
          allParticipants[Segment.running]![name] = null;
        }
      } else {
        trackedParticipants[_currentStage]!.remove(name);
        allParticipants[_currentStage]![name] = null;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final timerProvider = context.watch<RaceStageProvider>();
    final status = timerProvider.raceStage?.status ?? Status.notStarted;
    final startTime = timerProvider.raceStage?.startTime;
    final endTime = timerProvider.raceStage?.endTime ?? DateTime.now();

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
            TimestampCard(status: status, startTime: startTime, endTime: endTime),
            const SizedBox(height: 10),
            SegmentButtons(
              currentStage: _currentStage,
              onSegmentSelected: _onSegmentSelected,
            ),
            const SizedBox(height: 10),
            Expanded(
              child: Column( // Changed Row to Column
                children: [
                  Expanded(
                    child: ParticipantGrid(
                      title: 'All Participants',
                      namesWithTime: allParticipants[_currentStage]!,
                      onTap: _onParticipantTap,
                      avatarColor: Colors.grey,
                      participants: participants,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Expanded(
                    child: ParticipantGrid(
                      title: 'Tracked Participants',
                      namesWithTime: trackedParticipants[_currentStage]!,
                      onTap: _onParticipantTap,
                      avatarColor: _currentStage == Segment.swimming
                          ? Colors.orange
                          : _currentStage == Segment.cycling
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