import 'dart:async';
import 'package:flutter/material.dart';
import 'package:race_tracking_app/repositories/segment_controller_repository.dart';
import '../models/segment_controller.dart';
import '../models/segment.dart';

class SegmentControllerProvider with ChangeNotifier {
  final SegmentControllerRepository repository;

  SegmentController? _controller;
  SegmentController? get controller => _controller;

  Timer? _timer;

  SegmentControllerProvider(this.repository);

  Future<void> loadSegmentController() async {
    _controller = await repository.fetchSegmentController();
    notifyListeners();
  }

  Future<void> startSegment(String participantId, Segment segment) async {
    await repository.startSegment(participantId, segment);
    await loadSegmentController();
  }

  Future<void> finishSegment(String participantId, Segment segment) async {
    await repository.finishSegment(participantId, segment);
    await loadSegmentController();
  }

  Future<void> resetAll() async {
    await repository.resetAll();
    await loadSegmentController();
  }
}
