import 'package:race_tracking_app/models/race_timer.dart';
import 'package:race_tracking_app/models/status.dart';

class RaceTimerDto {
  static RaceTimer fromJson(Map<String, dynamic> json) {
    return RaceTimer(
      startTime: json['startTime'] != null ? DateTime.parse(json['startTime']) : null,
      endTime: json['endTime'] != null ? DateTime.parse(json['endTime']) : null,
      status: Status.values.firstWhere(
        (e) => e.name == json['status'],
        orElse: () => Status.notStarted,
      ),
    );
  }

  static Map<String, dynamic> toJson(RaceTimer raceTimer) {
    return {
      'startTime': raceTimer.startTime?.toIso8601String(),
      'endTime': raceTimer.endTime?.toIso8601String(),
      'status': raceTimer.status.name,
    };
  }
}
