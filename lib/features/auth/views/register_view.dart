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

class RegisterView extends GetView<AuthController> {
  const RegisterView({super.key});

  @override
  Widget build(BuildContext context) {
    final formKey = GlobalKey<FormState>();
    final nameCtrl = TextEditingController();
    final emailCtrl = TextEditingController();
    final phoneCtrl = TextEditingController();
    final passwordCtrl = TextEditingController();
    final confirmCtrl = TextEditingController();

    return Scaffold(
      backgroundColor: AppColors.background,
      body: Column(
        children: [
          // ── Gradient header ────────────────────────────────────────────
          AuthHeader(
            title: context.l10n.authRegisterTitle,
            subtitle: context.l10n.authRegisterSubtitle,
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
                      // Full name
                      AuthTextField(
                        controller: nameCtrl,
                        label: context.l10n.authNameLabel,
                        hint: context.l10n.authNameHint,
                        prefixIcon: Icons.person_outline,
                        validator: (v) => Validators.requiredField(v,
                            message: context.l10n.valNameRequired),
                      ),
                      const SizedBox(height: AppConstants.spacingMd),

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

                      // Phone
                      AuthTextField(
                        controller: phoneCtrl,
                        label: context.l10n.authPhoneLabel,
                        hint: context.l10n.authPhoneHint,
                        prefixIcon: Icons.phone_outlined,
                        keyboardType: TextInputType.phone,
                        validator: (v) => Validators.phone(v,
                            requiredMsg: context.l10n.valPhoneRequired,
                            invalidMsg: context.l10n.valPhoneInvalid),
                      ),
                      const SizedBox(height: AppConstants.spacingMd),

                      // Password
                      Obx(() => AuthTextField(
                            controller: passwordCtrl,
                            label: context.l10n.authPasswordLabel,
                            hint: '••••••••',
                            prefixIcon: Icons.lock_outlined,
                            obscureText: controller.obscurePassword.value,
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
                      const SizedBox(height: AppConstants.spacingMd),

                      // Confirm password
                      Obx(() => AuthTextField(
                            controller: confirmCtrl,
                            label: context.l10n.authConfirmPasswordLabel,
                            hint: '••••••••',
                            prefixIcon: Icons.lock_outlined,
                            obscureText: controller.obscureConfirm.value,
                            textInputAction: TextInputAction.done,
                            validator: (v) {
                              if (v == null || v.isEmpty) {
                                return context.l10n.valConfirmRequired;
                              }
                              if (v != passwordCtrl.text) {
                                return context.l10n.valPasswordMismatch;
                              }
                              return null;
                            },
                            suffixWidget: IconButton(
                              icon: Icon(
                                controller.obscureConfirm.value
                                    ? Icons.visibility_outlined
                                    : Icons.visibility_off_outlined,
                                size: 20,
                                color: AppColors.textHint,
                              ),
                              onPressed: () => controller.obscureConfirm.value =
                                  !controller.obscureConfirm.value,
                            ),
                          )),
                      const SizedBox(height: AppConstants.spacingXl),

                      // CTA
                      Obx(() => AppButton(
                            label: context.l10n.authRegisterBtn,
                            variant: AppButtonVariant.gradient,
                            trailingIcon: Icons.arrow_forward,
                            isLoading: controller.isLoading.value,
                            onPressed: () {
                              if (formKey.currentState!.validate()) {
                                controller.register(
                                  name: nameCtrl.text.trim(),
                                  email: emailCtrl.text.trim(),
                                  phone: phoneCtrl.text.trim(),
                                  password: passwordCtrl.text,
                                );
                              }
                            },
                          )),
                      const SizedBox(height: AppConstants.spacingXl),

                      // Login link
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text('${context.l10n.authAlreadyAccount} ',
                              style: AppTextStyles.body
                                  .copyWith(color: AppColors.textSecondary)),
                          GestureDetector(
                            onTap: () => Get.back(),
                            child: Text(
                              context.l10n.authSignIn,
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
