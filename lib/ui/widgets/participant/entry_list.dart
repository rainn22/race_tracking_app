import 'package:flutter/material.dart';
import 'package:race_tracking_app/models/participant_entry.dart';
import 'package:race_tracking_app/utils/constants.dart';
import 'package:race_tracking_app/utils/widgets/input_field.dart';

class ParticipantEntryRow extends StatelessWidget {
  final ParticipantEntry entry;

  const ParticipantEntryRow({
    super.key,
    required this.entry,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: AppSpacing.gap),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                InputField(
                  controller: entry.bibController,
                  keyboardType: TextInputType.number,
                  errorText: entry.bibError,
                ),
              ],
            ),
          ),
          const SizedBox(width: AppSpacing.gap),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                InputField(
                  controller: entry.nameController,
                  errorText: entry.nameError,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}