// tracking_screen.dart
 import 'package:flutter/material.dart';
 import 'result_screen.dart'; // Import the ResultScreen

 enum RaceStage { swim, cycle, run }

 class TrackingScreen extends StatefulWidget {
  const TrackingScreen({super.key});

  @override
  State<TrackingScreen> createState() => _TrackingScreenState();
 }

 class _TrackingScreenState extends State<TrackingScreen> {
  RaceStage currentStage = RaceStage.swim;

  final Map<RaceStage, List<String>> allParticipants = {
    RaceStage.swim: List.generate(10, (index) => 'Swimmer $index'),
    RaceStage.cycle: [],
    RaceStage.run: [],
  };

  final Map<RaceStage, List<String>> trackedParticipants = {
    RaceStage.swim: [],
    RaceStage.cycle: [],
    RaceStage.run: [],
  };

  final Map<String, DateTime?> finishTimes = {};
  final Map<String, String?> participantBibs = {}; // Placeholder for bib numbers

  @override
  void initState() {
    super.initState();
    // Initialize dummy bib numbers
    for (final stageParticipants in allParticipants.values) {
      for (final name in stageParticipants) {
        participantBibs[name] = (allParticipants[RaceStage.swim]!.indexOf(name) + 1).toString();
      }
    }
  }

  void onParticipantTap(String name) {
    if (!trackedParticipants[currentStage]!.contains(name)) {
      setState(() {
        trackedParticipants[currentStage]!.add(name);
        allParticipants[currentStage]!.remove(name);

        // Automatically move to next stage and record start time for the next
        if (currentStage == RaceStage.swim) {
          allParticipants[RaceStage.cycle]!.add(name);
          // Record swim finish time (start of cycle)
          finishTimes[name] = DateTime.now();
        } else if (currentStage == RaceStage.cycle) {
          allParticipants[RaceStage.run]!.add(name);
          // Record cycle finish time (start of run)
          finishTimes[name] = DateTime.now();
        } else if (currentStage == RaceStage.run) {
          // Record run finish time
          finishTimes[name] = DateTime.now();
          // Optionally navigate to results page here
          _navigateToResults();
        }
      });
    } else {
      setState(() {
        trackedParticipants[currentStage]!.remove(name);
        allParticipants[currentStage]!.add(name);
        allParticipants[currentStage]!.sort(); // Keep the list ordered
        finishTimes.remove(name); // Remove finish time if untracked
      });
    }
  }

  void _navigateToResults() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ResultScreen(results: _prepareResults()),
      ),
    );
  }

  List<Map<String, dynamic>> _prepareResults() {
    List<Map<String, dynamic>> results = [];
    for (final name in finishTimes.keys) {
      final bib = participantBibs[name] ?? 'N/A';
      final finishTime = finishTimes[name];
      // Assuming the race started when the first swimmer started
      final startTime = finishTimes.values.firstOrNull?.subtract(
          _calculateTotalElapsedTime(name)); // Rough estimate
      final elapsedTime =
          finishTime != null && startTime != null ? finishTime.difference(startTime) : null;

      results.add({
        'name': name,
        'bib': bib,
        'time': elapsedTime != null ? _formatDuration(elapsedTime) : 'DNF',
      });
    }
    // Sort results by time (shortest first)
    results.sort((a, b) {
      final timeA = a['time'];
      final timeB = b['time'];
      if (timeA == 'DNF') return 1;
      if (timeB == 'DNF') return -1;
      final durationA = _parseDuration(timeA);
      final durationB = _parseDuration(timeB);
      return durationA.compareTo(durationB);
    });
    return results;
  }

  Duration _calculateTotalElapsedTime(String name) {
    // This is a very basic estimation. A real scenario would need more precise tracking.
    Duration total = Duration.zero;
    if (trackedParticipants[RaceStage.swim]!.contains(name)) {
      total += const Duration(minutes: 15); // Example swim time
    }
    if (trackedParticipants[RaceStage.cycle]!.contains(name)) {
      total += const Duration(minutes: 45); // Example cycle time
    }
    if (trackedParticipants[RaceStage.run]!.contains(name)) {
      total += const Duration(minutes: 30); // Example run time
    }
    return total;
  }

  Duration _parseDuration(String timeString) {
    List<String> parts = timeString.split(':');
    int minutes = int.parse(parts[0]);
    int seconds = int.parse(parts[1]);
    return Duration(minutes: minutes, seconds: seconds);
  }

  String _formatDuration(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    final String minutes = twoDigits(duration.inMinutes);
    final String seconds = twoDigits(duration.inSeconds.remainder(60));
    return "$minutes:$seconds";
  }

  String getStageTitle(RaceStage stage) {
    switch (stage) {
      case RaceStage.swim:
        return 'Swimming Stage';
      case RaceStage.cycle:
        return 'Cycling Stage';
      case RaceStage.run:
        return 'Running Stage';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Triathlon Tracker"),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.list),
            onPressed: finishTimes.isNotEmpty ? _navigateToResults : null,
          ),
        ],
      ),
      body: Column(
        children: [
          const SizedBox(height: 10),
          ToggleButtons(
            isSelected: [
              currentStage == RaceStage.swim,
              currentStage == RaceStage.cycle,
              currentStage == RaceStage.run,
            ],
            onPressed: (int index) {
              setState(() {
                currentStage = RaceStage.values[index];
              });
            },
            children: const [
              Padding(padding: EdgeInsets.all(8.0), child: Text("Swim")),
              Padding(padding: EdgeInsets.all(8.0), child: Text("Cycle")),
              Padding(padding: EdgeInsets.all(8.0), child: Text("Run")),
            ],
          ),
          const SizedBox(height: 10),
          Text(getStageTitle(currentStage),
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          const SizedBox(height: 10),
          Expanded(
            child: Column(
              children: [
                Expanded(
                  child: ParticipantGrid(
                    title: 'All Participants',
                    names: allParticipants[currentStage]!,
                    onTap: onParticipantTap,
                    avatarColor: Colors.grey,
                  ),
                ),
                Expanded(
                  child: ParticipantGrid(
                    title: 'Tracked Participants',
                    names: trackedParticipants[currentStage]!,
                    onTap: onParticipantTap,
                    avatarColor: currentStage == RaceStage.swim
                        ? Colors.orange
                        : currentStage == RaceStage.cycle
                            ? Colors.yellow
                            : Colors.green,
                  ),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}

class ParticipantGrid extends StatelessWidget {
  final String title;
  final List<String> names;
  final void Function(String)? onTap;
  final Color avatarColor;

  const ParticipantGrid({
    super.key,
    required this.title,
    required this.names,
    this.onTap,
    required this.avatarColor,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.all(12),
      elevation: 4,
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child:
                Text(title, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
          ),
          Expanded(
            child: GridView.builder(
              padding: const EdgeInsets.all(8),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3,
                childAspectRatio: 1,
                crossAxisSpacing: 8,
                mainAxisSpacing: 8,
              ),
              itemCount: names.length,
              itemBuilder: (context, index) {
                final name = names[index];
                return GestureDetector(
                  onTap: onTap != null ? () => onTap!(name) : null,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      CircleAvatar(
                        radius: 30,
                        backgroundColor: avatarColor,
                        child: Text(
                          name.split(' ').last,
                          style: const TextStyle(color: Colors.white),
                        ),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        name,
                        style: const TextStyle(fontSize: 12),
                        textAlign: TextAlign.center,
                      )
                    ],
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}