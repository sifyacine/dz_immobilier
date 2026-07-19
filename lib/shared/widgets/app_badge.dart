import 'package:flutter/material.dart';

import '../../app/theme/app_colors.dart';
import '../../app/theme/app_gradients.dart';
import '../../app/theme/app_text_styles.dart';

/// Status badge tones (tinted background + matching text), plus a [solid]
/// gradient variant for reference codes / strong tags.
enum AppBadgeTone { solid, neutral, success, warning, danger, info }

/// Compact status pill.
///
/// ```dart
/// AppBadge(label: 'VLIDO01', tone: AppBadgeTone.solid)
/// AppBadge(label: 'Nouveau', tone: AppBadgeTone.success)
/// AppBadge(label: 'Coup de cœur', tone: AppBadgeTone.danger)
/// AppBadge(label: '100% Fini', tone: AppBadgeTone.info)
/// ```
class AppBadge extends StatelessWidget {
  const AppBadge({
    super.key,
    required this.label,
    this.tone = AppBadgeTone.neutral,
    this.icon,
  });

  final String label;
  final AppBadgeTone tone;
  final IconData? icon;

  @override
  Widget build(BuildContext context) {
    final (Color? bg, Color fg, Gradient? gradient) = switch (tone) {
      AppBadgeTone.solid => (null, AppColors.textOnPrimary, AppGradients.purpleFade),
      AppBadgeTone.success => (AppColors.successSurface, AppColors.success, null),
      AppBadgeTone.warning => (AppColors.warningSurface, AppColors.warning, null),
      AppBadgeTone.danger => (AppColors.errorSurface, AppColors.error, null),
      AppBadgeTone.info => (AppColors.violetSurface, AppColors.primary, null),
      AppBadgeTone.neutral => (AppColors.background, AppColors.textSecondary, null),
    };

    return DecoratedBox(
      decoration: ShapeDecoration(
        shape: const StadiumBorder(),
        color: bg,
        gradient: gradient,
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (icon != null) ...[
              Icon(icon, size: 14, color: fg),
              const SizedBox(width: 4),
            ],
            Text(
              label,
              style: AppTextStyles.caption
                  .copyWith(color: fg, fontWeight: FontWeight.w700),
            ),
          ],
        ),
      ),
    );
  }
}
