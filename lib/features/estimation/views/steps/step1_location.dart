import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../app/constants/app_constants.dart';
import '../../../../app/theme/app_colors.dart';
import '../../../../app/theme/app_text_styles.dart';
import '../../../../data/models/commune_model.dart';
import '../../../../data/models/wilaya_model.dart';
import '../../controllers/estimation_controller.dart';
import '../widgets/step_field_label.dart';
import '../widgets/step_hint_box.dart';
import '../widgets/step_title.dart';

class Step1Location extends GetView<EstimationController> {
  const Step1Location({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const StepTitle(
          prefix: 'Où se trouve',
          accent: 'votre bien ?',
        ),
        const SizedBox(height: AppConstants.spacingMd),
        const StepHintBox(
          text: 'La wilaya et la commune sont les deux paramètres '
              'les plus importants pour le prix au m².',
        ),
        const SizedBox(height: AppConstants.spacingLg),

        // ── Wilaya ───────────────────────────────────────────────────────
        const StepFieldLabel(label: 'WILAYA', required: true),
        const SizedBox(height: AppConstants.spacingSm),
        Obx(() => _PickerField(
              value: controller.selectedWilaya.value?.display,
              hint: 'Sélectionnez une wilaya...',
              icon: Icons.near_me,
              onTap: () => _showWilayaPicker(context),
            )),

        // ── Commune (appears after wilaya is chosen) ──────────────────
        Obx(() {
          if (controller.selectedWilaya.value == null) {
            return const SizedBox.shrink();
          }
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: AppConstants.spacingMd),
              const StepFieldLabel(label: 'COMMUNE', required: false),
              const SizedBox(height: AppConstants.spacingSm),
              Obx(() {
                if (controller.isLoadingCommunes.value) {
                  return Container(
                    height: 52,
                    decoration: BoxDecoration(
                      color: AppColors.surface,
                      borderRadius:
                          BorderRadius.circular(AppConstants.radiusSm),
                      border: Border.all(color: AppColors.border),
                    ),
                    child: const Center(
                      child: SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      ),
                    ),
                  );
                }
                if (controller.communesError.value.isNotEmpty) {
                  return GestureDetector(
                    onTap: () {
                      final w = controller.selectedWilaya.value;
                      if (w != null) controller.loadCommunes(w);
                    },
                    child: Container(
                      height: 52,
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      decoration: BoxDecoration(
                        color: AppColors.surface,
                        borderRadius:
                            BorderRadius.circular(AppConstants.radiusSm),
                        border: Border.all(color: AppColors.border),
                      ),
                      child: Row(
                        children: [
                          const Icon(Icons.refresh, size: 18,
                              color: AppColors.primary),
                          const SizedBox(width: 8),
                          Text('Réessayer de charger les communes',
                              style: AppTextStyles.body
                                  .copyWith(color: AppColors.primary)),
                        ],
                      ),
                    ),
                  );
                }
                if (controller.communes.isEmpty) {
                  return Padding(
                    padding: const EdgeInsets.only(top: 4),
                    child: Text(
                      'Aucune commune disponible — utilisez le champ Quartier ci-dessous.',
                      style: AppTextStyles.caption
                          .copyWith(color: AppColors.textSecondary),
                    ),
                  );
                }
                return _PickerField(
                  value: controller.selectedCommune.value?.name,
                  hint: 'Sélectionnez une commune...',
                  icon: Icons.location_city_outlined,
                  onTap: () => _showCommunePicker(context),
                );
              }),
            ],
          );
        }),

        const SizedBox(height: AppConstants.spacingMd),

        // ── Neighbourhood (always visible) ────────────────────────────
        const StepFieldLabel(label: 'QUARTIER OU CITÉ', required: false),
        const SizedBox(height: AppConstants.spacingSm),
        TextFormField(
          controller: controller.neighborhoodCtrl,
          style: AppTextStyles.body,
          decoration: const InputDecoration(
            hintText: 'Ex : Hydra, Bab Ezzouar, Cité 3000...',
          ),
        ),
        const SizedBox(height: AppConstants.spacingMd),
      ],
    );
  }

  // ── Wilaya bottom-sheet picker ──────────────────────────────────────────

  void _showWilayaPicker(BuildContext context) {
    final search = ''.obs;
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: AppColors.surface,
      shape: const RoundedRectangleBorder(
        borderRadius:
            BorderRadius.vertical(top: Radius.circular(AppConstants.radiusLg)),
      ),
      builder: (_) => _SearchablePickerSheet(
        title: 'Choisir une wilaya',
        searchHint: 'Rechercher une wilaya...',
        searchObs: search,
        listBuilder: (scrollCtrl) => Obx(() {
          if (controller.isLoadingWilayas.value) {
            return const Center(child: CircularProgressIndicator());
          }
          if (controller.wilayasError.value.isNotEmpty &&
              controller.wilayas.isEmpty) {
            return Center(
              child: Text(
                'Impossible de charger les wilayas.',
                style: AppTextStyles.body
                    .copyWith(color: AppColors.textSecondary),
                textAlign: TextAlign.center,
              ),
            );
          }
          final currentWilaya = controller.selectedWilaya.value;
          final filtered = controller.wilayas
              .where((w) =>
                  w.name.toLowerCase().contains(search.value) ||
                  w.code.contains(search.value))
              .toList();

          return ListView.builder(
            controller: scrollCtrl,
            itemCount: filtered.length,
            itemBuilder: (_, i) {
              final w = filtered[i];
              final selected = currentWilaya?.id == w.id;
              return _WilayaListTile(
                wilaya: w,
                selected: selected,
                onTap: () {
                  controller.selectedWilaya.value = w;
                  controller.loadCommunes(w);
                  Get.back();
                },
              );
            },
          );
        }),
      ),
    );
  }

  // ── Commune bottom-sheet picker ─────────────────────────────────────────

  void _showCommunePicker(BuildContext context) {
    final search = ''.obs;
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: AppColors.surface,
      shape: const RoundedRectangleBorder(
        borderRadius:
            BorderRadius.vertical(top: Radius.circular(AppConstants.radiusLg)),
      ),
      builder: (_) => _SearchablePickerSheet(
        title: 'Choisir une commune',
        searchHint: 'Rechercher une commune...',
        searchObs: search,
        listBuilder: (scrollCtrl) => Obx(() {
          final currentCommune = controller.selectedCommune.value;
          final filtered = controller.communes
              .where((c) => c.name.toLowerCase().contains(search.value))
              .toList();

          return ListView.builder(
            controller: scrollCtrl,
            itemCount: filtered.length,
            itemBuilder: (_, i) {
              final c = filtered[i];
              final selected = currentCommune?.id == c.id;
              return _CommuneListTile(
                commune: c,
                selected: selected,
                onTap: () {
                  controller.selectedCommune.value = c;
                  Get.back();
                },
              );
            },
          );
        }),
      ),
    );
  }
}

