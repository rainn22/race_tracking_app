import 'package:flutter/material.dart';
import 'package:race_tracking_app/utils/constants.dart';

class AppButton extends StatelessWidget {
  final String label;
  final Color color;
  final Color textColor;
  final IconData? icon;
  final VoidCallback onTap;

  const AppButton({
    super.key,
    required this.label,
    required this.color,
    required this.textColor,
    this.icon,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: color,
      borderRadius: BorderRadius.circular(8),
      child: InkWell(
        borderRadius: BorderRadius.circular(8),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 16),
          child: Center(
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                if (icon != null) ...[
                  Icon(icon, color: textColor),
                  const SizedBox(width: 8),
                ],
                Text(
                  label,
                  style: AppTextStyles.textMd.copyWith(color: textColor),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
