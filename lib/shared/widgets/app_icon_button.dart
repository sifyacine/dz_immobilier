import 'package:flutter/material.dart';

import '../../app/theme/app_colors.dart';
import '../../app/theme/app_gradients.dart';
import '../../app/theme/app_shadows.dart';

/// Circular icon button. Mirrors [AppButton] variants for round actions like
/// a gradient FAB (`+`) or an outline favourite toggle (♥).
///
/// ```dart
/// AppIconButton(icon: Icons.add)                                   // gradient
/// AppIconButton(icon: Icons.favorite_border, variant: AppIconButtonVariant.outline)
/// ```
enum AppIconButtonVariant { gradient, primary, ink, outline, ghost }

class AppIconButton extends StatelessWidget {
  const AppIconButton({
    super.key,
    required this.icon,
    this.onPressed,
    this.variant = AppIconButtonVariant.gradient,
    this.size = 56,
    this.iconSize = 24,
  });

  final IconData icon;
  final VoidCallback? onPressed;
  final AppIconButtonVariant variant;
  final double size;
  final double iconSize;

  bool get _enabled => onPressed != null;

  @override
  Widget build(BuildContext context) {
    final isGradient = variant == AppIconButtonVariant.gradient;
    final isOutline = variant == AppIconButtonVariant.outline;
    final isGhost = variant == AppIconButtonVariant.ghost;

    final foreground =
        (isOutline || isGhost) ? AppColors.primary : AppColors.textOnPrimary;
    final solidColor = switch (variant) {
      AppIconButtonVariant.primary => AppColors.primary,
      AppIconButtonVariant.ink => AppColors.ink,
      AppIconButtonVariant.ghost => AppColors.violetSurface,
      _ => Colors.transparent,
    };

    final shape = isOutline
        ? const CircleBorder(
            side: BorderSide(color: AppColors.primary, width: 1.5))
        : const CircleBorder();

    return SizedBox(
      width: size,
      height: size,
      child: DecoratedBox(
        decoration: ShapeDecoration(
          shape: shape,
          gradient: isGradient && _enabled ? AppGradients.purpleFade : null,
          color: isGradient
              ? (_enabled ? null : AppColors.border)
              : solidColor,
          shadows: isGradient && _enabled ? AppShadows.glow : null,
        ),
        child: Material(
          color: Colors.transparent,
          shape: const CircleBorder(),
          clipBehavior: Clip.antiAlias,
          child: InkWell(
            onTap: _enabled ? onPressed : null,
            child: Center(child: Icon(icon, size: iconSize, color: foreground)),
          ),
        ),
      ),
    );
  }
}