// ── Reusable picker field ─────────────────────────────────────────────────────

class _PickerField extends StatelessWidget {
  final String? value;
  final String hint;
  final IconData icon;
  final VoidCallback onTap;

  const _PickerField({
    required this.hint,
    required this.icon,
    required this.onTap,
    this.value,
  });

  @override
  Widget build(BuildContext context) {
    final hasValue = value != null;
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(AppConstants.radiusSm),
      child: Container(
        height: 52,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(AppConstants.radiusSm),
          border: Border.all(
            color: hasValue ? AppColors.primary : AppColors.border,
            width: hasValue ? 1.5 : 1,
          ),
        ),
        child: Row(
          children: [
            Expanded(
              child: Text(
                value ?? hint,
                style: AppTextStyles.body.copyWith(
                  color: hasValue ? AppColors.textPrimary : AppColors.textHint,
                ),
              ),
            ),
            Container(
              width: 36,
              height: 36,
              decoration: BoxDecoration(
                color: hasValue ? AppColors.primary : AppColors.violetSurface,
                shape: BoxShape.circle,
              ),
              child: Icon(
                icon,
                size: 18,
                color: hasValue ? Colors.white : AppColors.primary,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ── Reusable bottom-sheet shell ───────────────────────────────────────────────

class _SearchablePickerSheet extends StatelessWidget {
  final String title;
  final String searchHint;
  final RxString searchObs;
  final Widget Function(ScrollController) listBuilder;

  const _SearchablePickerSheet({
    required this.title,
    required this.searchHint,
    required this.searchObs,
    required this.listBuilder,
  });

  @override
  Widget build(BuildContext context) {
    return DraggableScrollableSheet(
      expand: false,
      initialChildSize: 0.75,
      maxChildSize: 0.92,
      builder: (_, scrollCtrl) => Column(
        children: [
          // Drag handle
          Container(
            margin: const EdgeInsets.symmetric(vertical: 10),
            width: 40,
            height: 4,
            decoration: BoxDecoration(
              color: AppColors.border,
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          // Title
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 8),
            child: Text(title,
                style: AppTextStyles.h3),
          ),
          // Search field
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 12),
            child: TextField(
              autofocus: true,
              decoration: InputDecoration(
                hintText: searchHint,
                prefixIcon: const Icon(Icons.search, size: 20),
              ),
              onChanged: (v) => searchObs.value = v.toLowerCase(),
            ),
          ),
          Expanded(child: listBuilder(scrollCtrl)),
        ],
      ),
    );
  }
}

// ── List tile widgets ─────────────────────────────────────────────────────────

class _WilayaListTile extends StatelessWidget {
  final Wilaya wilaya;
  final bool selected;
  final VoidCallback onTap;

  const _WilayaListTile(
      {required this.wilaya, required this.selected, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Container(
        width: 36,
        height: 36,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: selected ? AppColors.primary : AppColors.violetSurface,
          shape: BoxShape.circle,
        ),
        child: Text(
          wilaya.code,
          style: AppTextStyles.caption.copyWith(
            color: selected ? Colors.white : AppColors.primary,
            fontWeight: FontWeight.w700,
          ),
        ),
      ),
      title: Text(
        wilaya.name,
        style: AppTextStyles.body.copyWith(
            fontWeight: selected ? FontWeight.w700 : FontWeight.normal),
      ),
      trailing: selected
          ? const Icon(Icons.check_circle, color: AppColors.primary)
          : null,
      onTap: onTap,
    );
  }
}

class _CommuneListTile extends StatelessWidget {
  final Commune commune;
  final bool selected;
  final VoidCallback onTap;

  const _CommuneListTile(
      {required this.commune, required this.selected, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Container(
        width: 36,
        height: 36,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: selected ? AppColors.primary : AppColors.violetSurface,
          borderRadius: BorderRadius.circular(AppConstants.radiusXs),
        ),
        child: Icon(
          Icons.location_on_outlined,
          size: 18,
          color: selected ? Colors.white : AppColors.primary,
        ),
      ),
      title: Text(
        commune.name,
        style: AppTextStyles.body.copyWith(
            fontWeight: selected ? FontWeight.w700 : FontWeight.normal),
      ),
      trailing: selected
          ? const Icon(Icons.check_circle, color: AppColors.primary)
          : null,
      onTap: onTap,
    );
  }
}
