import 'package:flutter/material.dart';

import '../../app/theme/app_colors.dart';
import '../../app/theme/app_gradients.dart';
import '../../app/theme/app_text_styles.dart';

/// Selectable filter chip. Selected → gradient fill; unselected → outline.
///
/// ```dart
/// AppChip(label: 'Vente', selected: true, onTap: () {})
/// AppChip(label: 'Filtre', icon: Icons.add, onTap: openFilters)
/// ```
class AppChip extends StatelessWidget {
  const AppChip({
    super.key,
    required this.label,
    this.selected = false,
    this.onTap,
    this.icon,
  });

  final String label;
  final bool selected;
  final VoidCallback? onTap;
  final IconData? icon;

  @override
  Widget build(BuildContext context) {
    final foreground = selected ? AppColors.textOnPrimary : AppColors.primary;
    const shape = StadiumBorder();
    return Material(
      color: Colors.transparent,
      shape: shape,
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onTap,
        child: DecoratedBox(
          decoration: ShapeDecoration(
            shape: selected
                ? shape
                : const StadiumBorder(
                    side: BorderSide(color: AppColors.border)),
            gradient: selected ? AppGradients.purpleFade : null,
            color: selected ? null : AppColors.surface,
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 10),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                if (icon != null) ...[
                  Icon(icon, size: 16, color: foreground),
                  const SizedBox(width: 6),
                ],
                Text(
                  label,
                  style: AppTextStyles.body
                      .copyWith(color: foreground, fontWeight: FontWeight.w600),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
