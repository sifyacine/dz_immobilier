import 'package:flutter/material.dart';

import '../../../app/constants/app_constants.dart';
import '../../../app/theme/app_colors.dart';
import '../../../app/theme/app_text_styles.dart';

/// A single menu row: coloured icon circle · title + subtitle · optional count/premium badge · chevron.
class ProfileMenuItem extends StatelessWidget {
  final IconData icon;
  final Color iconColor;
  final Color iconBg;
  final String title;
  final String subtitle;
  final int? count;           // numeric badge (right side)
  final String? badgeLabel;  // text badge e.g. "Premium"
  final Color? badgeColor;
  final String? trailingText; // plain text on the right, e.g. current value
  final VoidCallback? onTap;

  const ProfileMenuItem({
    super.key,
    required this.icon,
    required this.iconColor,
    required this.iconBg,
    required this.title,
    required this.subtitle,
    this.count,
    this.badgeLabel,
    this.badgeColor,
    this.trailingText,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final textColor = isDark ? AppColors.darkTextPrimary : AppColors.textPrimary;
    final subColor = isDark ? AppColors.darkTextSecondary : AppColors.textSecondary;

    return InkWell(
      onTap: onTap ?? () {},
      borderRadius: BorderRadius.circular(AppConstants.radiusMd),
      child: Padding(
        padding: const EdgeInsets.symmetric(
          vertical: AppConstants.spacingMd,
          horizontal: AppConstants.spacingMd,
        ),
        child: Row(
          children: [
            // Icon circle
            Container(
              width: 44,
              height: 44,
              decoration: BoxDecoration(
                color: iconBg,
                borderRadius: BorderRadius.circular(AppConstants.radiusSm),
              ),
              child: Icon(icon, size: 22, color: iconColor),
            ),
            const SizedBox(width: AppConstants.spacingMd),

            // Title + subtitle
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title,
                      style: AppTextStyles.title.copyWith(color: textColor)),
                  const SizedBox(height: 2),
                  Text(subtitle,
                      style: AppTextStyles.caption.copyWith(color: subColor)),
                ],
              ),
            ),

            // Right-side badge / count
            if (count != null) ...[
              Container(
                constraints:
                    const BoxConstraints(minWidth: 28, minHeight: 28),
                padding: const EdgeInsets.symmetric(horizontal: 8),
                decoration: BoxDecoration(
                  color: AppColors.violetSurface,
                  borderRadius:
                      BorderRadius.circular(AppConstants.radiusPill),
                ),
                child: Center(
                  child: Text('$count',
                      style: AppTextStyles.caption.copyWith(
                          color: AppColors.primary,
                          fontWeight: FontWeight.w700)),
                ),
              ),
              const SizedBox(width: AppConstants.spacingSm),
            ],
            if (trailingText != null) ...[
              Text(trailingText!,
                  style: AppTextStyles.body.copyWith(color: subColor)),
              const SizedBox(width: AppConstants.spacingSm),
            ],
            if (badgeLabel != null) ...[
              Container(
                padding: const EdgeInsets.symmetric(
                    horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: badgeColor ?? AppColors.primary,
                  borderRadius:
                      BorderRadius.circular(AppConstants.radiusPill),
                ),
                child: Text(
                  badgeLabel!,
                  style: AppTextStyles.caption.copyWith(
                      color: Colors.white, fontWeight: FontWeight.w700),
                ),
              ),
              const SizedBox(width: AppConstants.spacingSm),
            ],

            // Chevron
            Icon(Icons.chevron_right_rounded,
                size: 20,
                color: isDark
                    ? AppColors.darkTextSecondary
                    : AppColors.textHint),
          ],
        ),
      ),
    );
  }
}
