import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

import '../../../app/constants/app_constants.dart';
import '../../../app/theme/app_colors.dart';
import '../../../app/theme/app_gradients.dart';
import '../../../app/theme/app_text_styles.dart';
import '../../../shared/widgets/app_button.dart';
import '../../../shared/widgets/app_chip.dart';
import '../controllers/speed30_controller.dart';

/// "Estimer en 30 secondes" — single-screen quick estimate form.
class Speed30View extends GetView<Speed30Controller> {
  const Speed30View({super.key});

  static const _conditions = <(String, String)>[
    ('needs_renovation', 'À rénover'),
    ('good', 'Bon état'),
    ('new', 'Neuf'),
  ];

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Scaffold(
      backgroundColor: isDark ? AppColors.darkBackground : AppColors.background,
      body: SafeArea(
        child: Column(
          children: [
            _buildHeader(),
            const Divider(height: 1),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(AppConstants.spacingMd),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _label('Wilaya'),
                    _buildWilayaRow(context),
                    const SizedBox(height: AppConstants.spacingMd),

                    _label('Commune (optionnel)'),
                    _buildCommuneField(context),
                    const SizedBox(height: AppConstants.spacingMd),

                    _label('Type de transaction'),
                    _buildTransactions(),
                    const SizedBox(height: AppConstants.spacingMd),

                    _label('Surface (m²)'),
                    _buildSurface(),
                    const SizedBox(height: AppConstants.spacingMd),

                    _label('Type'),
                    _buildTypes(),
                    const SizedBox(height: AppConstants.spacingMd),

                    _label('État du bien'),
                    _buildConditions(),
                    const SizedBox(height: AppConstants.spacingLg),
                  ],
                ),
              ),
            ),
            _buildSubmitBar(),
          ],
        ),
      ),
    );
  }

  // ── Header ──────────────────────────────────────────────────────────────
  Widget _buildHeader() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(
          AppConstants.spacingSm, AppConstants.spacingSm,
          AppConstants.spacingMd, AppConstants.spacingSm),
      child: Row(
        children: [
          _CircleButton(icon: Icons.close, onTap: Get.back),
          const SizedBox(width: AppConstants.spacingSm),
          Expanded(
            child: Text('Estimer en 30 secondes', style: AppTextStyles.h3),
          ),
        ],
      ),
    );
  }

  // ── Wilaya ──────────────────────────────────────────────────────────────
  Widget _buildWilayaRow(BuildContext context) {
    return Row(
      children: [
        // Gradient launcher button (matches the website's purple button).
        Material(
          borderRadius: BorderRadius.circular(AppConstants.radiusMd),
          clipBehavior: Clip.antiAlias,
          child: InkWell(
            onTap: () => _showWilayaPicker(context),
            child: Container(
              width: 52,
              height: 52,
              decoration: const BoxDecoration(gradient: AppGradients.purpleFade),
              child: const Icon(Icons.near_me, color: Colors.white),
            ),
          ),
        ),
        const SizedBox(width: AppConstants.spacingSm),
        Expanded(
          child: Obx(() => _PickerField(
                value: controller.selectedWilaya.value?.display,
                hint: 'Wilaya…',
                onTap: () => _showWilayaPicker(context),
              )),
        ),
      ],
    );
  }

  Widget _buildCommuneField(BuildContext context) {
    return Obx(() {
      final hasWilaya = controller.selectedWilaya.value != null;
      return _PickerField(
        value: controller.selectedCommune.value?.name,
        hint: hasWilaya
            ? 'Plus précis avec la commune…'
            : 'Choisissez d’abord une wilaya',
        enabled: hasWilaya,
        loading: controller.isLoadingCommunes.value,
        onTap: () {
          if (!hasWilaya) return;
          _showCommunePicker(context);
        },
      );
    });
  }

  // ── Transaction ─────────────────────────────────────────────────────────
  Widget _buildTransactions() {
    return Obx(() {
      if (controller.isLoadingCategories.value) return const _MiniLoader();
      return Wrap(
        spacing: AppConstants.spacingSm,
        children: [
          for (final tx in controller.transactions)
            AppChip(
              label: tx.name,
              selected: controller.selectedTxId.value == tx.id,
              onTap: () => controller.selectTransaction(tx),
            ),
        ],
      );
    });
  }

  // ── Surface ─────────────────────────────────────────────────────────────
  Widget _buildSurface() {
    final border = OutlineInputBorder(
      borderRadius: BorderRadius.circular(AppConstants.radiusMd),
      borderSide: const BorderSide(color: AppColors.success, width: 1.4),
    );
    return TextFormField(
      controller: controller.surfaceCtrl,
      keyboardType: TextInputType.number,
      textAlign: TextAlign.center,
      style: AppTextStyles.h3,
      inputFormatters: [FilteringTextInputFormatter.digitsOnly],
      decoration: InputDecoration(
        filled: true,
        fillColor: AppColors.surface,
        contentPadding: const EdgeInsets.symmetric(vertical: 14),
        border: border,
        enabledBorder: border,
        focusedBorder: border,
      ),
    );
  }

  // ── Type ────────────────────────────────────────────────────────────────
  Widget _buildTypes() {
    return Obx(() {
      if (controller.isLoadingCategories.value) return const _MiniLoader();
      return Wrap(
        spacing: AppConstants.spacingSm,
        runSpacing: AppConstants.spacingSm,
        children: [
          for (final t in controller.currentTypes)
            AppChip(
              label: t.name,
              selected: controller.selectedTypeId.value == t.id,
              onTap: () => controller.selectType(t),
            ),
        ],
      );
    });
  }

  // ── Condition ───────────────────────────────────────────────────────────
  Widget _buildConditions() {
    return Obx(() => Wrap(
          spacing: AppConstants.spacingSm,
          runSpacing: AppConstants.spacingSm,
          children: [
            for (final c in _conditions)
              AppChip(
                label: c.$2,
                selected: controller.condition.value == c.$1,
                onTap: () => controller.condition.value = c.$1,
              ),
          ],
        ));
  }

  // ── Submit ──────────────────────────────────────────────────────────────
  Widget _buildSubmitBar() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(
          AppConstants.spacingMd, AppConstants.spacingSm,
          AppConstants.spacingMd, AppConstants.spacingMd),
      child: Obx(() => AppButton(
            label: 'Voir l’estimation',
            variant: AppButtonVariant.gradient,
            trailingIcon: Icons.arrow_forward,
            isLoading: controller.isSubmitting.value,
            onPressed: controller.canSubmit ? controller.submit : null,
          )),
    );
  }

  Widget _label(String text) => Padding(
        padding: const EdgeInsets.only(bottom: AppConstants.spacingSm),
        child: Text(text,
            style: AppTextStyles.title.copyWith(fontWeight: FontWeight.w700)),
      );

  // ── Pickers ─────────────────────────────────────────────────────────────
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
      builder: (_) => _PickerSheet(
        title: 'Choisir une wilaya',
        hint: 'Rechercher une wilaya…',
        search: search,
        listBuilder: (scroll) => Obx(() {
          if (controller.isLoadingWilayas.value) {
            return const Center(child: CircularProgressIndicator());
          }
          final q = search.value;
          final items = controller.wilayas
              .where((w) =>
                  w.name.toLowerCase().contains(q) || w.code.contains(q))
              .toList();
          return ListView.builder(
            controller: scroll,
            itemCount: items.length,
            itemBuilder: (_, i) {
              final w = items[i];
              final sel = controller.selectedWilaya.value?.id == w.id;
              return ListTile(
                leading: _Avatar(text: w.code, selected: sel),
                title: Text(w.name),
                trailing: sel
                    ? const Icon(Icons.check_circle, color: AppColors.primary)
                    : null,
                onTap: () {
                  controller.selectWilaya(w);
                  Get.back();
                },
              );
            },
          );
        }),
      ),
    );
  }

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
      builder: (_) => _PickerSheet(
        title: 'Choisir une commune',
        hint: 'Rechercher une commune…',
        search: search,
        listBuilder: (scroll) => Obx(() {
          if (controller.isLoadingCommunes.value) {
            return const Center(child: CircularProgressIndicator());
          }
          if (controller.communes.isEmpty) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(AppConstants.spacingLg),
                child: Text('Aucune commune disponible.',
                    style: AppTextStyles.bodySecondary),
              ),
            );
          }
          final items = controller.communes
              .where((c) => c.name.toLowerCase().contains(search.value))
              .toList();
          return ListView.builder(
            controller: scroll,
            itemCount: items.length,
            itemBuilder: (_, i) {
              final c = items[i];
              final sel = controller.selectedCommune.value?.id == c.id;
              return ListTile(
                leading: Icon(Icons.location_on_outlined,
                    color: sel ? AppColors.primary : AppColors.textHint),
                title: Text(c.name),
                trailing: sel
                    ? const Icon(Icons.check_circle, color: AppColors.primary)
                    : null,
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

// ── Private widgets ───────────────────────────────────────────────────────────

class _CircleButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback onTap;
  const _CircleButton({required this.icon, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Material(
      color: isDark ? AppColors.darkCard : AppColors.surface,
      shape: const CircleBorder(),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onTap,
        child: const SizedBox(
          width: 40,
          height: 40,
          child: Icon(Icons.close, size: 20, color: AppColors.textSecondary),
        ),
      ),
    );
  }
}

class _PickerField extends StatelessWidget {
  final String? value;
  final String hint;
  final VoidCallback onTap;
  final bool enabled;
  final bool loading;

  const _PickerField({
    required this.hint,
    required this.onTap,
    this.value,
    this.enabled = true,
    this.loading = false,
  });

  @override
  Widget build(BuildContext context) {
    final hasValue = value != null && value!.isNotEmpty;
    return InkWell(
      onTap: enabled ? onTap : null,
      borderRadius: BorderRadius.circular(AppConstants.radiusMd),
      child: Container(
        height: 52,
        padding: const EdgeInsets.symmetric(horizontal: AppConstants.spacingMd),
        decoration: BoxDecoration(
          color: enabled ? AppColors.surface : AppColors.background,
          borderRadius: BorderRadius.circular(AppConstants.radiusMd),
          border: Border.all(
            color: hasValue ? AppColors.primary : AppColors.border,
            width: hasValue ? 1.4 : 1,
          ),
        ),
        child: Row(
          children: [
            Expanded(
              child: Text(
                hasValue ? value! : hint,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: AppTextStyles.body.copyWith(
                  color: hasValue ? AppColors.textPrimary : AppColors.textHint,
                ),
              ),
            ),
            if (loading)
              const SizedBox(
                  width: 18,
                  height: 18,
                  child: CircularProgressIndicator(strokeWidth: 2))
            else
              const Icon(Icons.keyboard_arrow_down, color: AppColors.textHint),
          ],
        ),
      ),
    );
  }
}

class _MiniLoader extends StatelessWidget {
  const _MiniLoader();
  @override
  Widget build(BuildContext context) => const SizedBox(
        height: 40,
        child: Center(
          child: SizedBox(
              width: 20,
              height: 20,
              child: CircularProgressIndicator(strokeWidth: 2)),
        ),
      );
}

class _Avatar extends StatelessWidget {
  final String text;
  final bool selected;
  const _Avatar({required this.text, required this.selected});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 36,
      height: 36,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: selected ? AppColors.primary : AppColors.violetSurface,
        shape: BoxShape.circle,
      ),
      child: Text(text,
          style: AppTextStyles.caption.copyWith(
            color: selected ? Colors.white : AppColors.primary,
            fontWeight: FontWeight.w700,
          )),
    );
  }
}

class _PickerSheet extends StatelessWidget {
  final String title;
  final String hint;
  final RxString search;
  final Widget Function(ScrollController) listBuilder;

  const _PickerSheet({
    required this.title,
    required this.hint,
    required this.search,
    required this.listBuilder,
  });

  @override
  Widget build(BuildContext context) {
    return DraggableScrollableSheet(
      expand: false,
      initialChildSize: 0.75,
      maxChildSize: 0.92,
      builder: (_, scroll) => Column(
        children: [
          Container(
            margin: const EdgeInsets.symmetric(vertical: 10),
            width: 40,
            height: 4,
            decoration: BoxDecoration(
              color: AppColors.border,
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 8),
            child: Align(
                alignment: Alignment.centerLeft,
                child: Text(title, style: AppTextStyles.h3)),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 12),
            child: TextField(
              autofocus: true,
              decoration: InputDecoration(
                hintText: hint,
                prefixIcon: const Icon(Icons.search, size: 20),
              ),
              onChanged: (v) => search.value = v.toLowerCase(),
            ),
          ),
          Expanded(child: listBuilder(scroll)),
        ],
      ),
    );
  }
}
