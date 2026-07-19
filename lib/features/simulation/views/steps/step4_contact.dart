import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

import '../../../../app/constants/app_constants.dart';
import '../../../../app/theme/app_colors.dart';
import '../../../../app/theme/app_text_styles.dart';
import '../../../../shared/extensions/l10n_extension.dart';
import '../../../estimation/views/widgets/step_field_label.dart';
import '../../../estimation/views/widgets/step_title.dart';
import '../../controllers/simulation_controller.dart';

class Step4Contact extends GetView<SimulationController> {
  const Step4Contact({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        StepTitle(
            prefix: context.l10n.simStep4Prefix,
            accent: context.l10n.simStep4Accent),
        const SizedBox(height: AppConstants.spacingLg),

        // ── Full name ───────────────────────────────────────────────────
        StepFieldLabel(label: context.l10n.simFullNameLabel, required: true),
        const SizedBox(height: AppConstants.spacingSm),
        TextFormField(
          controller: controller.fullNameCtrl,
          textCapitalization: TextCapitalization.words,
          style: AppTextStyles.body,
          decoration:
              InputDecoration(hintText: context.l10n.simFullNameHint),
          onChanged: (v) => controller.fullNameText.value = v,
        ),

        const SizedBox(height: AppConstants.spacingMd),

        // ── Phone ───────────────────────────────────────────────────────
        StepFieldLabel(label: context.l10n.simPhoneLabel, required: true),
        const SizedBox(height: AppConstants.spacingSm),
        TextFormField(
          controller: controller.phoneCtrl,
          keyboardType: TextInputType.phone,
          inputFormatters: [
            FilteringTextInputFormatter.allow(RegExp(r'[0-9+ ]')),
          ],
          style: AppTextStyles.body,
          decoration: InputDecoration(hintText: context.l10n.simPhoneHint),
          onChanged: (v) => controller.phoneText.value = v,
        ),

        const SizedBox(height: AppConstants.spacingMd),

        // ── Email (optional) ────────────────────────────────────────────
        StepFieldLabel(label: context.l10n.simEmailLabel, required: false),
        const SizedBox(height: AppConstants.spacingSm),
        TextFormField(
          controller: controller.emailCtrl,
          keyboardType: TextInputType.emailAddress,
          style: AppTextStyles.body,
          decoration: InputDecoration(hintText: context.l10n.simEmailHint),
        ),

        const SizedBox(height: AppConstants.spacingMd),

        // ── Privacy notice ──────────────────────────────────────────────
        Container(
          padding: const EdgeInsets.all(AppConstants.spacingMd),
          decoration: BoxDecoration(
            color: AppColors.background,
            borderRadius: BorderRadius.circular(AppConstants.radiusMd),
            border: Border.all(color: AppColors.border),
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Icon(Icons.shield_outlined,
                  size: 16, color: AppColors.success),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  context.l10n.simPrivacyNotice,
                  style: AppTextStyles.caption
                      .copyWith(color: AppColors.textSecondary),
                ),
              ),
            ],
          ),
        ),

        const SizedBox(height: AppConstants.spacingMd),
      ],
    );
  }
}
