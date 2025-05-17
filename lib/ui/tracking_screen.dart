import 'package:flutter/material.dart';
import 'package:race_tracking_app/models/participant.dart';
import 'package:race_tracking_app/repositories/mock/participant_repo.dart';
//import 'package:race_tracking_app/utils/constants.dart';

// class TrackingScreen extends StatefulWidget {
//   const TrackingScreen({super.key});

  @override
  State<TrackingScreen> createState() => _TrackingScreenState();
}
class _TrackingScreenState extends State<TrackingScreen> {
  final ParticipantRepository _participantRepository = ParticipantRepository(); // Instance of your service
  List<Participant> allParticipants = [];
  List<Participant> trackingParticipants = [];
  List<Participant> trackedParticipants = [];
  bool showAllTracking = true;
  bool showAllTracked = true;
  bool _isLoading = true; // To indicate loading state
  String? _error; // To hold any error message

  @override
  void initState() {
    super.initState();
    _fetchParticipants();
  }

  Future<void> _fetchParticipants() async {
    setState(() {
      _isLoading = true;
      _error = null;
    });
    try {
      final List<Participant> participants = await _participantRepository.getParticipants();
      setState(() {
        allParticipants = participants;
        trackingParticipants = List.from(allParticipants); // Initially all are to be tracked
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _error = 'Failed to fetch participants: $e';
        _isLoading = false;
      });
    }
  }

  void moveToTracked(Participant participant) {
    setState(() {
      trackingParticipants.remove(participant);
      trackedParticipants.add(participant);
      // In a real app, you might want to update Firebase here as well
    });
  }

  void moveToTracking(Participant participant) {
    setState(() {
      trackedParticipants.remove(participant);
      trackingParticipants.add(participant);
      // In a real app, you might want to update Firebase here as well
    });
  }

  List<Participant> getDisplayedTracking() {
    if (showAllTracking) {
      return trackingParticipants;
    } else {
      // Replace with your actual "active" filtering logic based on Firebase data
      return trackingParticipants.where((p) => p.isActive == true).toList(); // Example
    }
  }

  List<Participant> getDisplayedTracked() {
    if (showAllTracked) {
      return trackedParticipants;
    } else {
      // Replace with your actual "active" filtering logic based on Firebase data
      return trackedParticipants.where((p) => p.isActive == true).toList(); // Example
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    if (_error != null) {
      return Scaffold(
        body: Center(child: Text('Error: $_error')),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Track Participants'),
        backgroundColor: Colors.grey[900],
      ),
      backgroundColor: Colors.grey[800],
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            // Tracking Participants Section
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Tracking Participants',
                  style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
                ),
                Row(
                  children: [
                    TextButton(
                      onPressed: () {
                        setState(() {
                          showAllTracking = true;
                        });
                      },
                      style: TextButton.styleFrom(
                        foregroundColor: showAllTracking ? Colors.blueAccent : Colors.grey[400],
                      ),
                      child: const Text('All', style: TextStyle(color: Colors.white)),
                    ),
                    const SizedBox(width: 8.0),
                    TextButton(
                      onPressed: () {
                        setState(() {
                          showAllTracking = false;
                        });
                      },
                      style: TextButton.styleFrom(
                        foregroundColor: showAllTracking ? Colors.grey[400] : Colors.blueAccent,
                      ),
                      child: const Text('Active', style: TextStyle(color: Colors.white)),
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 8.0),
            Wrap(
              spacing: 8.0,
              runSpacing: 8.0,
              children: getDisplayedTracking().map((participant) {
                return ElevatedButton(
                  onPressed: () => moveToTracked(participant),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.grey[600],
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.all(16.0),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20.0),
                    ),
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(participant.bib as String, style: const TextStyle(fontSize: 18.0)), // Assuming 'id' might be nullable
                      Text(participant.name ?? ''), // Assuming 'name' might be nullable
                    ],
                  ),
                );
              }).toList(),
            ),
            const SizedBox(height: 20.0),

            // Tracked Participants Section
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Tracked Participants',
                  style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
                ),
                Row(
                  children: [
                    TextButton(
                      onPressed: () {
                        setState(() {
                          showAllTracked = true;
                        });
                      },
                      style: TextButton.styleFrom(
                        foregroundColor: showAllTracked ? Colors.blueAccent : Colors.grey[400],
                      ),
                      child: const Text('All', style: TextStyle(color: Colors.white)),
                    ),
                    const SizedBox(width: 8.0),
                    TextButton(
                      onPressed: () {
                        setState(() {
                          showAllTracked = false;
                        });
                      },
                      style: TextButton.styleFrom(
                        foregroundColor: showAllTracked ? Colors.grey[400] : Colors.blueAccent,
                      ),
                      child: const Text('Active', style: TextStyle(color: Colors.white)),
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 8.0),
            Wrap(
              spacing: 8.0,
              runSpacing: 8.0,
              children: getDisplayedTracked().map((participant) {
                return ElevatedButton(
                  onPressed: () => moveToTracking(participant),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.orange[600],
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.all(16.0),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20.0),
                    ),
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(participant.bib as String , style: const TextStyle(fontSize: 18.0)),
                      Text(participant.name ?? ''),
                    ],
                  ),
                );
              }).toList(),
            ),
          ],
        ),
      ),
    );
  }
}
