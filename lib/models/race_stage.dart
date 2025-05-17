import 'status.dart';

class RaceStage {
  final DateTime? startTime;
  final DateTime? endTime;
  final Status status;

  RaceStage({this.startTime, this.endTime, required this.status});
}
