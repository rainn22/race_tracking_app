import 'package:firebase_database/firebase_database.dart';
import 'package:race_tracking_app/models/participant.dart';


class ParticipantRepository {
  final FirebaseDatabase _database = FirebaseDatabase.instance;
  final String _participantsPath = 'participants'; // Adjust path if needed

  Future<List<Participant>> getParticipants() async {
    try {
      final DatabaseEvent event = await _database.ref(_participantsPath).once();
      final DataSnapshot snapshot = event.snapshot;

      if (snapshot.value != null && snapshot.value is Map) {
        final Map<dynamic, dynamic> participantsMap = snapshot.value as Map;
        final List<Participant> participantsList = [];
        participantsMap.forEach((key, value) {
          participantsList.add(Participant(
            bib: key.toString(), // The key in the JSON tree can be the ID
            name: value['name'] as String?,
            isActive: value['isActive'] as bool?,
            // Map other fields accordingly based on your Realtime Database structure
          ));
        });
        return participantsList;
      } else {
        return [];
      }
    } catch (e) {
      print('Error fetching participants from Realtime Database: $e');
      return [];
    }
  }

  // Example to get active participants (adjust based on your data)
  Future<List<Participant>> getActiveParticipants() async {
    final List<Participant> allParticipants = await getParticipants();
    return allParticipants.where((participant) => participant.isActive == true).toList();
  }

  // Example to update a participant's tracking status (you'll need to define how you store this)
  Future<void> updateTrackingStatus(String participantId, bool isTracked) async {
    try {
      await _database.ref('trackedParticipants/$participantId').set(isTracked);
    } catch (e) {
      print('Error updating tracking status: $e');
    }
  }

  // You can add more methods as needed
}