import 'package:flutter/material.dart';

class AppColors {
  static const Color primary = Color(0xFFFFCC6A);
  static const Color secondary = Color(0xFF8D8D8D);
  static const Color text = Colors.black87;
  static const Color white = Colors.white;
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
    fontSize: 20,
    fontWeight: FontWeight.bold,
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
