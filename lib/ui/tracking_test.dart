// import 'package:flutter/material.dart';
// import 'package:race_tracking_app/models/participant.dart';
// import 'package:race_tracking_app/repositories/participant_repository.dart';

// class TrackingPage extends StatefulWidget {
//   const TrackingPage({super.key});

//   @override
//   State<TrackingPage> createState() => _TrackingPageState();
// }

// class _TrackingPageState extends State<TrackingPage> {
//   final ParticipantRepository _participantRepository = FirebaseParticipantRepository();
//   List<Participant> allParticipants = [];
//   List<Participant> trackingParticipants = [];
//   List<Participant> trackedParticipants = [];
//   bool showAllTracking = true;
//   bool showAllTracked = true;

//   @override
//   void initState() {
//     super.initState();
//     loadParticipants();
//   }

//   Future<void> loadParticipants() async {
//     final participants = await _participantRepository.getParticipants();
//     setState(() {
//       allParticipants = participants;
//       trackingParticipants = List.from(participants); // Start tracking all
//       trackedParticipants = [];
//     });
//   }

//   void moveToTracked(Participant participant) {
//     setState(() {
//       trackingParticipants.remove(participant);
//       trackedParticipants.add(participant);
//     });
//   }

//   void moveToTracking(Participant participant) {
//     setState(() {
//       trackedParticipants.remove(participant);
//       trackingParticipants.add(participant);
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('Track Participants'),
//         backgroundColor: Colors.grey[900],
//       ),
//       backgroundColor: Colors.grey[800],
//       body: SingleChildScrollView(
//         padding: const EdgeInsets.all(16.0),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             // Tracking Section
//             buildSectionTitle('Tracking Participants', showAllTracking, (val) {
//               setState(() => showAllTracking = val);
//             }),
//             const SizedBox(height: 8),
//             buildParticipantWrap(getDisplayedTracking(), moveToTracked, Colors.grey[600]),

//             const SizedBox(height: 20),

//             // Tracked Section
//             buildSectionTitle('Tracked Participants', showAllTracked, (val) {
//               setState(() => showAllTracked = val);
//             }),
//             const SizedBox(height: 8),
//             buildParticipantWrap(getDisplayedTracked(), moveToTracking, Colors.orange[600]),
//           ],
//         ),
//       ),
//     );
//   }

//   Widget buildSectionTitle(String title, bool showAll, Function(bool) onToggle) {
//     return Row(
//       mainAxisAlignment: MainAxisAlignment.spaceBetween,
//       children: [
//         Text(title, style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.white)),
//         Row(
//           children: [
//             TextButton(
//               onPressed: () => onToggle(true),
//               style: TextButton.styleFrom(
//                 foregroundColor: showAll ? Colors.blueAccent : Colors.grey[400],
//               ),
//               child: const Text('All', style: TextStyle(color: Colors.white)),
//             ),
//             const SizedBox(width: 8),
//             TextButton(
//               onPressed: () => onToggle(false),
//               style: TextButton.styleFrom(
//                 foregroundColor: showAll ? Colors.grey[400] : Colors.blueAccent,
//               ),
//               child: const Text('Active', style: TextStyle(color: Colors.white)),
//             ),
//           ],
//         ),
//       ],
//     );
//   }

//   Widget buildParticipantWrap(
//       List<Participant> participants,
//       Function(Participant) onPressed,
//       Color? color,
//       ) {
//     return Wrap(
//       spacing: 8.0,
//       runSpacing: 8.0,
//       children: participants.map((participant) {
//         return ElevatedButton(
//           onPressed: () => onPressed(participant),
//           style: ElevatedButton.styleFrom(
//             backgroundColor: color,
//             foregroundColor: Colors.white,
//             padding: const EdgeInsets.all(16.0),
//             shape: RoundedRectangleBorder(
//               borderRadius: BorderRadius.circular(20.0),
//             ),
//           ),
//           child: Column(
//             mainAxisSize: MainAxisSize.min,
//             children: [
//               Text(participant.bib.toString(), style: const TextStyle(fontSize: 18)),
//               Text(participant.name),
//             ],
//           ),
//         );
//       }).toList(),
//     );
//   }
// }
