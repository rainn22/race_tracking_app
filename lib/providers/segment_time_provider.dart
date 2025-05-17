import 'package:flutter/material.dart';
import 'package:race_tracking_app/repositories/segment_time_repository.dart';

class SegmentTimeProvider with ChangeNotifier {
  final SegmentTimeRepository repository;

  // Local cache of endTimes: participantId -> segment -> endTime string
  final Map<String, Map<String, String>> _segmentTimes = {};

  SegmentTimeProvider(this.repository);

  Map<String, Map<String, String>> get segmentTimes => _segmentTimes;

  /// Updates the segment end time by logging to backend and updating cache.
  Future<void> updateSegmentEndTime({
    required String participantId,
    required String segment,
  }) async {
    await repository.logSegmentEndTime(
      participantId: participantId,
      segment: segment,
    );

    // Update local cache with current time (assume success)
    final now = DateTime.now().toIso8601String();

    _segmentTimes[participantId] ??= {};
    _segmentTimes[participantId]![segment] = now;

    notifyListeners();
  }

  /// Gets the end time for a participant's segment, or null if none.
  String? getEndTime(String participantId, String segment) {
    return _segmentTimes[participantId]?[segment];
  }
}
