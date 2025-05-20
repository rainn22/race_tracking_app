import 'package:flutter/material.dart';
import 'package:race_tracking_app/utils/constants.dart';
import 'package:race_tracking_app/utils/status_color.dart';
import 'package:race_tracking_app/utils/widgets/race_time_stamp.dart';
import 'package:race_tracking_app/models/status.dart';

class TimestampCard extends StatelessWidget {
  final Status status;
  final DateTime? startTime;
  final DateTime endTime;

  const TimestampCard({
    super.key,
    required this.status,
    required this.startTime,
    required this.endTime,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
      ),
      color: AppColors.white,
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.symmetric(
            vertical: 5.0, horizontal: AppSpacing.padding),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text("", style: AppTextStyles.textLg),
                RaceStatus(value: status.label),
              ],
            ),
            const SizedBox(height: 8),
            RaceTimeStamp(
              start: startTime,
              end: endTime,
            ),
          ],
        ),
      ),
    );
  }
}