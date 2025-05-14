import 'package:race_tracking_app/models/race_stage.dart';
import 'package:race_tracking_app/models/status.dart';

class RaceStageDto {
  static RaceStage fromJson(Map<String, dynamic> json) {
    return RaceStage(
      startTime: json['startTime'] != null ? DateTime.parse(json['startTime']) : null,
      endTime: json['endTime'] != null ? DateTime.parse(json['endTime']) : null,
      status: Status.values.firstWhere(
        (e) => e.name == json['status'],
        orElse: () => Status.notStarted,
      ),
    );
  }

  static Map<String, dynamic> toJson(RaceStage raceStage) {
    return {
      'startTime': raceStage.startTime?.toIso8601String(),
      'endTime': raceStage.endTime?.toIso8601String(),
      'status': raceStage.status.name,
    };
  }
}
