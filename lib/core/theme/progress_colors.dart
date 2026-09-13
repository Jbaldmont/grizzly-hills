import 'package:flutter/material.dart';

abstract final class ProgressColors {
  static const Color low = Color(0xFF43A047);
  static const Color medium = Color(0xFFFBC02D);
  static const Color high = Color(0xFFF57C00);
  static const Color critical = Color(0xFFE53935);

  static const double mediumThreshold = 0.5;
  static const double highThreshold = 0.75;
  static const double criticalThreshold = 0.9;

  static Color forRatio(double ratio) {
    if (ratio >= criticalThreshold) {
      return critical;
    }
    if (ratio >= highThreshold) {
      return high;
    }
    if (ratio >= mediumThreshold) {
      return medium;
    }
    return low;
  }
}
