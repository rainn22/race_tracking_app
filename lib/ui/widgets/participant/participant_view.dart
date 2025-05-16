
import 'package:flutter/material.dart';
import 'package:race_tracking_app/ui/add_particpant_screen.dart';
import 'package:race_tracking_app/utils/constants.dart';
import 'package:race_tracking_app/utils/widgets/button.dart';
import 'package:race_tracking_app/ui/widgets/participant/participant_list.dart';

class ParticipantList extends StatelessWidget {
  const ParticipantList({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: const ParticipantListView(), // show the list here
            ),
            Padding(
              padding: const EdgeInsets.only(top: AppSpacing.gap),
              child: AppButton(
                label: 'Add New Participants',
                color: AppColors.secondary,
                textColor: AppColors.text,
                icon: Icons.group_add,
                onTap: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (_) => const BulkAddParticipantsScreen(),
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

