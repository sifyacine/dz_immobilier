import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../app/constants/app_constants.dart';
import '../../../app/theme/app_colors.dart';
import '../../../app/theme/app_gradients.dart';
import '../../../app/theme/app_text_styles.dart';
import '../../../shared/extensions/l10n_extension.dart';
import '../../../shared/widgets/app_button.dart';
import '../../../shared/widgets/app_progress_bar.dart';
import '../controllers/simulation_controller.dart';
import 'steps/step1_property_type.dart';
import 'steps/step2_budget.dart';
import 'steps/step3_income.dart';
import 'steps/step4_contact.dart';

class SimulationView extends GetView<SimulationController> {
  const SimulationView({super.key});

  static String stepLabel(BuildContext context, int step) {
    final l10n = context.l10n;
    switch (step) {
      case 0:
        return l10n.simulationStepType;
      case 1:
        return l10n.simulationStepBudget;
      case 2:
        return l10n.simulationStepIncome;
      default:
        return l10n.simulationStepContact;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: Column(
        children: [
          _SimHeader(controller: controller),
          Expanded(
            child: Container(
              margin: const EdgeInsets.fromLTRB(
                AppConstants.spacingMd,
                0,
                AppConstants.spacingMd,
                AppConstants.spacingMd,
              ),
              decoration: BoxDecoration(
                color: AppColors.surface,
                borderRadius: BorderRadius.circular(AppConstants.radiusLg),
                boxShadow: [
                  BoxShadow(
                    color: AppColors.primary.withValues(alpha: 0.08),
                    blurRadius: 24,
                    offset: const Offset(0, 8),
                  ),
                ],
              ),
              child: Column(
                children: [
                  // ── Progress bar ────────────────────────────────────────
                  Obx(() => Padding(
                        padding: const EdgeInsets.fromLTRB(
                          AppConstants.spacingMd,
                          AppConstants.spacingMd,
                          AppConstants.spacingMd,
                          AppConstants.spacingSm,
                        ),
                        child: AppProgressBar(
                          value: controller.progress,
                          label: context.l10n.commonStepProgress(
                            controller.currentStep.value + 1,
                            SimulationController.totalSteps,
                          ),
                        ),
                      )),

                  // ── Step badge pill ─────────────────────────────────────
                  Obx(() => Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: AppConstants.spacingMd),
                        child: Align(
                          alignment: Alignment.centerLeft,
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 14, vertical: 6),
                            decoration: BoxDecoration(
                              border: Border.all(color: AppColors.primary),
                              borderRadius: BorderRadius.circular(
                                  AppConstants.radiusPill),
                            ),
                            child: Text(
                              stepLabel(context, controller.currentStep.value),
                              style: AppTextStyles.caption.copyWith(
                                color: AppColors.primary,
                                fontWeight: FontWeight.w700,
                                letterSpacing: 0.5,
                              ),
                            ),
                          ),
                        ),
                      )),

                  const SizedBox(height: AppConstants.spacingSm),

                  // ── Step content ────────────────────────────────────────
                  Expanded(
                    child: Obx(() => AnimatedSwitcher(
                          duration: AppConstants.animationDuration,
                          child: SingleChildScrollView(
                            key: ValueKey(controller.currentStep.value),
                            padding: const EdgeInsets.symmetric(
                                horizontal: AppConstants.spacingMd),
                            child: _buildStep(controller.currentStep.value),
                          ),
                        )),
                  ),

                  // ── Nav buttons ─────────────────────────────────────────
                  _SimNavButtons(controller: controller),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStep(int step) {
    switch (step) {
      case 0:
        return const Step1PropertyType();
      case 1:
        return const Step2Budget();
      case 2:
        return const Step3Income();
      case 3:
        return const Step4Contact();
      default:
        return const SizedBox();
    }
  }
}

// ── Gradient header ───────────────────────────────────────────────────────────

class _SimHeader extends StatelessWidget {
  final SimulationController controller;
  const _SimHeader({required this.controller});

  @override
  Widget build(BuildContext context) {
    final top = MediaQuery.of(context).padding.top;
    return Container(
      width: double.infinity,
      decoration: const BoxDecoration(gradient: AppGradients.purpleFade),
      padding: EdgeInsets.fromLTRB(
          AppConstants.spacingMd, top + 12, AppConstants.spacingMd, 20),
      child: Row(
        children: [
          Material(
            color: Colors.white.withValues(alpha: 0.20),
            shape: const CircleBorder(),
            clipBehavior: Clip.antiAlias,
            child: InkWell(
              onTap: () {
                if (controller.currentStep.value > 0) {
                  controller.prevStep();
                } else {
                  Get.back();
                }
              },
              child: const SizedBox(
                width: 38,
                height: 38,
                child: Icon(Icons.arrow_back, size: 20, color: Colors.white),
              ),
            ),
          ),
          const SizedBox(width: AppConstants.spacingSm),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Simulez votre financement',
                  style: AppTextStyles.title.copyWith(
                      color: Colors.white, fontWeight: FontWeight.w700),
                ),
                const SizedBox(height: 2),
                Text(
                  'Trouvez le crédit adapté à votre profil',
                  style: AppTextStyles.caption
                      .copyWith(color: Colors.white.withValues(alpha: 0.80)),
                ),
              ],
            ),
          ),
          const SizedBox(width: AppConstants.spacingSm),
          Material(
            color: Colors.white,
            borderRadius: BorderRadius.circular(AppConstants.radiusPill),
            clipBehavior: Clip.antiAlias,
            child: InkWell(
              onTap: () => controller.currentStep.value = 0,
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      context.l10n.commonRestart,
                      style: AppTextStyles.caption.copyWith(
                        color: AppColors.primary,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(width: 4),
                    Icon(Icons.refresh, size: 14, color: AppColors.primary),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ── Navigation buttons ────────────────────────────────────────────────────────

class _SimNavButtons extends StatelessWidget {
  final SimulationController controller;
  const _SimNavButtons({required this.controller});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final step = controller.currentStep.value;
      final isLast = step == SimulationController.totalSteps - 1;
      final l10n = context.l10n;
      final ctaLabel = isLast
          ? l10n.simulationSeeOffers
          : step == 0
              ? l10n.commonContinue
              : step == 2
                  ? l10n.simulationCalculate
                  : l10n.commonNext;

      return Padding(
        padding: const EdgeInsets.fromLTRB(
          AppConstants.spacingMd,
          AppConstants.spacingSm,
          AppConstants.spacingMd,
          AppConstants.spacingMd,
        ),
        child: Row(
          children: [
            if (step > 0) ...[
              AppButton(
                label: l10n.commonBack,
                icon: Icons.arrow_back,
                variant: AppButtonVariant.ghost,
                expanded: false,
                onPressed: controller.prevStep,
              ),
              const SizedBox(width: AppConstants.spacingSm),
            ],
            Expanded(
              child: AppButton(
                label: ctaLabel,
                trailingIcon: Icons.arrow_forward,
                variant: AppButtonVariant.gradient,
                isLoading: controller.isSubmitting.value,
                onPressed: controller.canProceed
                    ? (isLast ? controller.submit : controller.nextStep)
                    : null,
              ),
            ),
          ],
        ),
      );
    });
  }
}
