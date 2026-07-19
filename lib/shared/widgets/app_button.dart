import 'package:flutter/material.dart';

import '../../app/theme/app_colors.dart';
import '../../app/theme/app_gradients.dart';
import '../../app/theme/app_shadows.dart';
import '../../app/theme/app_text_styles.dart';

/// Button styles used across the app.
enum AppButtonVariant {
  /// Solid violet — standard call to action.
  primary,

  /// Solid magenta.
  secondary,

  /// Solid Federal ink (dark).
  ink,

  /// Transparent with a violet border.
  outline,

  /// Light violet-tinted background, violet text — low emphasis.
  ghost,

  /// Signature Purple Fade gradient + glow — hero call to action.
  gradient,
}

/// The single (pill-shaped) button for the whole app. Use this instead of raw
/// `ElevatedButton`/`OutlinedButton` so size, radius, loading and disabled
/// states stay identical everywhere.
///
/// ```dart
/// AppButton(label: 'Continuer', variant: AppButtonVariant.gradient, trailingIcon: Icons.arrow_forward)
/// AppButton(label: 'Contactez-nous', variant: AppButtonVariant.ink)
/// AppButton(label: 'Voir les détails', variant: AppButtonVariant.outline)
/// AppButton(label: 'Filtres', variant: AppButtonVariant.ghost, expanded: false)
/// ```
class AppButton extends StatelessWidget {
  const AppButton({
    super.key,
    required this.label,
    this.onPressed,
    this.variant = AppButtonVariant.primary,
    this.icon,
    this.trailingIcon,
    this.isLoading = false,
    this.expanded = true,
    this.height = 54,
  });

  final String label;
  final VoidCallback? onPressed;
  final AppButtonVariant variant;

  /// Leading icon.
  final IconData? icon;

  /// Trailing icon (e.g. an arrow on "Continuer").
  final IconData? trailingIcon;
  final bool isLoading;

  /// When true (default) the button fills the available width.
  final bool expanded;
  final double height;

  bool get _enabled => onPressed != null && !isLoading;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: expanded ? double.infinity : null,
      height: height,
      child:
          variant == AppButtonVariant.gradient ? _gradient() : _standard(),
    );
  }

  Widget _standard() {
    final isOutline = variant == AppButtonVariant.outline;
    final isGhost = variant == AppButtonVariant.ghost;

    final background = switch (variant) {
      AppButtonVariant.primary => AppColors.primary,
      AppButtonVariant.secondary => AppColors.accent,
      AppButtonVariant.ink => AppColors.ink,
      AppButtonVariant.ghost => AppColors.violetSurface,
      _ => Colors.transparent,
    };
    final foreground =
        (isOutline || isGhost) ? AppColors.primary : AppColors.textOnPrimary;

    final style = ButtonStyle(
      backgroundColor: WidgetStatePropertyAll(background),
      foregroundColor: WidgetStatePropertyAll(foreground),
      overlayColor:
          WidgetStatePropertyAll(foreground.withValues(alpha: 0.08)),
      elevation: const WidgetStatePropertyAll(0),
      padding: const WidgetStatePropertyAll(
          EdgeInsets.symmetric(horizontal: 24)),
      shape: const WidgetStatePropertyAll(StadiumBorder()),
      side: isOutline
          ? const WidgetStatePropertyAll(
              BorderSide(color: AppColors.primary, width: 1.5))
          : null,
    );

    final child = _content(foreground);
    return isOutline
        ? OutlinedButton(
            onPressed: _enabled ? onPressed : null, style: style, child: child)
        : ElevatedButton(
            onPressed: _enabled ? onPressed : null, style: style, child: child);
  }

  Widget _gradient() {
    const shape = StadiumBorder();
    return DecoratedBox(
      decoration: ShapeDecoration(
        shape: shape,
        gradient: _enabled ? AppGradients.purpleFade : null,
        color: _enabled ? null : AppColors.border,
        shadows: _enabled ? AppShadows.glow : null,
      ),
      child: Material(
        color: Colors.transparent,
        shape: shape,
        clipBehavior: Clip.antiAlias,
        child: InkWell(
          onTap: _enabled ? onPressed : null,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Center(child: _content(AppColors.textOnPrimary)),
          ),
        ),
      ),
    );
  }

  Widget _content(Color foreground) {
    if (isLoading) {
      return SizedBox(
        width: 22,
        height: 22,
        child: CircularProgressIndicator(
          strokeWidth: 2.5,
          valueColor: AlwaysStoppedAnimation<Color>(foreground),
        ),
      );
    }
    return Row(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        if (icon != null) ...[
          Icon(icon, size: 20, color: foreground),
          const SizedBox(width: 8),
        ],
        Flexible(
          child: Text(
            label,
            style: AppTextStyles.button.copyWith(color: foreground),
            overflow: TextOverflow.ellipsis,
          ),
        ),
        if (trailingIcon != null) ...[
          const SizedBox(width: 8),
          Icon(trailingIcon, size: 20, color: foreground),
        ],
      ],
    );
  }
}
