import 'package:race_tracking_app/models/participant.dart';

class ParticipantDto {
  static Participant fromJson(String id, Map<String, dynamic> json) {
    return Participant(id: id, name: json['name'], bib: json['bib']);
  }

  static Map<String, dynamic> toJson(Participant participant) {
    return {'name': participant.name, 'bib': participant.bib};
  }
}