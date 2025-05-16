import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:race_tracking_app/models/status.dart';
import 'package:race_tracking_app/providers/race_stage_provider.dart';
import 'package:race_tracking_app/utils/constants.dart';
import 'package:race_tracking_app/utils/status_color.dart';
import 'package:race_tracking_app/utils/widgets/button.dart';
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
      padding: const EdgeInsets.all(AppSpacing.padding),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text('Race Control Panel', style: AppTextStyles.textLg),
          const Text('Manage your race timing and participants',
              style: AppTextStyles.textSm),
          const SizedBox(height: 20),
          Card(
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            color: AppColors.white,
            elevation: 2,
            child: Padding(
              padding: const EdgeInsets.symmetric(
                  vertical: 30.0, horizontal: AppSpacing.padding),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text("Race Status: ", style: AppTextStyles.textLg),
                      RaceStatus(value: status.label)
                    ],
                  ),
                  const SizedBox(height: 20),
                  RaceTimeStamp(
                    start: startTime,
                    end: status == Status.finished ? endTime : DateTime.now(),
                  ),
                  const SizedBox(height: 10),
                  _buildActionButton(status, timerProvider),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActionButton(Status status, RaceStageProvider provider) {
    switch (status) {
      case Status.notStarted:
        return AppButton(
          label: "Start Race",
          color: AppColors.green,
          textColor: AppColors.white,
          icon: Icons.play_arrow,
          onTap: () => provider.startRace(),
        );
      case Status.started:
        return AppButton(
          label: "End Race",
          color: AppColors.red,
          textColor: Colors.white,
          icon: Icons.stop,
          onTap: () => provider.endRace(),
        );
      case Status.finished:
        return AppButton(
          label: "Restart",
          color: AppColors.blue,
          textColor: Colors.white,
          icon: Icons.restart_alt,
          onTap: () => provider.restartRace(),
        );
      default:
        return const SizedBox.shrink();
    }
  }
}
