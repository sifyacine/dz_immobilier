import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../app/constants/app_constants.dart';
import '../../../../app/theme/app_colors.dart';
import '../../../../app/theme/app_gradients.dart';
import '../../../../app/theme/app_text_styles.dart';
import '../../../../data/models/valuation_category_model.dart';
import '../../controllers/estimation_controller.dart';
import '../widgets/step_field_label.dart';
import '../widgets/step_hint_box.dart';
import '../widgets/step_title.dart';

class Step2PropertyType extends GetView<EstimationController> {
  const Step2PropertyType({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const StepTitle(
          prefix: 'Quel type de',
          accent: 'bien souhaitez-vous estimer ?',
        ),
        const SizedBox(height: AppConstants.spacingMd),
        const StepHintBox(
          text: "Les segments LPP/AADL et le marché libre n'ont pas le même "
              'prix au m². Le type définit la grille de référence.',
        ),
        const SizedBox(height: AppConstants.spacingLg),

        // ── Level 1: Transaction type ───────────────────────────────────
        const StepFieldLabel(label: 'TYPE DE TRANSACTION', required: true),
        const SizedBox(height: AppConstants.spacingSm),
        Obx(() {
          if (controller.isLoadingCategories.value) {
            return const _LoadingRow();
          }
          if (controller.transactionTypes.isEmpty) {
            return Text(
              'Impossible de charger les types de transaction.',
              style: AppTextStyles.caption
                  .copyWith(color: AppColors.textSecondary),
            );
          }
          final selected = controller.selectedTransaction.value;
          return Row(
            children: controller.transactionTypes.asMap().entries.map((e) {
              final tx = e.value;
              return Expanded(
                child: Padding(
                  padding: EdgeInsets.only(
                    right: e.key < controller.transactionTypes.length - 1
                        ? AppConstants.spacingXs
                        : 0,
                  ),
                  child: _CategoryTile(
                    label: tx.name,
                    selected: selected?.id == tx.id,
                    onTap: () => controller.selectTransaction(tx),
                  ),
                ),
              );
            }).toList(),
          );
        }),

        // ── Level 2: Property type ──────────────────────────────────────
        Obx(() {
          if (controller.selectedTransaction.value == null) {
            return const SizedBox.shrink();
          }
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: AppConstants.spacingMd),
              const StepFieldLabel(label: 'TYPE DE BIEN', required: true),
              const SizedBox(height: AppConstants.spacingSm),
              if (controller.isLoadingPropertyCategories.value)
                const _LoadingBox()
              else if (controller.propertyCategories.isEmpty)
                Text(
                  'Aucun type disponible pour cette transaction.',
                  style: AppTextStyles.caption
                      .copyWith(color: AppColors.textSecondary),
                )
              else
                Obx(() {
                  final selected = controller.selectedPropertyCategory.value;
                  return GridView.count(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    crossAxisCount: 3,
                    crossAxisSpacing: AppConstants.spacingXs,
                    mainAxisSpacing: AppConstants.spacingXs,
                    childAspectRatio: 2.2,
                    children: controller.propertyCategories.map((cat) {
                      return _PropertyTile(
                        category: cat,
                        selected: selected?.id == cat.id,
                        onTap: () => controller.selectPropertyCategory(cat),
                      );
                    }).toList(),
                  );
                }),
            ],
          );
        }),

        // ── Level 3: Sub-type (optional refinement) ─────────────────────
        Obx(() {
          if (controller.selectedPropertyCategory.value == null) {
            return const SizedBox.shrink();
          }
          if (controller.isLoadingSubCategories.value) {
            return const Padding(
              padding: EdgeInsets.only(top: AppConstants.spacingMd),
              child: _LoadingBox(),
            );
          }
          if (controller.subCategories.isEmpty) {
            return const SizedBox.shrink();
          }
          final selected = controller.selectedSubCategory.value;
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: AppConstants.spacingMd),
              Row(
                children: [
                  const Icon(Icons.subdirectory_arrow_right,
                      size: 16, color: AppColors.primary),
                  const SizedBox(width: 6),
                  Text(
                    'PRÉCISER LE SOUS-TYPE',
                    style: AppTextStyles.caption.copyWith(
                      color: AppColors.primary,
                      fontWeight: FontWeight.w700,
                      letterSpacing: 0.8,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: AppConstants.spacingSm),
              GridView.count(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                crossAxisCount: 2,
                crossAxisSpacing: AppConstants.spacingXs,
                mainAxisSpacing: AppConstants.spacingXs,
                childAspectRatio: 3.0,
                children: controller.subCategories.map((sub) {
                  return _PropertyTile(
                    category: sub,
                    selected: selected?.id == sub.id,
                    onTap: () => controller.selectSubCategory(sub),
                  );
                }).toList(),
              ),
            ],
          );
        }),

        const SizedBox(height: AppConstants.spacingMd),
      ],
    );
  }
}

