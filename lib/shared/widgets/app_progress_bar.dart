import 'package:flutter/material.dart';

import '../../app/theme/app_colors.dart';
import '../../app/theme/app_gradients.dart';
import '../../app/theme/app_text_styles.dart';

/// Gradient-filled linear progress bar with an optional label + percentage.
///
/// Pass [AppGradients.confidence] as [gradient] for the ML confidence gauge:
/// ```dart
/// AppProgressBar(value: 0.4, label: 'Étape 2 / 5')
/// AppProgressBar(value: 0.78, label: 'Confiance ML', gradient: AppGradients.confidence)
/// ```
class AppProgressBar extends StatelessWidget {
  const AppProgressBar({
    super.key,
    required this.value,
    this.label,
    this.showPercent = true,
    this.gradient = AppGradients.purpleFade,
    this.height = 10,
  });

  /// Progress from 0.0 to 1.0 (clamped).
  final double value;
  final String? label;
  final bool showPercent;
  final Gradient gradient;
  final double height;

  @override
  Widget build(BuildContext context) {
    final clamped = value.clamp(0.0, 1.0);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (label != null || showPercent) ...[
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              if (label != null)
                Text(label!,
                    style: AppTextStyles.title.copyWith(color: AppColors.primary))
              else
                const SizedBox.shrink(),
              if (showPercent)
                Text('${(clamped * 100).round()}%', style: AppTextStyles.title),
            ],
          ),
          const SizedBox(height: 8),
        ],
        ClipRRect(
          borderRadius: BorderRadius.circular(999),
          child: LayoutBuilder(
            builder: (context, constraints) {
              return Stack(
                children: [
                  Container(
                      height: height,
                      width: double.infinity,
                      color: AppColors.border),
                  AnimatedContainer(
                    duration: const Duration(milliseconds: 350),
                    curve: Curves.easeOut,
                    height: height,
                    width: constraints.maxWidth * clamped,
                    decoration: BoxDecoration(gradient: gradient),
                  ),
                ],
              );
            },
          ),
        ),
      ],
    );
  }
}
