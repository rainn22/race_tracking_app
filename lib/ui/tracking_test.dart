import 'package:flutter/material.dart';
import 'package:race_tracking_app/dto/dummy_data.dart';
import 'package:race_tracking_app/models/participant.dart';

class TrackingPage extends StatefulWidget {
  const TrackingPage({super.key});

  @override
  State<TrackingPage> createState() => _TrackingPageState();
}

class _TrackingPageState extends State<TrackingPage> {
  List<Participant> allParticipants = dummyParticipants; // Use dummy data
  List<Participant> trackingParticipants = [];
  List<Participant> trackedParticipants = [];
  bool showAllTracking = true;
  bool showAllTracked = true;

  @override
  void initState() {
    super.initState();
    trackingParticipants
        .addAll(allParticipants); // Initially all are to be tracked
  }

  void moveToTracked(Participant participant) {
    setState(() {
      trackingParticipants.remove(participant);
      trackedParticipants.add(participant);
    });
  }

  void moveToTracking(Participant participant) {
    setState(() {
      trackedParticipants.remove(participant);
      trackingParticipants.add(participant);
    });
  }

  List<Participant> getDisplayedTracking() {
    if (showAllTracking) {
      return trackingParticipants;
    } else {
      return trackingParticipants
          .where((p) => p.isActive == true)
          .toList(); // Adjust as needed
    }
  }

  List<Participant> getDisplayedTracked() {
    if (showAllTracked) {
      return trackedParticipants;
    } else {
      return trackedParticipants
          .where((p) => p.isActive == true)
          .toList(); // Adjust as needed
    }
  }

  @override
  Widget build(BuildContext context) {
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
                  style: TextStyle(
                      fontWeight: FontWeight.bold, color: Colors.white),
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
                        foregroundColor: showAllTracking
                            ? Colors.blueAccent
                            : Colors.grey[400],
                      ),
                      child: const Text('All',
                          style: TextStyle(color: Colors.white)),
                    ),
                    const SizedBox(width: 8.0),
                    TextButton(
                      onPressed: () {
                        setState(() {
                          showAllTracking = false;
                        });
                      },
                      style: TextButton.styleFrom(
                        foregroundColor: showAllTracking
                            ? Colors.grey[400]
                            : Colors.blueAccent,
                      ),
                      child: const Text('Active',
                          style: TextStyle(color: Colors.white)),
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
                      Text(participant.bib as String,
                          style: const TextStyle(
                              fontSize:
                                  18.0)), // Assuming 'id' might be nullable
                      Text(participant.name ??
                          ''), // Assuming 'name' might be nullable
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
                  style: TextStyle(
                      fontWeight: FontWeight.bold, color: Colors.white),
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
                        foregroundColor: showAllTracked
                            ? Colors.blueAccent
                            : Colors.grey[400],
                      ),
                      child: const Text('All',
                          style: TextStyle(color: Colors.white)),
                    ),
                    const SizedBox(width: 8.0),
                    TextButton(
                      onPressed: () {
                        setState(() {
                          showAllTracked = false;
                        });
                      },
                      style: TextButton.styleFrom(
                        foregroundColor: showAllTracked
                            ? Colors.grey[400]
                            : Colors.blueAccent,
                      ),
                      child: const Text('Active',
                          style: TextStyle(color: Colors.white)),
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
                      Text(participant.bib as String,
                          style: const TextStyle(fontSize: 18.0)),
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
