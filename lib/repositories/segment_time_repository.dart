import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;

abstract class SegmentTimeRepository {
  Future<void> logSegmentEndTime({
    required String participantId,
    required String segment,
  });
}

class FirebaseSegmentTimeRepository extends SegmentTimeRepository {
  final String baseUrl;
  final String collection;

  FirebaseSegmentTimeRepository({
    required this.baseUrl,
    required this.collection,
  });

  @override
  Future<void> logSegmentEndTime({
    required String participantId,
    required String segment,
  }) async {
    final segmentUri = Uri.parse('$baseUrl$collection/$participantId/$segment/endTime.json');

    // Check if endTime already exists
    final checkResponse = await http.get(segmentUri);
    if (checkResponse.statusCode == HttpStatus.ok || checkResponse.statusCode == HttpStatus.created) {
      final existingTime = json.decode(checkResponse.body);
      if (existingTime != null) {
        print("Already recorded endTime: $existingTime");
        return;
      }
    } else if (checkResponse.statusCode != HttpStatus.notFound) {
      throw Exception("Failed to check existing end time. Status code: ${checkResponse.statusCode}");
    }

    final now = DateTime.now().toIso8601String();

    final response = await http.put(
      segmentUri,
      headers: {'Content-Type': 'application/json'},
      body: json.encode(now),
    );

    if (response.statusCode != HttpStatus.ok && response.statusCode != HttpStatus.noContent) {
      throw Exception("Failed to set end time. Status code: ${response.statusCode}");
    }
  }
}
