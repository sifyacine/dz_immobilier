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

/// Localized label for an employment-type code.
String employmentLabel(BuildContext context, String code) {
  final l10n = context.l10n;
  switch (code) {
    case 'salaried':
      return l10n.simEmpSalaried;
    case 'civil_servant':
      return l10n.simEmpCivilServant;
    case 'self_employed':
      return l10n.simEmpSelfEmployed;
    case 'business_owner':
      return l10n.simEmpBusinessOwner;
    default:
      return code;
  }
}

class Step3Income extends GetView<SimulationController> {
  const Step3Income({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        StepTitle(
            prefix: context.l10n.simStep3Prefix,
            accent: context.l10n.simStep3Accent),
        const SizedBox(height: AppConstants.spacingLg),

        // ── Income + Age ────────────────────────────────────────────────
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              flex: 3,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  StepFieldLabel(
                      label: context.l10n.simMonthlyIncomeLabel,
                      required: true),
                  const SizedBox(height: AppConstants.spacingSm),
                  TextFormField(
                    controller: controller.netIncomeCtrl,
                    keyboardType: TextInputType.number,
                    inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                    style: AppTextStyles.body,
                    decoration:
                        InputDecoration(hintText: context.l10n.simIncomeHint),
                    onChanged: (v) => controller.netIncomeText.value = v,
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
                  StepFieldLabel(
                      label: context.l10n.simAgeLabel, required: true),
                  const SizedBox(height: AppConstants.spacingSm),
                  TextFormField(
                    controller: controller.ageCtrl,
                    keyboardType: TextInputType.number,
                    inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                    style: AppTextStyles.body,
                    decoration:
                        InputDecoration(hintText: context.l10n.simAgeHint),
                    onChanged: (v) => controller.ageText.value = v,
                  ),
                ],
              ),
            ),
          ],
        ),

        const SizedBox(height: AppConstants.spacingMd),

        // ── Employment type ─────────────────────────────────────────────
        StepFieldLabel(
            label: context.l10n.simEmploymentTypeLabel, required: true),
        const SizedBox(height: AppConstants.spacingSm),
        Obx(() => InputDecorator(
              decoration: const InputDecoration(
                contentPadding:
                    EdgeInsets.symmetric(horizontal: 16, vertical: 4),
              ),
              child: DropdownButtonHideUnderline(
                child: DropdownButton<String>(
                  value: controller.selectedEmploymentType.value.isEmpty
                      ? null
                      : controller.selectedEmploymentType.value,
                  isExpanded: true,
                  hint: Text(
                    context.l10n.commonSelect,
                    style: AppTextStyles.body
                        .copyWith(color: AppColors.textHint),
                  ),
                  items: SimulationController.employmentTypes
                      .map((type) => DropdownMenuItem(
                            value: type,
                            child: Text(employmentLabel(context, type),
                                style: AppTextStyles.body),
                          ))
                      .toList(),
                  onChanged: (v) =>
                      controller.selectedEmploymentType.value = v ?? '',
                ),
              ),
            )),

        const SizedBox(height: AppConstants.spacingMd),

        // ── State subsidy thresholds ────────────────────────────────────
        _InfoBox(
          icon: '🏛️',
          title: context.l10n.simStateTiersTitle,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _ThresholdRow(text: context.l10n.simIncomeTier1),
              const SizedBox(height: 4),
              _ThresholdRow(text: context.l10n.simIncomeTier2),
              const SizedBox(height: 4),
              Text(
                context.l10n.simIncomeAboveMarket,
                style: AppTextStyles.caption
                    .copyWith(color: AppColors.textSecondary),
              ),
            ],
          ),
        ),

        const SizedBox(height: AppConstants.spacingSm),

        // ── Age limit (dynamic) ─────────────────────────────────────────
        Obx(() {
          final age = controller.age;
          final maxTerm = controller.maxLoanTerm;
          if (age <= 0) return const SizedBox.shrink();
          return _InfoBox(
            icon: '📅',
            title: context.l10n.simAgeLimitTitle,
            child: Text(
              context.l10n.simAgeLimitBody(maxTerm),
              style: AppTextStyles.caption
                  .copyWith(color: AppColors.textSecondary),
            ),
          );
        }),

        const SizedBox(height: AppConstants.spacingMd),
      ],
    );
  }
}

// ── Info box ──────────────────────────────────────────────────────────────────

class _InfoBox extends StatelessWidget {
  final String icon;
  final String title;
  final Widget child;

  const _InfoBox(
      {required this.icon, required this.title, required this.child});

  @override
  Widget build(BuildContext context) {
    return Container(
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
              Text(icon, style: const TextStyle(fontSize: 16)),
              const SizedBox(width: 6),
              Text(
                title,
                style:
                    AppTextStyles.body.copyWith(fontWeight: FontWeight.w700),
              ),
            ],
          ),
          const SizedBox(height: AppConstants.spacingSm),
          child,
        ],
      ),
    );
  }
}

// ── Threshold row ─────────────────────────────────────────────────────────────

class _ThresholdRow extends StatelessWidget {
  final String text;

  const _ThresholdRow({required this.text});

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
