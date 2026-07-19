import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../app/constants/app_constants.dart';
import '../../../../app/theme/app_colors.dart';
import '../../../../app/theme/app_text_styles.dart';
import '../../../../data/models/form_schema_model.dart';
import '../../controllers/estimation_controller.dart';
import '../widgets/step_hint_box.dart';
import '../widgets/step_title.dart';

class Step4Highlights extends GetView<EstimationController> {
  const Step4Highlights({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const StepTitle(
          prefix: 'Précisez les',
          accent: 'points forts du bien.',
        ),
        const SizedBox(height: AppConstants.spacingMd),
        const StepHintBox(
          text: 'Plus vous renseignez de critères, plus l\'estimation sera '
              'précise. Chaque point fort est valorisé par son impact sur le marché.',
        ),
        const SizedBox(height: AppConstants.spacingMd),
        Obx(() {
          if (controller.isLoadingSchema.value) {
            return const _SchemaLoading();
          }
          if (controller.schemaError.value.isNotEmpty) {
            return Text(
              controller.schemaError.value,
              style: AppTextStyles.caption.copyWith(color: AppColors.error),
            );
          }
          if (controller.formSchema.isEmpty) {
            return Padding(
              padding:
                  const EdgeInsets.symmetric(vertical: AppConstants.spacingLg),
              child: Text(
                'Aucun critère disponible pour ce type de bien.',
                style: AppTextStyles.body
                    .copyWith(color: AppColors.textSecondary),
              ),
            );
          }
          return Column(
            children: controller.formSchema
                .map((s) => _SectionAccordion(section: s))
                .toList(),
          );
        }),
        const SizedBox(height: AppConstants.spacingMd),
      ],
    );
  }
}

// ── Section accordion ─────────────────────────────────────────────────────────

class _SectionAccordion extends GetView<EstimationController> {
  final FormSchemaSection section;
  const _SectionAccordion({required this.section});

  @override
  Widget build(BuildContext context) {
    final expanded = false.obs;
    return Obx(() {
      final count = controller.sectionSelectedCount(section);
      final isExpanded = expanded.value;
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ── Header ────────────────────────────────────────────────────
          InkWell(
            onTap: () => expanded.value = !expanded.value,
            borderRadius: BorderRadius.circular(AppConstants.radiusSm),
            child: Container(
              padding: const EdgeInsets.symmetric(
                  horizontal: AppConstants.spacingMd, vertical: 14),
              decoration: BoxDecoration(
                color: AppColors.surface,
                borderRadius: BorderRadius.circular(AppConstants.radiusSm),
                border: Border.all(color: AppColors.border),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: Text(section.label, style: AppTextStyles.title),
                  ),
                  if (count > 0) ...[
                    Container(
                      width: 26,
                      height: 26,
                      alignment: Alignment.center,
                      decoration: const BoxDecoration(
                        color: AppColors.primary,
                        shape: BoxShape.circle,
                      ),
                      child: Text(
                        '$count',
                        style: AppTextStyles.caption.copyWith(
                          color: Colors.white,
                          fontWeight: FontWeight.w700,
                          fontSize: 11,
                        ),
                      ),
                    ),
                    const SizedBox(width: AppConstants.spacingSm),
                  ],
                  Icon(
                    isExpanded
                        ? Icons.keyboard_arrow_up
                        : Icons.keyboard_arrow_down,
                    color: AppColors.textHint,
                  ),
                ],
              ),
            ),
          ),
          // ── Body ──────────────────────────────────────────────────────
          if (isExpanded)
            Container(
              margin: const EdgeInsets.only(top: 2),
              decoration: BoxDecoration(
                color: AppColors.background,
                borderRadius: BorderRadius.circular(AppConstants.radiusSm),
                border: Border.all(color: AppColors.border),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: section.attributes
                    .map((attr) => _AttributeBlock(attr: attr))
                    .toList(),
              ),
            ),
          const SizedBox(height: AppConstants.spacingXs),
        ],
      );
    });
  }
}

// ── Attribute block ───────────────────────────────────────────────────────────

class _AttributeBlock extends GetView<EstimationController> {
  final FormSchemaAttribute attr;
  const _AttributeBlock({required this.attr});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: AppConstants.spacingMd,
        vertical: AppConstants.spacingSm,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (attr.name.isNotEmpty) ...[
            Text(
              attr.name,
              style: AppTextStyles.caption.copyWith(
                color: AppColors.textSecondary,
                fontWeight: FontWeight.w600,
                letterSpacing: 0.4,
              ),
            ),
            const SizedBox(height: AppConstants.spacingXs),
          ],
          if (attr.displayType == 'radio_square')
            _RadioSquareValues(attr: attr)
          else if (attr.isMulti)
            _MultiValues(attr: attr)
          else
            _RadioValues(attr: attr),
        ],
      ),
    );
  }
}

// ── Multi-select (checkboxes) ─────────────────────────────────────────────────

