import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:race_tracking_app/data/dto/segment_controller_dto.dart';
import '../models/segment_controller.dart';
import '../models/segment.dart';

abstract class SegmentControllerRepository {
  Future<SegmentController> fetchSegmentController();
  Future<void> startSegment(String participantId, Segment segment);
  Future<void> finishSegment(String participantId, Segment segment);
  Future<void> resetAll();
}

class FirebaseSegmentControllerRepository extends SegmentControllerRepository {
  static const String baseUrl =
      'https://race-tracking-app-c58e7-default-rtdb.asia-southeast1.firebasedatabase.app/';
  static const String segmentControllerUrl = '${baseUrl}segment_controller.json';

  @override
  Future<SegmentController> fetchSegmentController() async {
    final uri = Uri.parse(segmentControllerUrl);
    final response = await http.get(uri);

    if (response.statusCode != HttpStatus.ok &&
        response.statusCode != HttpStatus.created) {
      throw Exception("Failed to load segment controller");
    }

    final data = json.decode(response.body) as Map<String, dynamic>? ?? {};
    return SegmentControllerDto.fromJson(data);
  }

  @override
  Future<void> startSegment(String participantId, Segment segment) async {
    final now = DateTime.now().toIso8601String();
    final uri = Uri.parse('$baseUrl/segment_controller/$participantId/${segment.name}.json');

    final body = json.encode({
      'startTime': now,
      'endTime': null,
      'status': 'started',
    });

    final response = await http.put(uri, headers: {'Content-Type': 'application/json'}, body: body);

    if (response.statusCode != HttpStatus.ok &&
        response.statusCode != HttpStatus.noContent) {
      throw Exception("Failed to start segment");
    }
  }

  @override
  Future<void> finishSegment(String participantId, Segment segment) async {
    final now = DateTime.now().toIso8601String();
    final uri = Uri.parse('$baseUrl/segment_controller/$participantId/${segment.name}.json');

    final body = json.encode({
      'endTime': now,
      'status': 'finished',
    });

    final response = await http.patch(uri, headers: {'Content-Type': 'application/json'}, body: body);

    if (response.statusCode != HttpStatus.ok &&
        response.statusCode != HttpStatus.noContent) {
      throw Exception("Failed to finish segment");
    }
  }

  @override
  Future<void> resetAll() async {
    final uri = Uri.parse(segmentControllerUrl);

    final response = await http.put(
      uri,
      headers: {'Content-Type': 'application/json'},
      body: json.encode({}),
    );

    if (response.statusCode != HttpStatus.ok &&
        response.statusCode != HttpStatus.noContent) {
      throw Exception("Failed to reset segment controller");
    }
  }
}
