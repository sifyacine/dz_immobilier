import 'package:flutter/material.dart';

import '../../../app/theme/app_colors.dart';
import '../../../app/theme/app_gradients.dart';
import '../../../app/theme/app_text_styles.dart';
import '../../../shared/widgets/app_logo.dart';

/// Gradient hero header shared by Login, Register, and Forgot Password screens.
class AuthHeader extends StatelessWidget {
  final String title;
  final String subtitle;

  const AuthHeader({
    super.key,
    required this.title,
    required this.subtitle,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: const BoxDecoration(
        gradient: AppGradients.purpleFade,
      ),
      padding: const EdgeInsets.only(
        top: 64,
        bottom: 48,
        left: 28,
        right: 28,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const AppLogo(wordmark: true, height: 30, color: Colors.white),
          const SizedBox(height: 28),
          Text(
            title,
            style: AppTextStyles.h1.copyWith(
              color: AppColors.textOnPrimary,
              fontSize: 30,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            subtitle,
            style: AppTextStyles.bodySecondary.copyWith(
              color: Colors.white.withValues(alpha: 0.80),
            ),
          ),
        ],
      ),
    );
  }
}
