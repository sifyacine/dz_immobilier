import 'package:flutter/material.dart';

import 'app_colors.dart';

/// Brand gradients. "Purple Fade" is the signature (always 135°, i.e.
/// top-left → bottom-right). Use [purpleFade] for hero surfaces and the
/// gradient button variant.
class AppGradients {
  AppGradients._();

  // 135° in CSS maps to top-left → bottom-right.
  static const Alignment _begin = Alignment.topLeft;
  static const Alignment _end = Alignment.bottomRight;

  /// Signature: Violet → Heliotrope (#7F00FD → #E565FF).
  static const LinearGradient purpleFade = LinearGradient(
    begin: _begin,
    end: _end,
    colors: [AppColors.violet, AppColors.heliotrope],
  );

  /// --dz-grad-ink-violet: Federal → Violet.
  static const LinearGradient inkViolet = LinearGradient(
    begin: _begin,
    end: _end,
    colors: [AppColors.federal, AppColors.violet],
  );

  /// --dz-grad-magenta-glow: Magenta → Heliotrope.
  static const LinearGradient magentaGlow = LinearGradient(
    begin: _begin,
    end: _end,
    colors: [AppColors.magenta, AppColors.heliotrope],
  );

  /// --dz-grad-ink-deep: deep Federal tones for dark surfaces.
  static const LinearGradient inkDeep = LinearGradient(
    begin: _begin,
    end: _end,
    colors: [AppColors.federal, Color(0xFF1B1B57)],
  );

  /// ML confidence spectrum: danger → magenta → violet → blue → success.
  /// Used by the confidence gauge (left = low, right = high).
  static const LinearGradient confidence = LinearGradient(
    colors: [
      AppColors.error,
      AppColors.magenta,
      AppColors.violet,
      Color(0xFF2563EB),
      AppColors.success,
    ],
  );
}
