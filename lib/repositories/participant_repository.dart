import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:race_tracking_app/data/dto/participant_dto.dart';
import 'package:race_tracking_app/models/participant.dart';

abstract class ParticipantRepository {
  Future<Participant> addParticipant({required String name, required int bib});
  Future<List<Participant>> getParticipants();
  Future<void> deleteParticipant(String id);
  Future<void> updateParticipant(Participant participant);
}

class FirebaseParticipantRepository extends ParticipantRepository {
  static const String baseUrl =
      'https://race-tracking-app-c58e7-default-rtdb.asia-southeast1.firebasedatabase.app/';
  static const String collection = "participant";
  static const String allUrl = '$baseUrl/$collection.json';

  @override
  Future<Participant> addParticipant(
      {required String name, required int bib}) async {
    Uri uri = Uri.parse(allUrl);

    final newParticipantData = {'name': name, 'bib': bib};
    final http.Response response = await http.post(
      uri,
      headers: {'Content-Type': 'application/json'},
      body: json.encode(newParticipantData),
    );

    if (response.statusCode != HttpStatus.ok) {
      throw Exception('Failed to add participant');
    }

    final newId = json.decode(response.body)['name'];
    return Participant(id: newId, name: name, bib: bib);
  }

  @override
  Future<List<Participant>> getParticipants() async {
    Uri uri = Uri.parse(allUrl);
    final http.Response response = await http.get(uri);

    if (response.statusCode != HttpStatus.ok &&
        response.statusCode != HttpStatus.created) {
      throw Exception('Failed to load participants');
    }

    final data = json.decode(response.body) as Map<String, dynamic>?;
    if (data == null) return [];

    return data.entries
        .map((entry) => ParticipantDto.fromJson(entry.key, entry.value))
        .toList();
  }

  @override
  Future<void> deleteParticipant(String id) async {
    Uri uri = Uri.parse('$baseUrl/$collection/$id.json');
    final response = await http.delete(uri);

    if (response.statusCode != HttpStatus.ok &&
        response.statusCode != HttpStatus.noContent) {
      throw Exception('Failed to delete participant');
    }
  }

  @override
  Future<void> updateParticipant(Participant participant) async {
    Uri uri = Uri.parse('$baseUrl/$collection/${participant.id}.json');
    final response = await http.put(
      uri,
      headers: {'Content-Type': 'application/json'},
      body: json.encode({
        'name': participant.name,
        'bib': participant.bib,
      }),
    );

    if (response.statusCode != HttpStatus.ok) {
      throw Exception('Failed to update participant');
    }
  }
}
