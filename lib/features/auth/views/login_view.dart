import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../app/constants/app_constants.dart';
import '../../../app/theme/app_colors.dart';
import '../../../app/theme/app_text_styles.dart';
import '../../../shared/widgets/app_button.dart';
import '../../../shared/helpers/validators.dart';
import '../../../shared/extensions/l10n_extension.dart';
import '../controllers/auth_controller.dart';
import '../widgets/auth_header.dart';
import '../widgets/auth_text_field.dart';

class LoginView extends GetView<AuthController> {
  const LoginView({super.key});

  @override
  Widget build(BuildContext context) {
    final formKey = GlobalKey<FormState>();
    final emailCtrl = TextEditingController();
    final passwordCtrl = TextEditingController();

    return Scaffold(
      backgroundColor: AppColors.background,
      body: Column(
        children: [
          // ── Gradient header ────────────────────────────────────────────
          AuthHeader(
            title: context.l10n.authLoginTitle,
            subtitle: context.l10n.authLoginSubtitle,
          ),

          // ── Form card ──────────────────────────────────────────────────
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
                child: Form(
                  key: formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      // Email
                      AuthTextField(
                        controller: emailCtrl,
                        label: context.l10n.authEmailLabel,
                        hint: context.l10n.authEmailHint,
                        prefixIcon: Icons.email_outlined,
                        keyboardType: TextInputType.emailAddress,
                        validator: (v) => Validators.email(v,
                            requiredMsg: context.l10n.valEmailRequired,
                            invalidMsg: context.l10n.valEmailInvalid),
                      ),
                      const SizedBox(height: AppConstants.spacingMd),

                      // Password
                      Obx(() => AuthTextField(
                            controller: passwordCtrl,
                            label: context.l10n.authPasswordLabel,
                            hint: '••••••••',
                            prefixIcon: Icons.lock_outlined,
                            obscureText: controller.obscurePassword.value,
                            textInputAction: TextInputAction.done,
                            validator: (v) => Validators.password(v,
                                requiredMsg: context.l10n.valPasswordRequired,
                                minMsg: context.l10n.valPasswordMin),
                            suffixWidget: IconButton(
                              icon: Icon(
                                controller.obscurePassword.value
                                    ? Icons.visibility_outlined
                                    : Icons.visibility_off_outlined,
                                size: 20,
                                color: AppColors.textHint,
                              ),
                              onPressed: () => controller.obscurePassword
                                  .value = !controller.obscurePassword.value,
                            ),
                          )),
                      const SizedBox(height: AppConstants.spacingSm),

                      // Forgot password link
                      Align(
                        alignment: Alignment.centerRight,
                        child: GestureDetector(
                          onTap: controller.goToForgotPassword,
                          child: Text(
                            context.l10n.authForgotPasswordLink,
                            style: AppTextStyles.body.copyWith(
                              color: AppColors.primary,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: AppConstants.spacingXl),

                      // CTA
                      Obx(() => AppButton(
                            label: context.l10n.authLoginBtn,
                            variant: AppButtonVariant.gradient,
                            trailingIcon: Icons.arrow_forward,
                            isLoading: controller.isLoading.value,
                            onPressed: () {
                              if (formKey.currentState!.validate()) {
                                controller.login(
                                  email: emailCtrl.text.trim(),
                                  password: passwordCtrl.text,
                                );
                              }
                            },
                          )),
                      const SizedBox(height: AppConstants.spacingXl),

                      // Divider
                      Row(children: [
                        const Expanded(child: Divider()),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 12),
                          child: Text(context.l10n.commonOr,
                              style: AppTextStyles.caption
                                  .copyWith(color: AppColors.textHint)),
                        ),
                        const Expanded(child: Divider()),
                      ]),
                      const SizedBox(height: AppConstants.spacingXl),

                      // Sign up link
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text('${context.l10n.authNoAccount} ',
                              style: AppTextStyles.body
                                  .copyWith(color: AppColors.textSecondary)),
                          GestureDetector(
                            onTap: controller.goToRegister,
                            child: Text(
                              context.l10n.authSignUp,
                              style: AppTextStyles.body.copyWith(
                                color: AppColors.primary,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
