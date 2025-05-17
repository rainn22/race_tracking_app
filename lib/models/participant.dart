import 'package:firebase_database/firebase_database.dart';

class Participant {
  final String? bib;
  final String? name;
  final bool? isActive;
  // Add other relevant fields

  Participant({this.bib, this.name, this.isActive});

  factory Participant.fromRTDB(DataSnapshot snapshot) {
    final Map<dynamic, dynamic>? value = snapshot.value as Map?;
    return Participant(
      bib: snapshot.key, // The key in the Firebase Realtime Database
      name: value?['name'] as String?,
      isActive: value?['isActive'] as bool?,
      // Map other fields accordingly
    );
  }

  // Optional: Convert back to Realtime Database data (Map)
  Map<String, dynamic> toRTDB() {
    return {
      'name': name,
      'isActive': isActive,
      // Add other fields
    };
  }
}