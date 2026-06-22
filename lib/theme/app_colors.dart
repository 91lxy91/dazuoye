import 'package:flutter/material.dart';

class AppColors {
  static const primary = Color(0xFF6C63FF);
  static const primaryDark = Color(0xFF4A42D4);
  static const primaryLight = Color(0xFF9D97FF);
  static const accent = Color(0xFFFF6B6B);
  static const surfaceLight = Color(0xFFF2F4F8);
  static const surfaceDark = Color(0xFF1A1B23);
  static const cardLight = Color(0xFFFFFFFF);
  static const cardDark = Color(0xFF24252F);
  static const textPrimaryLight = Color(0xFF2D2D3A);
  static const textPrimaryDark = Color(0xFFEAEAEF);
  static const textSecondaryLight = Color(0xFF8E8E9A);
  static const textSecondaryDark = Color(0xFF9A9AAA);
  static const gradientTop = Color(0xFF6C63FF);
  static const gradientBottom = Color(0xFF3D37B3);

  /// 根据亮度返回背景色
  static Color surface(BuildContext context) =>
      Theme.of(context).brightness == Brightness.dark ? surfaceDark : surfaceLight;

  /// 根据亮度返回卡片色
  static Color cardBg(BuildContext context) =>
      Theme.of(context).brightness == Brightness.dark ? cardDark : cardLight;

  /// 根据亮度返回主文字色
  static Color textPrimary(BuildContext context) =>
      Theme.of(context).brightness == Brightness.dark ? textPrimaryDark : textPrimaryLight;

  /// 根据亮度返回次文字色
  static Color textSecondary(BuildContext context) =>
      Theme.of(context).brightness == Brightness.dark ? textSecondaryDark : textSecondaryLight;
}
