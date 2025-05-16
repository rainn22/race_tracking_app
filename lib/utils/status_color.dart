import 'package:flutter/material.dart';
import 'package:race_tracking_app/utils/constants.dart';

class RaceStatus extends StatelessWidget {
  final String value;

  const RaceStatus({
    super.key,
    required this.value,
  });

  Color _getStatusColor(String status) {
    switch (status) {
      case 'In Progress':
        return AppColors.blue;
      case 'Not Yet Started':
        return AppColors.orange;
      case 'Finished':
        return AppColors.green;
      default:
        return Colors.grey.shade800;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Text(
      value,
      style: AppTextStyles.textLg.copyWith(
        color: _getStatusColor(value),
      ),
    );
  }
}
