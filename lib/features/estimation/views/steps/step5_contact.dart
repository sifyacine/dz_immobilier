import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

import '../../../../app/constants/app_constants.dart';
import '../../../../app/theme/app_colors.dart';
import '../../../../app/theme/app_text_styles.dart';
import '../../controllers/estimation_controller.dart';
import '../widgets/step_hint_box.dart';
import '../widgets/step_title.dart';
import '../widgets/step_field_label.dart';

class Step5Contact extends GetView<EstimationController> {
  const Step5Contact({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const StepTitle(
          prefix: 'Obtenez votre',
          accent: 'rapport personnalisé.',
        ),
        const SizedBox(height: AppConstants.spacingMd),
        const StepHintBox(
          text: 'Un conseiller DZ-Immobilier vous contactera dans les 24h '
              'pour valider l\'estimation et vous conseiller.',
        ),
        const SizedBox(height: AppConstants.spacingLg),

        // ── Full name ───────────────────────────────────────────────────
        const StepFieldLabel(label: 'NOM COMPLET', required: true),
        const SizedBox(height: AppConstants.spacingSm),
        TextFormField(
          controller: controller.fullNameCtrl,
          textCapitalization: TextCapitalization.words,
          style: AppTextStyles.body,
          decoration: const InputDecoration(hintText: 'Mohamed Amine'),
          onChanged: (v) => controller.fullNameText.value = v,
        ),
        const SizedBox(height: AppConstants.spacingMd),

        // ── Phone + Email ───────────────────────────────────────────────
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              flex: 3,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const StepFieldLabel(label: 'TÉLÉPHONE', required: true),
                  const SizedBox(height: AppConstants.spacingSm),
                  TextFormField(
                    controller: controller.phoneCtrl,
                    keyboardType: TextInputType.phone,
                    inputFormatters: [
                      FilteringTextInputFormatter.allow(RegExp(r'[0-9+ ]')),
                    ],
                    style: AppTextStyles.body,
                    decoration: const InputDecoration(
                        hintText: '+213 5XX XX XX XX'),
                    onChanged: (v) => controller.phoneText.value = v,
                  ),
                ],
              ),
            ),
            const SizedBox(width: AppConstants.spacingSm),
            Expanded(
              flex: 2,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const StepFieldLabel(label: 'EMAIL', required: false),
                  const SizedBox(height: AppConstants.spacingSm),
                  TextFormField(
                    controller: controller.emailCtrl,
                    keyboardType: TextInputType.emailAddress,
                    style: AppTextStyles.body,
                    decoration: const InputDecoration(
                        hintText: 'contact@email.dz'),
                  ),
                ],
              ),
            ),
          ],
        ),
        const SizedBox(height: AppConstants.spacingMd),

        // ── Consent checkbox ────────────────────────────────────────────
        Obx(() => Container(
              decoration: BoxDecoration(
                color: AppColors.background,
                borderRadius: BorderRadius.circular(AppConstants.radiusSm),
                border: Border.all(color: AppColors.border),
              ),
              child: CheckboxListTile(
                dense: true,
                value: controller.agreeContact.value,
                activeColor: AppColors.primary,
                title: Text(
                  "J'accepte d'être contacté par un conseiller DZ-Immobilier.",
                  style: AppTextStyles.bodySecondary,
                ),
                onChanged: (v) => controller.agreeContact.value = v ?? false,
              ),
            )),
        const SizedBox(height: AppConstants.spacingMd),

        // ── Bonus question ──────────────────────────────────────────────
        Container(
          padding: const EdgeInsets.all(AppConstants.spacingMd),
          decoration: BoxDecoration(
            color: AppColors.successSurface,
            borderRadius: BorderRadius.circular(AppConstants.radiusMd),
            border: Border.all(color: AppColors.success.withValues(alpha: 0.3)),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                    decoration: BoxDecoration(
                      color: AppColors.success.withValues(alpha: 0.15),
                      borderRadius:
                          BorderRadius.circular(AppConstants.radiusPill),
                    ),
                    child: Text(
                      '📍  QUESTION BONUS · VOTRE INTUITION',
                      style: AppTextStyles.caption.copyWith(
                        color: AppColors.success,
                        fontWeight: FontWeight.w700,
                        letterSpacing: 0.3,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: AppConstants.spacingSm),
              Text(
                'Et vous — quelle est votre intuition ?',
                style: AppTextStyles.title,
              ),
              const SizedBox(height: AppConstants.spacingXs),
              Text(
                'Avant de dévoiler notre estimation, dites-nous : quel prix avez-VOUS en tête ? '
                '(facultatif, mais utile pour comparer votre perception avec le marché)',
                style: AppTextStyles.caption
                    .copyWith(color: AppColors.textSecondary),
              ),
              const SizedBox(height: AppConstants.spacingSm),
              const StepFieldLabel(label: 'VOTRE ESTIMATION', required: false),
              const SizedBox(height: AppConstants.spacingXs),
              Row(
                children: [
                  Expanded(
                    child: TextFormField(
                      controller: controller.userEstimateCtrl,
                      keyboardType: TextInputType.number,
                      inputFormatters: [
                        FilteringTextInputFormatter.digitsOnly,
                      ],
                      style: AppTextStyles.body,
                      decoration:
                          const InputDecoration(hintText: 'ex. 45 000 000'),
                    ),
                  ),
                  const SizedBox(width: AppConstants.spacingXs),
                  Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 12, vertical: 14),
                    decoration: BoxDecoration(
                      color: AppColors.surface,
                      borderRadius:
                          BorderRadius.circular(AppConstants.radiusSm),
                      border: Border.all(color: AppColors.border),
                    ),
                    child: Text(
                      'DA total',
                      style: AppTextStyles.caption
                          .copyWith(fontWeight: FontWeight.w600),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
        const SizedBox(height: AppConstants.spacingMd),

        // ── Privacy notice ──────────────────────────────────────────────
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(Icons.shield_outlined,
                size: 14, color: AppColors.success),
            const SizedBox(width: 6),
            Expanded(
              child: Text(
                'Vos données sont confidentielles et utilisées uniquement '
                'pour vous envoyer votre estimation. '
                'Aucune communication commerciale sans consentement explicite.',
                style: AppTextStyles.caption
                    .copyWith(color: AppColors.textSecondary),
              ),
            ),
          ],
        ),
        const SizedBox(height: AppConstants.spacingMd),
      ],
    );
  }
}
