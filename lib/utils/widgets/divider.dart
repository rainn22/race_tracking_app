import 'package:flutter/material.dart';
import 'package:race_tracking_app/utils/constants.dart';

class AppDivider extends StatelessWidget {
  const AppDivider({super.key});

  @override
  Widget build(BuildContext context) {
    return const Divider(
      color: AppColors.secondary,
      thickness: 1,
      height: 1,
      indent: 16,
      endIndent: 16,
    );
  }
}