// ── Transaction type tile ─────────────────────────────────────────────────────

class _CategoryTile extends StatelessWidget {
  final String label;
  final bool selected;
  final VoidCallback onTap;

  const _CategoryTile(
      {required this.label, required this.selected, required this.onTap});

  @override
  Widget build(BuildContext context) {
    const shape = RoundedRectangleBorder(
        borderRadius:
            BorderRadius.all(Radius.circular(AppConstants.radiusMd)));
    return Material(
      color: Colors.transparent,
      shape: shape,
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onTap,
        child: AnimatedContainer(
          duration: AppConstants.animationDuration,
          padding: const EdgeInsets.symmetric(vertical: 14),
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
                        offset: const Offset(0, 4))
                  ]
                : null,
          ),
          child: Stack(
            alignment: Alignment.center,
            children: [
              Text(
                label,
                textAlign: TextAlign.center,
                style: AppTextStyles.body.copyWith(
                  fontWeight: FontWeight.w600,
                  color: selected ? Colors.white : AppColors.textPrimary,
                ),
              ),
              if (selected)
                const Positioned(
                  top: 0,
                  right: 8,
                  child: Icon(Icons.check, size: 14, color: Colors.white),
                ),
            ],
          ),
        ),
      ),
    );
  }
}

// ── Property / sub-type tile ──────────────────────────────────────────────────

class _PropertyTile extends StatelessWidget {
  final ValuationCategory category;
  final bool selected;
  final VoidCallback onTap;

  const _PropertyTile(
      {required this.category, required this.selected, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      borderRadius: BorderRadius.circular(AppConstants.radiusSm),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onTap,
        child: AnimatedContainer(
          duration: AppConstants.animationDuration,
          alignment: Alignment.center,
          padding: const EdgeInsets.symmetric(horizontal: 6),
          decoration: BoxDecoration(
            color: selected ? AppColors.violetSurface : AppColors.surface,
            borderRadius: BorderRadius.circular(AppConstants.radiusSm),
            border: Border.all(
              color: selected ? AppColors.primary : AppColors.border,
              width: selected ? 1.5 : 1,
            ),
          ),
          child: Text(
            category.name,
            textAlign: TextAlign.center,
            style: AppTextStyles.caption.copyWith(
              color: selected ? AppColors.primary : AppColors.textSecondary,
              fontWeight: selected ? FontWeight.w700 : FontWeight.normal,
            ),
          ),
        ),
      ),
    );
  }
}

// ── Loading helpers ───────────────────────────────────────────────────────────

class _LoadingRow extends StatelessWidget {
  const _LoadingRow();
  @override
  Widget build(BuildContext context) => const SizedBox(
        height: 52,
        child: Center(
          child: SizedBox(
            width: 20, height: 20,
            child: CircularProgressIndicator(strokeWidth: 2),
          ),
        ),
      );
}

class _LoadingBox extends StatelessWidget {
  const _LoadingBox();
  @override
  Widget build(BuildContext context) => Container(
        height: 80,
        alignment: Alignment.center,
        child: const SizedBox(
          width: 20, height: 20,
          child: CircularProgressIndicator(strokeWidth: 2),
        ),
      );
}
