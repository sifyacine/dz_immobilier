import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../app/constants/app_constants.dart';
import '../../../app/theme/app_colors.dart';
import '../../../app/theme/app_gradients.dart';
import '../../../app/theme/app_text_styles.dart';
import '../../../shared/widgets/app_button.dart';
import '../../../shared/helpers/validators.dart';
import '../../../shared/extensions/l10n_extension.dart';
import '../controllers/auth_controller.dart';
import '../widgets/auth_header.dart';
import '../widgets/auth_text_field.dart';

class ForgotPasswordView extends GetView<AuthController> {
  const ForgotPasswordView({super.key});

  @override
  Widget build(BuildContext context) {
    final formKey = GlobalKey<FormState>();
    final emailCtrl = TextEditingController();

    return Scaffold(
      backgroundColor: AppColors.background,
      body: Column(
        children: [
          // ── Gradient header ────────────────────────────────────────────
          AuthHeader(
            title: context.l10n.authForgotPasswordTitle,
            subtitle: context.l10n.authForgotPasswordSubtitle,
          ),

          // ── Form / success card ────────────────────────────────────────
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                color: AppColors.background,
                borderRadius: const BorderRadius.vertical(
                  top: Radius.circular(AppConstants.radiusLg),
                ),
              ),
              transform: Matrix4.translationValues(0, -AppConstants.radiusLg, 0),
              child: SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(
                  AppConstants.spacingLg,
                  AppConstants.spacingXl,
                  AppConstants.spacingLg,
                  AppConstants.spacingXl,
                ),
                child: Obx(() {
                  // ── Success state ──────────────────────────────────────
                  if (controller.emailSent.value) {
                    return _SuccessState(email: emailCtrl.text.trim());
                  }

                  // ── Form state ─────────────────────────────────────────
                  return Form(
                    key: formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        AuthTextField(
                          controller: emailCtrl,
                          label: context.l10n.authEmailLabel,
                          hint: context.l10n.authEmailHint,
                          prefixIcon: Icons.email_outlined,
                          keyboardType: TextInputType.emailAddress,
                          textInputAction: TextInputAction.done,
                          validator: (v) => Validators.email(v,
                              requiredMsg: context.l10n.valEmailRequired,
                              invalidMsg: context.l10n.valEmailInvalid),
                        ),
                        const SizedBox(height: AppConstants.spacingXl),

                        // CTA
                        Obx(() => AppButton(
                              label: context.l10n.authSendResetLink,
                              variant: AppButtonVariant.gradient,
                              trailingIcon: Icons.send_outlined,
                              isLoading: controller.isLoading.value,
                              onPressed: () {
                                if (formKey.currentState!.validate()) {
                                  controller.forgotPassword(
                                    email: emailCtrl.text.trim(),
                                  );
                                }
                              },
                            )),
                        const SizedBox(height: AppConstants.spacingXl),

                        // Back to login
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Icon(Icons.arrow_back,
                                size: 16, color: AppColors.primary),
                            const SizedBox(width: 6),
                            GestureDetector(
                              onTap: () => Get.back(),
                              child: Text(
                                context.l10n.authBackToLogin,
                                style: AppTextStyles.body.copyWith(
                                  color: AppColors.primary,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  );
                }),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ── Success state widget ──────────────────────────────────────────────────────

class _SuccessState extends StatelessWidget {
  final String email;
  const _SuccessState({required this.email});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        // Icon circle
        Center(
          child: Container(
            width: 96,
            height: 96,
            decoration: const BoxDecoration(
              gradient: AppGradients.purpleFade,
              shape: BoxShape.circle,
            ),
            child: const Icon(Icons.mark_email_read_outlined,
                size: 48, color: Colors.white),
          ),
        ),
        const SizedBox(height: AppConstants.spacingXl),

        Text(
          context.l10n.authResetSentTitle,
          textAlign: TextAlign.center,
          style: AppTextStyles.h2,
        ),
        const SizedBox(height: AppConstants.spacingMd),

        Text(
          context.l10n.authResetSentBody(email),
          textAlign: TextAlign.center,
          style: AppTextStyles.bodySecondary,
        ),
        const SizedBox(height: AppConstants.spacingXl + AppConstants.spacingMd),

        AppButton(
          label: context.l10n.authBackToLogin,
          variant: AppButtonVariant.gradient,
          icon: Icons.arrow_back,
          onPressed: () => Get.back(),
        ),
      ],
    );
  }
}
