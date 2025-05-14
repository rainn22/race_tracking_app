import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:race_tracking_app/models/status.dart';
import 'package:race_tracking_app/models/race_stage.dart';
import 'package:race_tracking_app/data/dto/race_stage_dto.dart';

abstract class RaceStageRepository {
  Future<RaceStage> fetchRaceStage();
  Future<void> startRace();
  Future<void> endRace();
  Future<void> restartRace();
}

class FirebaseRaceStageRepository extends RaceStageRepository {
  static const String baseUrl =
      'https://race-tracking-app-c58e7-default-rtdb.asia-southeast1.firebasedatabase.app/';
  static const String raceStageUrl = '${baseUrl}race_timer.json';

  @override
  Future<RaceStage> fetchRaceStage() async {
    final uri = Uri.parse(raceStageUrl);
    final response = await http.get(uri);

    if (response.statusCode != HttpStatus.ok &&
        response.statusCode != HttpStatus.created) {
      throw Exception("Failed to load race timer");
    }

    final data = json.decode(response.body);
    return RaceStageDto.fromJson(data ?? {});
  }

  @override
  Future<void> startRace() async {
    final uri = Uri.parse(raceStageUrl);
    final now = DateTime.now();

    final raceStage = RaceStage(
      startTime: now,
      endTime: null,
      status: Status.started,
    );

    final response = await http.put(
      uri,
      headers: {'Content-Type': 'application/json'},
      body: json.encode(RaceStageDto.toJson(raceStage)),
    );

    if (response.statusCode != HttpStatus.ok &&
        response.statusCode != HttpStatus.noContent) {
      throw Exception("Failed to start race");
    }
  }

  @override
  Future<void> endRace() async {
    final uri = Uri.parse(raceStageUrl);
    final now = DateTime.now();

    final response = await http.patch(
      uri,
      headers: {'Content-Type': 'application/json'},
      body: json.encode({
        'endTime': now.toIso8601String(),
        'status': Status.finished.name,
      }),
    );

    if (response.statusCode != HttpStatus.ok &&
        response.statusCode != HttpStatus.noContent) {
      throw Exception("Failed to end race");
    }
  }

  @override
  Future<void> restartRace() async {
    final uri = Uri.parse(raceStageUrl);
    final now = DateTime.now();

    final raceStage = RaceStage(
      startTime: now,
      endTime: null,
      status: Status.started,
    );

    final response = await http.put(
      uri,
      headers: {'Content-Type': 'application/json'},
      body: json.encode(RaceStageDto.toJson(raceStage)),
    );

    if (response.statusCode != HttpStatus.ok &&
        response.statusCode != HttpStatus.noContent) {
      throw Exception("Failed to restart race");
    }
  }
}
