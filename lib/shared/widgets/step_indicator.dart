import 'package:flutter/material.dart';

import '../../app/theme/app_colors.dart';
import '../../app/theme/app_text_styles.dart';

/// Numbered step dots with connectors: completed (✓ violet), current
/// (magenta) and upcoming (outlined grey).
///
/// ```dart
/// StepIndicator(steps: 5, current: 2)
/// ```
class StepIndicator extends StatelessWidget {
  const StepIndicator({
    super.key,
    required this.steps,
    required this.current,
    this.dotSize = 40,
  });

  /// Total number of steps.
  final int steps;

  /// The active step (1-based).
  final int current;
  final double dotSize;

  @override
  Widget build(BuildContext context) {
    final children = <Widget>[];
    for (var i = 1; i <= steps; i++) {
      if (i > 1) {
        final reached = i <= current;
        children.add(Expanded(
          child: Container(
            height: 3,
            color: reached ? AppColors.primary : AppColors.border,
          ),
        ));
      }
      children.add(_dot(i));
    }
    return Row(children: children);
  }

  Widget _dot(int i) {
    final isDone = i < current;
    final isCurrent = i == current;
    final background = isDone
        ? AppColors.primary
        : isCurrent
            ? AppColors.magenta
            : AppColors.background;
    final foreground =
        (isDone || isCurrent) ? AppColors.textOnPrimary : AppColors.textHint;

    return Container(
      width: dotSize,
      height: dotSize,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: background,
        border: (isDone || isCurrent)
            ? null
            : Border.all(color: AppColors.border),
      ),
      child: isDone
          ? Icon(Icons.check, size: 20, color: foreground)
          : Text('$i',
              style: AppTextStyles.title.copyWith(color: foreground)),
    );
  }
}
