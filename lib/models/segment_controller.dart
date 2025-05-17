import 'segment.dart';
import 'race_stage.dart';

class SegmentController {
  final Map<String, Map<Segment, RaceStage>> participantStages;

  SegmentController({required this.participantStages});

  RaceStage? getRaceStage(String participantId, Segment segment) {
    return participantStages[participantId]?[segment];
  }

  void setRaceStage(
      String participantId, Segment segment, RaceStage raceStage) {
    participantStages.putIfAbsent(participantId, () => {});
    participantStages[participantId]![segment] = raceStage;
  }
}
