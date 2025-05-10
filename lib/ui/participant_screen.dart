import 'package:flutter/material.dart';
import 'package:race_tracking_app/utils/constants.dart';
import 'package:race_tracking_app/utils/widgets/participant_form.dart';
import 'package:race_tracking_app/utils/widgets/participant_list.dart';
import 'package:race_tracking_app/utils/widgets/race_control_view.dart';
import 'package:race_tracking_app/utils/widgets/segmentToggle.dart';

class ParticipantScreen extends StatefulWidget {
  const ParticipantScreen({super.key});

  @override
  State<ParticipantScreen> createState() => _ParticipantScreenState();
}

class _ParticipantScreenState extends State<ParticipantScreen> {
  int selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Race Manager'),
      actions: [
            IconButton(
              icon: const Icon(Icons.add),
              onPressed: () => showParticipantForm(context), // Add participant form
            ),
          ],),
      body: Padding(
        padding: const EdgeInsets.all(AppSpacing.padding),
        child: Column(
          children: [
            SegmentToggle(
              labels: const ['Participants', 'Race Control'],
              selectedIndex: selectedIndex,
              onTabSelected: (index) {
                setState(() {
                  selectedIndex = index;
                });
              },
            ),
            const SizedBox(height: AppSpacing.gap),
            Expanded(
              child: selectedIndex == 0
                  ? const ParticipantList()
                  : const RaceControlView(),
            ),
          ],
        ),
      ),
    );
  }
}



