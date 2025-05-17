import 'package:flutter/material.dart';

class AppColors {
  static const Color primary = Color(0xFFFFCC6A);
  static const Color secondary = Color(0xFFE3E2E2);
  static const Color darkGrey = Color(0xFF848484);
  static const Color bg = Color(0xfff5f5f5);
  static const Color text = Color(0xDD000000);
  static const Color white = Color(0xFFFFFFFF);
  static const Color blue = Color(0xFF2495F1);
  static const Color green = Color(0xFF4BB84F);
  static const Color red = Color(0xFFFF2C2C);
  static const Color orange = Color(0xFFFF9800);
}

class AppTextStyles {
  static const TextStyle textSm = TextStyle(
    fontSize: 12,
    color: AppColors.text,
  );

  static const TextStyle textMd = TextStyle(
    fontSize: 16,
    color: AppColors.text,
  );

  static const TextStyle textLg = TextStyle(
    fontSize: 18,
    fontWeight: FontWeight.w600,
    color: AppColors.text,
  );
}

class AppSpacing {
  static const double padding = 16.0;
  static const double gap = 12.0;
}

class AppDurations {
  static const Duration fast = Duration(milliseconds: 200);
  static const Duration medium = Duration(milliseconds: 400);
}
