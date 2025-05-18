import 'segment.dart';

class SegmentStage {
  final DateTime? endTime;

  SegmentStage({
    this.endTime,
  });
}

class SegmentTime {
  final String id;
  final String participantId;
  final Map<Segment, SegmentStage> segments;

  SegmentTime({
    required this.id,
    required this.participantId,
    required this.segments,
  });
}
