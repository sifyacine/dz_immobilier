import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../app/constants/app_constants.dart';
import '../../../../app/theme/app_colors.dart';
import '../../../../app/theme/app_gradients.dart';
import '../../../../app/theme/app_text_styles.dart';
import '../../../../data/models/simulation_category_model.dart';
import '../../../../shared/extensions/l10n_extension.dart';
import '../../../estimation/views/widgets/step_field_label.dart';
import '../../../estimation/views/widgets/step_title.dart';
import '../../controllers/simulation_controller.dart';

class Step1PropertyType extends GetView<SimulationController> {
  const Step1PropertyType({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        StepTitle(
            prefix: context.l10n.simStep1Prefix,
            accent: context.l10n.simStep1Accent),
        const SizedBox(height: AppConstants.spacingMd),

        // ── Property type grid ──────────────────────────────────────────
        StepFieldLabel(
            label: context.l10n.simSelectPropertyType, required: true),
        const SizedBox(height: AppConstants.spacingSm),

        Obx(() {
          if (controller.isLoadingCategories.value) {
            return const SizedBox(
              height: 120,
              child: Center(
                child: SizedBox(
                  width: 24,
                  height: 24,
                  child: CircularProgressIndicator(strokeWidth: 2),
                ),
              ),
            );
          }
          if (controller.categoriesError.value.isNotEmpty) {
            return Padding(
              padding:
                  const EdgeInsets.symmetric(vertical: AppConstants.spacingMd),
              child: Text(
                'Impossible de charger les types de bien.',
                style:
                    AppTextStyles.caption.copyWith(color: AppColors.error),
              ),
            );
          }
          final cats = controller.categories;
          final selected = controller.selectedCategoryIds;
          // Responsive: fits as many ~118px columns as the width allows
          // (3 per row on phones, more on wider screens / tablets).
          return GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
              maxCrossAxisExtent: 118,
              crossAxisSpacing: AppConstants.spacingSm,
              mainAxisSpacing: AppConstants.spacingSm,
              childAspectRatio: 0.9,
            ),
            itemCount: cats.length,
            itemBuilder: (_, i) {
              final cat = cats[i];
              return _PropertyTypeTile(
                category: cat,
                selected: selected.contains(cat.id),
                onTap: () => controller.toggleCategory(cat.id),
              );
            },
          );
        }),

        const SizedBox(height: AppConstants.spacingMd),

        // ── DZ-Immobilier info box ──────────────────────────────────────
        Container(
          padding: const EdgeInsets.all(AppConstants.spacingMd),
          decoration: BoxDecoration(
            color: AppColors.violetSurface,
            borderRadius: BorderRadius.circular(AppConstants.radiusMd),
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: const EdgeInsets.all(6),
                decoration: const BoxDecoration(
                  color: AppColors.primary,
                  shape: BoxShape.circle,
                ),
                child:
                    const Icon(Icons.bolt, size: 14, color: Colors.white),
              ),
              const SizedBox(width: AppConstants.spacingSm),
              Expanded(
                child: RichText(
                  text: TextSpan(
                    style: AppTextStyles.caption
                        .copyWith(color: AppColors.textSecondary),
                    children: [
                      TextSpan(
                        text: 'DZ-Immobilier ',
                        style: AppTextStyles.caption.copyWith(
                          color: AppColors.textPrimary,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      TextSpan(text: context.l10n.simInfoAnalysisBody),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),

        const SizedBox(height: AppConstants.spacingMd),

        // ── State subsidy toggle ────────────────────────────────────────
        Container(
          padding: const EdgeInsets.all(AppConstants.spacingMd),
          decoration: BoxDecoration(
            color: AppColors.background,
            borderRadius: BorderRadius.circular(AppConstants.radiusMd),
            border: Border.all(color: AppColors.border),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  const Icon(Icons.info_outline,
                      size: 16, color: AppColors.primary),
                  const SizedBox(width: 6),
                  Text(
                    context.l10n.simStateProgramQuestion,
                    style: AppTextStyles.body
                        .copyWith(fontWeight: FontWeight.w600),
                  ),
                ],
              ),
              const SizedBox(height: AppConstants.spacingSm),
              Obx(() {
                final isSubsidized = controller.isStateSubsidized.value;
                return Row(
                  children: [
                    Expanded(
                      child: _SubsidyToggle(
                        label: context.l10n.simStateYes,
                        selected: isSubsidized,
                        onTap: () =>
                            controller.isStateSubsidized.value = true,
                      ),
                    ),
                    const SizedBox(width: AppConstants.spacingSm),
                    Expanded(
                      child: _SubsidyToggle(
                        label: context.l10n.simStateNo,
                        selected: !isSubsidized,
                        onTap: () =>
                            controller.isStateSubsidized.value = false,
                      ),
                    ),
                  ],
                );
              }),
              const SizedBox(height: AppConstants.spacingXs),
              Text(
                context.l10n.simStateNote,
                style: AppTextStyles.caption
                    .copyWith(color: AppColors.textHint),
              ),
            ],
          ),
        ),

        const SizedBox(height: AppConstants.spacingMd),
      ],
    );
  }
}

