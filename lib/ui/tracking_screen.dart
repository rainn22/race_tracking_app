import 'package:flutter/material.dart';

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

  void onParticipantTap(String name) {
    if (!trackedParticipants[currentStage]!.contains(name)) {
      setState(() {
        trackedParticipants[currentStage]!.add(name);
        allParticipants[currentStage]!.remove(name);

        // Automatically move to next stage
        if (currentStage == RaceStage.swim) {
          allParticipants[RaceStage.cycle]!.add(name);
        } else if (currentStage == RaceStage.cycle) {
          allParticipants[RaceStage.run]!.add(name);
        }
      });
    } else {
      setState(() {
        trackedParticipants[currentStage]!.remove(name);
        allParticipants[currentStage]!.add(name);
        allParticipants[currentStage]!.sort(); // Keep the list ordered
      });
    }
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
          Text(getStageTitle(currentStage), style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
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
            child: Text(title, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
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