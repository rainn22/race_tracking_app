import 'status.dart';

class RaceTimer {
  final DateTime? startTime;
  final DateTime? endTime;
  final Status status;

  RaceTimer({this.startTime, this.endTime, required this.status});
}