// ── Property type tile ────────────────────────────────────────────────────────

class _PropertyTypeTile extends StatelessWidget {
  final SimulationCategory category;
  final bool selected;
  final VoidCallback onTap;

  const _PropertyTypeTile({
    required this.category,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    const shape = RoundedRectangleBorder(
      borderRadius: BorderRadius.all(Radius.circular(AppConstants.radiusMd)),
    );
    return Material(
      color: Colors.transparent,
      shape: shape,
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onTap,
        child: AnimatedContainer(
          duration: AppConstants.animationDuration,
          decoration: ShapeDecoration(
            shape: shape,
            gradient: selected
                ? AppGradients.purpleFade
                : const LinearGradient(
                    colors: [AppColors.surface, AppColors.surface]),
            shadows: selected
                ? [
                    BoxShadow(
                      color: AppColors.primary.withValues(alpha: 0.25),
                      blurRadius: 10,
                      offset: const Offset(0, 4),
                    )
                  ]
                : null,
          ),
          child: Stack(
            children: [
              Padding(
                padding: const EdgeInsets.all(6),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      padding: const EdgeInsets.all(9),
                      decoration: BoxDecoration(
                        color: selected
                            ? Colors.white.withValues(alpha: 0.20)
                            : AppColors.violetSurface,
                        borderRadius:
                            BorderRadius.circular(AppConstants.radiusSm),
                      ),
                      child: Icon(
                        category.icon,
                        size: 24,
                        color:
                            selected ? Colors.white : AppColors.primary,
                      ),
                    ),
                    const SizedBox(height: 7),
                    Text(
                      category.name,
                      textAlign: TextAlign.center,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: AppTextStyles.caption.copyWith(
                        fontSize: 11,
                        color: selected
                            ? Colors.white
                            : AppColors.textPrimary,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
              if (selected)
                Positioned(
                  top: 4,
                  right: 4,
                  child: Container(
                    padding: const EdgeInsets.all(2),
                    decoration: const BoxDecoration(
                      color: Colors.white,
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      Icons.check,
                      size: 9,
                      color: AppColors.primary,
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}

// ── Subsidy toggle ────────────────────────────────────────────────────────────

class _SubsidyToggle extends StatelessWidget {
  final String label;
  final bool selected;
  final VoidCallback onTap;

  const _SubsidyToggle({
    required this.label,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding:
            const EdgeInsets.symmetric(vertical: 14, horizontal: 8),
        decoration: BoxDecoration(
          gradient: selected ? AppGradients.purpleFade : null,
          borderRadius: BorderRadius.circular(AppConstants.radiusPill),
          border: selected
              ? null
              : Border.all(color: AppColors.primary, width: 1.5),
        ),
        child: Center(
          child: Text(
            label,
            textAlign: TextAlign.center,
            style: AppTextStyles.caption.copyWith(
              color: selected ? Colors.white : AppColors.primary,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ),
    );
  }
}
