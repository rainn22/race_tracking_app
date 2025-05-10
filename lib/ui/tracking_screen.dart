// TODO Implement this library.
import 'package:flutter/material.dart';

class TrackingPage extends StatefulWidget {
  const TrackingPage({super.key});

  @override
  State<TrackingPage> createState() => _TrackingPageState();
}

class _TrackingPageState extends State<TrackingPage> {
  // State variables
  DateTime? startTime;
  bool isTracking = false;
  String raceStatus = 'Race in progress'; // Example status
  String currentSegment = 'Run'; // Default to Run
  List<Participant> participants = [
    Participant(id: '#4', name: 'da'),
    Participant(id: '#2', name: 'ka'),
    Participant(id: '#3', name: 'lu'),
    Participant(id: '#1', name: 'ta'),
  ]; // Dummy participant data
  List<Participant> displayedParticipants = [];
  bool showActiveOnly = false;

  @override
  void initState() {
    super.initState();
    displayedParticipants = participants; // Initially show all participants
  }

  // Functions for segment control
  void selectSegment(String segment) {
    setState(() {
      currentSegment = segment;
    });
  }

  // Function to handle the "Track" button for a participant
  void trackParticipant(Participant participant) {
    // Implement your tracking logic here (e.g., navigate to a detailed tracking screen)
    print('Tracking ${participant.id}');
  }

  // Function to filter participants
  void filterParticipants(bool activeOnly) {
    setState(() {
      showActiveOnly = activeOnly;
      if (activeOnly) {
        // In a real app, you'd filter based on some 'isActive' status
        displayedParticipants = participants.where((p) => p.id != '#3').toList(); // Example filter
      } else {
        displayedParticipants = participants;
      }
    });
  }

  // Helper function to format time (simplified for the main timer display)
  String formatTime(DateTime? time) {
    if (time == null) {
      return '00:00:00';
    }
    final Duration difference = time.difference(startTime ?? time);
    twoDigits(int n) => n.toString().padLeft(2, '0');
    final String minutes = twoDigits(difference.inMinutes.remainder(60));
    final String seconds = twoDigits(difference.inSeconds.remainder(60));
    final String hours = twoDigits(difference.inHours);
    return '$hours:$minutes:$seconds';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Race Timer'),
        backgroundColor: Colors.grey[900],
      ),
      backgroundColor: Colors.grey[850],
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            // Race Timer Display
            Center(
              child: Column(
                children: [
                  Text(
                    formatTime(isTracking ? DateTime.now() : startTime),
                    style: const TextStyle(fontSize: 48.0, color: Colors.white),
                  ),
                  const SizedBox(height: 4.0),
                  Text(
                    raceStatus,
                    style: const TextStyle(color: Colors.grey),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20.0),

            // Current Segment
            Text(
              'Current Segment',
              style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.white70),
            ),
            const SizedBox(height: 8.0),
            Row(
              children: [
                ElevatedButton(
                  onPressed: () => selectSegment('Run'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: currentSegment == 'Run' ? Colors.red : Colors.grey[700],
                  ),
                  child: const Row(
                    children: [
                      Icon(Icons.directions_run, color: Colors.white),
                      SizedBox(width: 4.0),
                      Text('Run', style: TextStyle(color: Colors.white)),
                    ],
                  ),
                ),
                const SizedBox(width: 8.0),
                ElevatedButton(
                  onPressed: () => selectSegment('Swim'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: currentSegment == 'Swim' ? Colors.blue : Colors.grey[700],
                  ),
                  child: const Row(
                    children: [
                      Icon(Icons.pool, color: Colors.white),
                      SizedBox(width: 4.0),
                      Text('Swim', style: TextStyle(color: Colors.white)),
                    ],
                  ),
                ),
                const SizedBox(width: 8.0),
                ElevatedButton(
                  onPressed: () => selectSegment('Cycle'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: currentSegment == 'Cycle' ? Colors.green : Colors.grey[700],
                  ),
                  child: const Row(
                    children: [
                      Icon(Icons.directions_bike, color: Colors.white),
                      SizedBox(width: 4.0),
                      Text('Cycle', style: TextStyle(color: Colors.white)),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20.0),

            // Track Participants
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Track Participants',
                  style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white70),
                ),
                Row(
                  children: [
                    TextButton(
                      onPressed: () => filterParticipants(false),
                      style: TextButton.styleFrom(
                        foregroundColor: showActiveOnly ? Colors.grey : Colors.blueAccent,
                      ),
                      child: const Text('All', style: TextStyle(color: Colors.white)),
                    ),
                    const SizedBox(width: 8.0),
                    TextButton(
                      onPressed: () => filterParticipants(true),
                      style: TextButton.styleFrom(
                        foregroundColor: showActiveOnly ? Colors.blueAccent : Colors.grey,
                      ),
                      child: const Text('Active', style: TextStyle(color: Colors.white)),
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 8.0),
            Expanded(
              child: GridView.builder(
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 3,
                  childAspectRatio: 1.0,
                  crossAxisSpacing: 8.0,
                  mainAxisSpacing: 8.0,
                ),
                itemCount: displayedParticipants.length,
                itemBuilder: (context, index) {
                  final participant = displayedParticipants[index];
                  return Container(
                    padding: const EdgeInsets.all(8.0),
                    decoration: BoxDecoration(
                      color: Colors.grey[700],
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(participant.id, style: const TextStyle(color: Colors.white)),
                        Text(participant.name, style: const TextStyle(color: Colors.white)),
                        SizedBox(
                          width: double.infinity,
                          child: ElevatedButton(
                            onPressed: () => trackParticipant(participant),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.green,
                            ),
                            child: const Text('Track', style: TextStyle(color: Colors.white)),
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class Participant {
  final String id;
  final String name;

  Participant({required this.id, required this.name});
}