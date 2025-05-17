import 'package:race_tracking_app/models/segment.dart';
import 'package:race_tracking_app/models/segment_time.dart';

class SegmentTimeDto {
  static SegmentTime fromJson(String id, Map<String, dynamic> json) {
    final participantId = json['participantId'] as String;

    final segmentsJson = json['segments'] as Map<String, dynamic>;
    final segments = <Segment, SegmentStage>{};

    segmentsJson.forEach((key, value) {
      final segment = Segment.values.firstWhere(
        (e) => e.name == key,
        orElse: () => throw ArgumentError('Unknown segment: $key'),
      );

      segments[segment] = SegmentStage(
        endTime: value['endTime'] != null ? DateTime.parse(value['endTime']) : null,
      );
    });

    return SegmentTime(
      id: id,
      participantId: participantId,
      segments: segments,
    );
  }

  static Map<String, dynamic> toJson(SegmentTime segmentTime) {
    final segmentsJson = <String, dynamic>{};

    segmentTime.segments.forEach((segment, stage) {
      segmentsJson[segment.name] = {
        'endTime': stage.endTime?.toIso8601String(),
      };
    });

    return {
      'participantId': segmentTime.participantId,
      'segments': segmentsJson,
    };
  }
}
