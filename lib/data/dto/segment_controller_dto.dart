import 'package:race_tracking_app/data/dto/race_stage_dto.dart';
import 'package:race_tracking_app/models/race_stage.dart';
import 'package:race_tracking_app/models/segment.dart';
import '../../models/segment_controller.dart';

class SegmentControllerDto {
  static SegmentController fromJson(Map<String, dynamic> json) {
    final participantStages = <String, Map<Segment, RaceStage>>{};

    json.forEach((participantId, segmentMap) {
      final stages = <Segment, RaceStage>{};
      (segmentMap as Map<String, dynamic>).forEach((segmentName, stageJson) {
        final segment = Segment.values.firstWhere(
          (seg) => seg.name == segmentName,
          orElse: () => Segment.swimming,
        );
        final stage = RaceStageDto.fromJson(stageJson);
        stages[segment] = stage;
      });
      participantStages[participantId] = stages;
    });

    return SegmentController(participantStages: participantStages);
  }

  static Map<String, dynamic> toJson(SegmentController controller) {
    final json = <String, dynamic>{};

    controller.participantStages.forEach((participantId, segmentMap) {
      final segmentJson = <String, dynamic>{};
      segmentMap.forEach((segment, raceStage) {
        segmentJson[segment.name] = RaceStageDto.toJson(raceStage);
      });
      json[participantId] = segmentJson;
    });

    return json;
  }
}
