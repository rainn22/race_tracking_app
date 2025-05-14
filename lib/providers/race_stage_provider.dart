import 'dart:async';
import 'package:flutter/material.dart';
import 'package:race_tracking_app/models/race_stage.dart';
import 'package:race_tracking_app/models/status.dart';
import 'package:race_tracking_app/repositories/race_stage_repository.dart';

class RaceStageProvider with ChangeNotifier {
  final RaceStageRepository repository;

  RaceStageProvider(this.repository);

  RaceStage? _raceStage;
  RaceStage? get raceStage => _raceStage;

  Timer? _timer;

  Future<void> loadRaceStage() async {
    _raceStage = await repository.fetchRaceStage();
    notifyListeners();
  }

  Future<void> startRace() async {
    if (_raceStage?.status == Status.notStarted) {
      await repository.startRace();
      await loadRaceStage();
      _startLiveTimer();
    }
  }

  Future<void> restartRace() async {
    if (_raceStage?.status == Status.finished) {
      await repository.restartRace();
      await loadRaceStage();
      _startLiveTimer();
    }
  }

  Future<void> endRace() async {
    await repository.endRace();
    await loadRaceStage();
    _stopLiveTimer();
  }

  void _startLiveTimer() {
    _timer?.cancel();
    _timer = Timer.periodic(const Duration(seconds: 1), (_) {
      if (_raceStage?.startTime != null) {
        notifyListeners();
      }
    });
  }

  void _stopLiveTimer() {
    _timer?.cancel();
  }

  String get formattedDuration {
    if (_raceStage?.startTime == null) return "00:00:00";

    final duration = DateTime.now().difference(_raceStage!.startTime!);
    final hours = duration.inHours;
    final minutes = duration.inMinutes % 60;
    final seconds = duration.inSeconds % 60;
    return "${_twoDigits(hours)}:${_twoDigits(minutes)}:${_twoDigits(seconds)}";
  }

  String _twoDigits(int value) => value.toString().padLeft(2, '0');
}
