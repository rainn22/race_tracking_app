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
class Participant {
  final String id;
  final String name;
  final int bib;

  Participant({required this.id, required this.name, required this.bib});

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Participant &&
          runtimeType == other.runtimeType &&
          id == other.id;

  @override
  int get hashCode => id.hashCode;
}
