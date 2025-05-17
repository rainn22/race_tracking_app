import 'package:race_tracking_app/models/race_stage.dart';
import 'package:race_tracking_app/models/segment.dart';

class SegmentController {
  final Map<String, Map<Segment, RaceStage>> participantStages;

  SegmentController({required this.participantStages});

  RaceStage? getRaceStage(String participantId, Segment segment) {
    return participantStages[participantId]?[segment];
  }

  void setRaceStage(String participantId, Segment segment, RaceStage raceStage) {
    participantStages.putIfAbsent(participantId, () => {});
    participantStages[participantId]![segment] = raceStage;
  }

  Map<Segment, RaceStage>? getAllStages(String participantId) {
    return participantStages[participantId];
  }

  Map<String, Map<Segment, RaceStage>> get allStages => participantStages;


  Map<Segment, List<Map<String, dynamic>>> getEndTimesPerSegment({
    required Map<String, int> bibMap,
    required Map<String, String> nameMap,
  }) {
    final result = <Segment, List<Map<String, dynamic>>>{};

    for (final entry in participantStages.entries) {
      final participantId = entry.key;
      final segments = entry.value;

      for (final segmentEntry in segments.entries) {
        final segment = segmentEntry.key;
        final stage = segmentEntry.value;

        if (stage.endTime != null) {
          result.putIfAbsent(segment, () => []);
          result[segment]!.add({
            'id': participantId,
            'name': nameMap[participantId] ?? 'Unknown',
            'bib': bibMap[participantId] ?? 0,
            'endTime': stage.endTime,
          });
        }
      }
    }

    return result;
  }
}
