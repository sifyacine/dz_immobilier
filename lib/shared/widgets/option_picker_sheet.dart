import 'package:flutter/material.dart';

import '../../app/constants/app_constants.dart';
import '../../app/theme/app_colors.dart';
import '../../app/theme/app_text_styles.dart';

/// A single choice in an [OptionPickerSheet].
class PickerOption<T> {
  final T value;
  final String label;
  final IconData? icon;
  const PickerOption(this.value, this.label, {this.icon});
}

/// Reusable bottom sheet that presents a short list of mutually-exclusive
/// options with the current one ticked. Used for language, theme, etc.
///
/// ```dart
/// Get.bottomSheet(OptionPickerSheet<ThemeMode>(
///   title: 'Apparence',
///   selected: current,
///   options: const [PickerOption(ThemeMode.light, 'Clair')],
///   onSelected: (m) { Get.back(); service.setMode(m); },
/// ));
/// ```
class OptionPickerSheet<T> extends StatelessWidget {
  final String title;
  final List<PickerOption<T>> options;
  final T selected;
  final ValueChanged<T> onSelected;

  const OptionPickerSheet({
    super.key,
    required this.title,
    required this.options,
    required this.selected,
    required this.onSelected,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Container(
      decoration: BoxDecoration(
        color: isDark ? AppColors.darkSurface : AppColors.surface,
        borderRadius: const BorderRadius.vertical(
            top: Radius.circular(AppConstants.radiusLg)),
      ),
      padding: EdgeInsets.only(
        bottom: AppConstants.spacingMd + MediaQuery.of(context).padding.bottom,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Center(
            child: Container(
              width: 40,
              height: 4,
              margin: const EdgeInsets.symmetric(vertical: 10),
              decoration: BoxDecoration(
                color: AppColors.border,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(AppConstants.spacingMd, 0,
                AppConstants.spacingMd, AppConstants.spacingSm),
            child: Text(title, style: AppTextStyles.h3),
          ),
          for (final option in options)
            ListTile(
              leading: option.icon == null
                  ? null
                  : Icon(option.icon,
                      color: option.value == selected
                          ? AppColors.primary
                          : AppColors.textHint),
              title: Text(
                option.label,
                style: AppTextStyles.body.copyWith(
                  fontWeight: option.value == selected
                      ? FontWeight.w700
                      : FontWeight.normal,
                ),
              ),
              trailing: option.value == selected
                  ? const Icon(Icons.check_circle, color: AppColors.primary)
                  : null,
              onTap: () => onSelected(option.value),
            ),
        ],
      ),
    );
  }
}
