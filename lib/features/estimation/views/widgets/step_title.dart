import 'package:flutter/material.dart';

import '../../../../app/theme/app_colors.dart';
import '../../../../app/theme/app_text_styles.dart';

/// Large two-part step title: regular black prefix + italic purple accent.
class StepTitle extends StatelessWidget {
  final String prefix;
  final String accent;

  const StepTitle({super.key, required this.prefix, required this.accent});

  @override
  Widget build(BuildContext context) {
    return RichText(
      text: TextSpan(
        style: AppTextStyles.h1.copyWith(fontSize: 30, height: 1.2),
        children: [
          TextSpan(text: '$prefix '),
          TextSpan(
            text: accent,
            style: AppTextStyles.h1.copyWith(
              fontSize: 30,
              fontStyle: FontStyle.italic,
              color: AppColors.primary,
            ),
          ),
        ],
      ),
    );
  }
}
