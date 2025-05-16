import 'package:flutter/material.dart';
import 'package:race_tracking_app/models/user.dart';
import 'package:race_tracking_app/utils/constants.dart';

class RoleCard extends StatelessWidget {
  final Role role;
  final VoidCallback onTap;
  final bool isSelected;

  const RoleCard({
    super.key,
    required this.role,
    required this.onTap,
    this.isSelected = false,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: SizedBox(
        width: double.infinity,
        child: Card(
          color: isSelected ? AppColors.primary : AppColors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
            side: BorderSide(
              color: isSelected ? AppColors.primary : AppColors.secondary,
              width: 1,
            ),
          ),
          child: Padding(
            padding: const EdgeInsets.all(AppSpacing.padding),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(role.label, style: AppTextStyles.textLg),
                const SizedBox(height: 4),
                Text(
                  'Tap to switch role',
                  style: AppTextStyles.textSm.copyWith(
                    color: AppColors.text,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