class _MultiValues extends GetView<EstimationController> {
  final FormSchemaAttribute attr;
  const _MultiValues({required this.attr});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: attr.values.map((val) {
        return Obx(() {
          final selected =
              (controller.selectedValueIds[attr.attributeId] ?? [])
                  .contains(val.id);
          return CheckboxListTile(
            dense: true,
            contentPadding: EdgeInsets.zero,
            value: selected,
            activeColor: AppColors.primary,
            title: Row(
              children: [
                Expanded(
                    child: Text(val.name, style: AppTextStyles.body)),
                if (attr.showImpact && val.impactPct != 0)
                  _ImpactBadge(pct: val.impactPct),
              ],
            ),
            onChanged: (_) => controller.toggleAttributeValue(
              attr.attributeId, val.id,
              isMulti: true,
            ),
          );
        });
      }).toList(),
    );
  }
}

// ── Radio (chip pills, single-select) ────────────────────────────────────────

class _RadioValues extends GetView<EstimationController> {
  final FormSchemaAttribute attr;
  const _RadioValues({required this.attr});

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: AppConstants.spacingXs,
      runSpacing: AppConstants.spacingXs,
      children: attr.values.map((val) {
        return Obx(() {
          final selected =
              (controller.selectedValueIds[attr.attributeId] ?? [])
                  .contains(val.id);
          return GestureDetector(
            onTap: () => controller.toggleAttributeValue(
              attr.attributeId, val.id,
              isMulti: false,
            ),
            child: AnimatedContainer(
              duration: AppConstants.animationDuration,
              padding:
                  const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
              decoration: BoxDecoration(
                color: selected ? AppColors.violetSurface : AppColors.surface,
                borderRadius:
                    BorderRadius.circular(AppConstants.radiusPill),
                border: Border.all(
                  color: selected ? AppColors.primary : AppColors.border,
                  width: selected ? 1.5 : 1,
                ),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Flexible(
                    child: Text(
                      val.name,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: AppTextStyles.caption.copyWith(
                        color: selected
                            ? AppColors.primary
                            : AppColors.textSecondary,
                        fontWeight:
                            selected ? FontWeight.w700 : FontWeight.normal,
                      ),
                    ),
                  ),
                  if (attr.showImpact && val.impactPct != 0) ...[
                    const SizedBox(width: 6),
                    _ImpactBadge(pct: val.impactPct),
                  ],
                ],
              ),
            ),
          );
        });
      }).toList(),
    );
  }
}

// ── Radio square (grid tiles, single-select) ──────────────────────────────────

class _RadioSquareValues extends GetView<EstimationController> {
  final FormSchemaAttribute attr;
  const _RadioSquareValues({required this.attr});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final selectedList =
          controller.selectedValueIds[attr.attributeId] ?? [];
      return GridView.count(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        crossAxisCount: 2,
        crossAxisSpacing: AppConstants.spacingXs,
        mainAxisSpacing: AppConstants.spacingXs,
        childAspectRatio: 2.0,
        children: attr.values.map((val) {
          final selected = selectedList.contains(val.id);
          return GestureDetector(
            onTap: () => controller.toggleAttributeValue(
              attr.attributeId, val.id,
              isMulti: false,
            ),
            child: AnimatedContainer(
              duration: AppConstants.animationDuration,
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
              decoration: BoxDecoration(
                color: selected ? AppColors.violetSurface : AppColors.surface,
                borderRadius:
                    BorderRadius.circular(AppConstants.radiusSm),
                border: Border.all(
                  color: selected ? AppColors.primary : AppColors.border,
                  width: selected ? 1.5 : 1,
                ),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Flexible(
                    child: Text(
                      val.name,
                      textAlign: TextAlign.center,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: AppTextStyles.caption.copyWith(
                        color: selected
                            ? AppColors.primary
                            : AppColors.textSecondary,
                        fontWeight:
                            selected ? FontWeight.w700 : FontWeight.normal,
                      ),
                    ),
                  ),
                  if (attr.showImpact && val.impactPct != 0) ...[
                    const SizedBox(height: 2),
                    _ImpactBadge(pct: val.impactPct),
                  ],
                ],
              ),
            ),
          );
        }).toList(),
      );
    });
  }
}

// ── Shared helpers ────────────────────────────────────────────────────────────

class _ImpactBadge extends StatelessWidget {
  final double pct;
  const _ImpactBadge({required this.pct});

  @override
  Widget build(BuildContext context) {
    final positive = pct >= 0;
    final color = positive ? AppColors.success : AppColors.error;
    final bg = positive ? AppColors.successSurface : AppColors.errorSurface;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(AppConstants.radiusPill),
      ),
      child: Text(
        '${positive ? '+' : ''}${pct.toStringAsFixed(1)}%',
        style: AppTextStyles.caption.copyWith(
          color: color,
          fontWeight: FontWeight.w700,
          fontSize: 10,
        ),
      ),
    );
  }
}

class _SchemaLoading extends StatelessWidget {
  const _SchemaLoading();

  @override
  Widget build(BuildContext context) => const SizedBox(
        height: 80,
        child: Center(
          child: SizedBox(
            width: 24,
            height: 24,
            child: CircularProgressIndicator(strokeWidth: 2),
          ),
        ),
      );
}
