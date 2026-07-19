import 'package:flutter/material.dart';

import '../../app/constants/app_constants.dart';
import '../../app/theme/app_colors.dart';
import '../../app/theme/app_shadows.dart';
import 'app_logo.dart';

/// A custom floating, pill-shaped App Bar that matches the style
/// of the bottom navigation bar.
class AppAppBar extends StatelessWidget implements PreferredSizeWidget {
  final VoidCallback? onCartTap;
  final VoidCallback? onMenuTap;

  const AppAppBar({
    super.key,
    this.onCartTap,
    this.onMenuTap,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final bg = isDark ? AppColors.darkCard : AppColors.surface;
    final iconColor = isDark ? AppColors.darkTextPrimary : AppColors.federal;

    return SafeArea(
      bottom: false,
      child: Container(
        padding: const EdgeInsets.symmetric(
          horizontal: AppConstants.spacingMd,
          vertical: AppConstants.spacingSm,
        ),
        child: DecoratedBox(
          decoration: BoxDecoration(
            color: bg,
            borderRadius: BorderRadius.circular(AppConstants.radiusPill),
            boxShadow: AppShadows.lg,
          ),
          child: Container(
            height: 56,
            padding: const EdgeInsets.symmetric(horizontal: AppConstants.spacingMd),
            child: Row(
              children: [
                AppLogo(
                  wordmark: true,
                  height: 26,
                  color: isDark ? Colors.white : null,
                ),
                const Spacer(),
                IconButton(
                  icon: Icon(
                    Icons.shopping_cart_outlined,
                    color: iconColor,
                    size: 24,
                  ),
                  onPressed: onCartTap ?? () {},
                ),
                IconButton(
                  icon: Icon(
                    Icons.menu_rounded,
                    color: iconColor,
                    size: 24,
                  ),
                  onPressed: onMenuTap ?? () {},
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(56 + 16); // 56 height + 16 vertical padding
}
