import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:race_tracking_app/models/status.dart';
import 'package:race_tracking_app/providers/race_stage_provider.dart';
import 'package:race_tracking_app/utils/widgets/race_time_stamp.dart';

class RaceControlScreen extends StatelessWidget {
  const RaceControlScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final timerProvider = context.watch<RaceStageProvider>();
    final timer = timerProvider.raceStage;
    final status = timer?.status ?? Status.notStarted;
    final startTime = timer?.startTime;
    final endTime = timer?.endTime;

    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            'Race Control Panel',
            style: Theme.of(context).textTheme.headlineSmall,
          ),
          const SizedBox(height: 20),

          Card(
            color: Colors.grey.shade100,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            elevation: 2,
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 30.0, horizontal: 16),
              child: Column(
                children: [
                  _infoRow("Race Status", status.label),
                  const SizedBox(height: 20),
                  RaceTimeStamp(
                    start: startTime,
                    end: status == Status.finished ? endTime : DateTime.now(),
                  ),
                  const SizedBox(height: 10),
                ],
              ),
            ),
          ),

          const SizedBox(height: 40),

          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              ElevatedButton.icon(
                onPressed: status == Status.notStarted
                    ? () => timerProvider.startRace()
                    : null,
                icon: const Icon(Icons.play_arrow),
                label: const Text("Start Race"),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green,
                  disabledBackgroundColor: Colors.green.shade200,
                ),
              ),
              ElevatedButton.icon(
                onPressed: status == Status.started
                    ? () => timerProvider.endRace()
                    : null,
                icon: const Icon(Icons.stop),
                label: const Text("End Race"),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red,
                  disabledBackgroundColor: Colors.red.shade200,
                ),
              ),
              ElevatedButton.icon(
                onPressed: status == Status.finished
                    ? () => timerProvider.restartRace()
                    : null,
                icon: const Icon(Icons.restart_alt),
                label: const Text("Restart"),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue,
                  disabledBackgroundColor: Colors.blue.shade200,
                ),
              ),
            ],
          )
        ],
      ),
    );
  }

  Widget _infoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6.0),
      child: Row(
        children: [
          Text(
            "$label:",
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
          const SizedBox(width: 10),
          Expanded(child: Text(value)),
        ],
      ),
    );
  }
}
