import 'package:flutter/material.dart';

import '../../../../app/theme/app_colors.dart';
import '../../../../app/theme/app_text_styles.dart';

/// Uppercase field label with optional required asterisk.
class StepFieldLabel extends StatelessWidget {
  final String label;
  final bool required;

  const StepFieldLabel({super.key, required this.label, this.required = false});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Text(
          label,
          style: AppTextStyles.caption.copyWith(
            color: AppColors.textSecondary,
            fontWeight: FontWeight.w700,
            letterSpacing: 0.6,
          ),
        ),
        if (required) ...[
          const SizedBox(width: 4),
          Text(' *',
              style: AppTextStyles.caption
                  .copyWith(color: AppColors.error, fontWeight: FontWeight.w700)),
        ],
      ],
    );
  }
}
