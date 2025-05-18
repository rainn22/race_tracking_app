import 'package:flutter/material.dart';
import 'package:race_tracking_app/repositories/segment_time_repository.dart';

class SegmentTimeProvider with ChangeNotifier {
  final SegmentTimeRepository repository;

  final Map<String, Map<String, String>> _segmentTimes = {};

  SegmentTimeProvider(this.repository);

  Map<String, Map<String, String>> get segmentTimes => _segmentTimes;

  Future<void> updateSegmentEndTime({
    required String participantId,
    required String segment,
  }) async {
    await repository.logSegmentEndTime(
      participantId: participantId,
      segment: segment,
    );

    final now = DateTime.now().toIso8601String();

    _segmentTimes[participantId] ??= {};
    _segmentTimes[participantId]![segment] = now;

    notifyListeners();
  }

  String? getEndTime(String participantId, String segment) {
    return _segmentTimes[participantId]?[segment];
  }

  void removeSegmentEndTime({
    required String participantId,
    required String segment,
  }) {
    if (_segmentTimes.containsKey(participantId)) {
      _segmentTimes[participantId]!.remove(segment);
      if (_segmentTimes[participantId]!.isEmpty) {
        _segmentTimes.remove(participantId);
      }
      notifyListeners();
    }
  }
}
