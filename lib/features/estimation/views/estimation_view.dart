import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../app/constants/app_constants.dart';
import '../../../app/theme/app_colors.dart';
import '../../../app/theme/app_gradients.dart';
import '../../../app/theme/app_text_styles.dart';
import '../../../shared/widgets/app_button.dart';
import '../../../shared/widgets/app_progress_bar.dart';
import '../controllers/estimation_controller.dart';
import 'steps/step1_location.dart';
import 'steps/step2_property_type.dart';
import 'steps/step3_surface.dart';
import 'steps/step4_highlights.dart';
import 'steps/step5_contact.dart';

class EstimationView extends GetView<EstimationController> {
  const EstimationView({super.key});

  static const _stepLabels = [
    'ÉTAPE 1 · LOCALISATION',
    'ÉTAPE 2 · TYPE DE BIEN',
    'ÉTAPE 3 · SURFACE',
    'ÉTAPE 4 · POINTS FORTS',
    'DERNIÈRE ÉTAPE · CONTACT',
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: Column(
        children: [
          _Header(controller: controller),
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
                  // ── Step progress ──────────────────────────────────────
                  Obx(() => Padding(
                        padding: const EdgeInsets.fromLTRB(
                          AppConstants.spacingMd,
                          AppConstants.spacingMd,
                          AppConstants.spacingMd,
                          AppConstants.spacingSm,
                        ),
                        child: AppProgressBar(
                          value: controller.progress,
                          label: 'Étape ${controller.currentStep.value + 1} / ${EstimationController.totalSteps}',
                        ),
                      )),

                  // ── Step badge ─────────────────────────────────────────
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
                              _stepLabels[controller.currentStep.value],
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

                  // ── Step content (scrollable) ──────────────────────────
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

                  // ── Navigation ─────────────────────────────────────────
                  _NavButtons(controller: controller),
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
      case 0: return const Step1Location();
      case 1: return const Step2PropertyType();
      case 2: return const Step3Surface();
      case 3: return const Step4Highlights();
      case 4: return const Step5Contact();
      default: return const SizedBox();
    }
  }
}

// ── Gradient header ──────────────────────────────────────────────────────────

class _Header extends StatelessWidget {
  final EstimationController controller;
  const _Header({required this.controller});

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
          // Back / close
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
                  '🚀  Estimer en 30 secondes',
                  style: AppTextStyles.title
                      .copyWith(color: Colors.white, fontWeight: FontWeight.w700),
                ),
                const SizedBox(height: 2),
                Text(
                  'Réponse instantanée en 4 questions',
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
                      'Recommencer',
                      style: AppTextStyles.caption.copyWith(
                        color: AppColors.primary,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(width: 4),
                    Icon(Icons.arrow_forward,
                        size: 14, color: AppColors.primary),
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

// ── Navigation buttons ───────────────────────────────────────────────────────

class _NavButtons extends StatelessWidget {
  final EstimationController controller;
  const _NavButtons({required this.controller});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final step = controller.currentStep.value;
      final isLast = step == EstimationController.totalSteps - 1;

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
                label: 'Retour',
                icon: Icons.arrow_back,
                variant: AppButtonVariant.ghost,
                expanded: false,
                onPressed: controller.prevStep,
              ),
              const SizedBox(width: AppConstants.spacingSm),
            ],
            Expanded(
              child: AppButton(
                label: isLast ? 'Voir mon estimation' : 'Suivant',
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
