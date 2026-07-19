import 'package:flutter/material.dart';

import 'app_colors.dart';

/// Reusable text styles. Swap [fontFamily] in one place (e.g. after adding a
/// Google Font) and the whole app follows.
class AppTextStyles {
  AppTextStyles._();

  static const String fontFamily = 'Roboto';

  static const TextStyle h1 = TextStyle(
      fontSize: 28, fontWeight: FontWeight.bold, color: AppColors.textPrimary);
  static const TextStyle h2 = TextStyle(
      fontSize: 22, fontWeight: FontWeight.bold, color: AppColors.textPrimary);
  static const TextStyle h3 = TextStyle(
      fontSize: 18, fontWeight: FontWeight.w600, color: AppColors.textPrimary);
  static const TextStyle title = TextStyle(
      fontSize: 16, fontWeight: FontWeight.w600, color: AppColors.textPrimary);
  static const TextStyle body =
      TextStyle(fontSize: 14, color: AppColors.textPrimary);
  static const TextStyle bodySecondary =
      TextStyle(fontSize: 14, color: AppColors.textSecondary);
  static const TextStyle caption =
      TextStyle(fontSize: 12, color: AppColors.textHint);
  static const TextStyle button = TextStyle(
      fontSize: 15, fontWeight: FontWeight.w600, color: AppColors.textOnPrimary);
  static const TextStyle price = TextStyle(
      fontSize: 18, fontWeight: FontWeight.bold, color: AppColors.primary);
}
