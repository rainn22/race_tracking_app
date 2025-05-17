import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:race_tracking_app/models/status.dart';
import 'package:race_tracking_app/providers/race_stage_provider.dart';
import 'package:race_tracking_app/utils/constants.dart';
import 'package:race_tracking_app/utils/widgets/button.dart';
import 'package:race_tracking_app/ui/widgets/participant/participant_list.dart';

class ParticipantListScreen extends StatelessWidget {
  const ParticipantListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final raceStatus = context.watch<RaceStageProvider>().raceStage?.status ??
        Status.notStarted;
    final isRaceStarted =
        raceStatus == Status.started || raceStatus == Status.finished;

    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(AppSpacing.padding),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text('Participant', style: AppTextStyles.textLg),
                  AppButton(
                    label: 'Add Participant',
                    color: isRaceStarted ? AppColors.secondary : AppColors.primary,
                    textColor: AppColors.text,
                    icon: Icons.group_add,
                    onTap: isRaceStarted
                        ? () {}
                        : () {
                            Navigator.pushNamed(context, '/addParticipant');
                          },
                  ),
                ],
              ),
            ),
            const Expanded(
              child: ParticipantList(),
            ),
          ],
        ),
      ),
    );
  }
}
