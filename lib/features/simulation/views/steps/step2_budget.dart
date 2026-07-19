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

class Step2Budget extends GetView<SimulationController> {
  const Step2Budget({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        StepTitle(
            prefix: context.l10n.simStep2Prefix,
            accent: context.l10n.simStep2Accent),
        const SizedBox(height: AppConstants.spacingLg),

        // ── Property price ──────────────────────────────────────────────
        StepFieldLabel(
            label: context.l10n.simPropertyPriceLabel, required: true),
        const SizedBox(height: AppConstants.spacingSm),
        TextFormField(
          controller: controller.propertyPriceCtrl,
          keyboardType: TextInputType.number,
          inputFormatters: [FilteringTextInputFormatter.digitsOnly],
          style: AppTextStyles.body,
          decoration:
              InputDecoration(hintText: context.l10n.simPropertyPriceHint),
          onChanged: (v) => controller.propertyPriceText.value = v,
        ),

        const SizedBox(height: AppConstants.spacingMd),

        // ── Down payment ────────────────────────────────────────────────
        StepFieldLabel(
            label: context.l10n.simDownPaymentLabel, required: true),
        const SizedBox(height: AppConstants.spacingSm),
        TextFormField(
          controller: controller.downPaymentCtrl,
          keyboardType: TextInputType.number,
          inputFormatters: [FilteringTextInputFormatter.digitsOnly],
          style: AppTextStyles.body,
          decoration:
              InputDecoration(hintText: context.l10n.simDownPaymentHint),
          onChanged: (v) => controller.downPaymentText.value = v,
        ),

        const SizedBox(height: AppConstants.spacingMd),

        // ── Leverage info box ───────────────────────────────────────────
        Container(
          padding: const EdgeInsets.all(AppConstants.spacingMd),
          decoration: BoxDecoration(
            color: AppColors.violetSurface,
            borderRadius: BorderRadius.circular(AppConstants.radiusMd),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  const Text('💰', style: TextStyle(fontSize: 16)),
                  const SizedBox(width: 6),
                  Expanded(
                    child: Text(
                      context.l10n.simLeverageTitle,
                      style: AppTextStyles.body
                          .copyWith(fontWeight: FontWeight.w700),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: AppConstants.spacingSm),
              _BulletPoint(text: context.l10n.simLeverageMin),
              const SizedBox(height: 4),
              _BulletPoint(text: context.l10n.simLeverageRec),
              const SizedBox(height: 4),
              _BulletPoint(text: context.l10n.simLeverageEff),
            ],
          ),
        ),

        const SizedBox(height: AppConstants.spacingMd),
      ],
    );
  }
}

// ── Bullet point helper ───────────────────────────────────────────────────────

class _BulletPoint extends StatelessWidget {
  final String text;

  const _BulletPoint({required this.text});

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          margin: const EdgeInsets.only(top: 5),
          width: 5,
          height: 5,
          decoration: const BoxDecoration(
            color: AppColors.primary,
            shape: BoxShape.circle,
          ),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: Text(
            text,
            style: AppTextStyles.caption
                .copyWith(color: AppColors.textSecondary),
          ),
        ),
      ],
    );
  }
}
