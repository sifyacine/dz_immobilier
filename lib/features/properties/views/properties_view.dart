import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../app/constants/app_constants.dart';
import '../../../app/routes/app_routes.dart';
import '../../../app/theme/app_colors.dart';
import '../../../app/theme/app_gradients.dart';
import '../../../app/theme/app_text_styles.dart';
import '../../../shared/extensions/l10n_extension.dart';
import '../../../shared/widgets/app_app_bar.dart';
import '../../../shared/widgets/app_button.dart';
import '../../shell/controllers/shell_controller.dart';
import '../controllers/properties_controller.dart';
import '../widgets/property_card.dart';
import '../widgets/property_card_skeleton.dart';
import 'properties_map_view.dart';

/// Home screen — quick actions + the newest listings with pull-to-refresh
/// and infinite scroll. Everything scrolls as one surface.
class PropertiesView extends GetView<PropertiesController> {
  const PropertiesView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppAppBar(onMenuTap: () => Get.toNamed(Routes.components)),
      body: RefreshIndicator(
        onRefresh: controller.loadProperties,
        child: NotificationListener<ScrollNotification>(
          onNotification: (n) {
            if (n is ScrollEndNotification && n.metrics.extentAfter < 240) {
              controller.loadMore();
            }
            return false;
          },
          child: CustomScrollView(
            slivers: [
              // ── Quick search entry (jumps to the Search tab) ────────────
              const SliverToBoxAdapter(child: _SearchShortcut()),

              // ── Estimation / Simulation actions (horizontal carousel) ───
              const SliverToBoxAdapter(child: _HomeActionBanner()),

              // ── Section header: "Annonces récentes" + map link ──────────
              SliverToBoxAdapter(
                child: Obx(() => _SectionHeader(
                      count: controller.total.value,
                      onMap: controller.properties.isEmpty
                          ? null
                          : () => Get.to(() => PropertiesMapView(
                              properties: controller.properties.toList())),
                    )),
              ),

              // ── Body: loading / error / list ────────────────────────────
              Obx(() {
                if (controller.isLoading.value) {
                  return const _SkeletonSliver();
                }
                if (controller.error.isNotEmpty) {
                  return SliverToBoxAdapter(
                    child: _ErrorState(
                      message: controller.error.value,
                      onRetry: controller.loadProperties,
                    ),
                  );
                }
                return _ListSliver(controller: controller);
              }),
            ],
          ),
        ),
      ),
    );
  }
}

// ── Search shortcut ───────────────────────────────────────────────────────────

class _SearchShortcut extends StatelessWidget {
  const _SearchShortcut();

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Padding(
      padding: const EdgeInsets.all(AppConstants.spacingMd),
      child: Material(
        color: isDark ? AppColors.darkCard : AppColors.surface,
        borderRadius: BorderRadius.circular(AppConstants.radiusPill),
        clipBehavior: Clip.antiAlias,
        elevation: 1,
        shadowColor: AppColors.federal.withValues(alpha: 0.10),
        child: InkWell(
          onTap: () {
            // Jump to the Search tab.
            try {
              Get.find<ShellController>().goTo(1);
            } catch (_) {}
          },
          child: Padding(
            padding: const EdgeInsets.symmetric(
                horizontal: AppConstants.spacingMd, vertical: 14),
            child: Row(
              children: [
                const Icon(Icons.search_rounded,
                    color: AppColors.primary, size: 22),
                const SizedBox(width: AppConstants.spacingSm),
                Expanded(
                  child: Text(
                    context.l10n.homeSearchShortcut,
                    style: AppTextStyles.body
                        .copyWith(color: AppColors.textHint),
                  ),
                ),
                Container(
                  width: 34,
                  height: 34,
                  decoration: const BoxDecoration(
                    gradient: AppGradients.purpleFade,
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(Icons.tune_rounded,
                      color: Colors.white, size: 18),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// ── Section header ────────────────────────────────────────────────────────────

class _SectionHeader extends StatelessWidget {
  final int count;
  final VoidCallback? onMap;
  const _SectionHeader({required this.count, this.onMap});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(AppConstants.spacingMd, 0,
          AppConstants.spacingSm, AppConstants.spacingSm),
      child: Row(
        children: [
          Expanded(
            child: Text(context.l10n.homeRecentListings,
                style: AppTextStyles.h3),
          ),
          if (onMap != null)
            TextButton.icon(
              onPressed: onMap,
              icon: const Icon(Icons.map_outlined, size: 18),
              label: Text(context.l10n.homeViewMap),
              style: TextButton.styleFrom(foregroundColor: AppColors.primary),
            ),
        ],
      ),
    );
  }
}

// ── List ──────────────────────────────────────────────────────────────────────

class _ListSliver extends StatelessWidget {
  final PropertiesController controller;
  const _ListSliver({required this.controller});

  @override
  Widget build(BuildContext context) {
    return SliverPadding(
      padding: const EdgeInsets.fromLTRB(AppConstants.spacingMd, 0,
          AppConstants.spacingMd, 100),
      sliver: Obx(() {
        final count = controller.properties.length;
        final showLoader = controller.hasMore;
        return SliverList.separated(
          itemCount: count + (showLoader ? 1 : 0),
          separatorBuilder: (_, _) =>
              const SizedBox(height: AppConstants.spacingMd),
          itemBuilder: (_, i) {
            if (i == count) {
              return Padding(
                padding: const EdgeInsets.symmetric(vertical: 16),
                child: Center(
                  child: controller.isLoadingMore.value
                      ? const CircularProgressIndicator()
                      : TextButton(
                          onPressed: controller.loadMore,
                          child: Text(
                            context.l10n
                                .propertiesLoadMore(controller.total.value - count),
                            style: const TextStyle(color: AppColors.primary),
                          ),
                        ),
                ),
              );
            }
            final property = controller.properties[i];
            return PropertyCard(
              property: property,
              onTap: () => Get.toNamed(
                Routes.propertyDetail,
                arguments: property,
              ),
            );
          },
        );
      }),
    );
  }
}

// ── Loading skeletons ─────────────────────────────────────────────────────────

class _SkeletonSliver extends StatelessWidget {
  const _SkeletonSliver();

  @override
  Widget build(BuildContext context) {
    return SliverPadding(
      padding: const EdgeInsets.fromLTRB(
          AppConstants.spacingMd, 0, AppConstants.spacingMd, 100),
      sliver: SliverList.separated(
        itemCount: 5,
        separatorBuilder: (_, _) =>
            const SizedBox(height: AppConstants.spacingMd),
        itemBuilder: (_, _) => const PropertyCardSkeleton(),
      ),
    );
  }
}

// ── Always-visible action banner ─────────────────────────────────────────────

class _HomeActionBanner extends StatelessWidget {
  const _HomeActionBanner();

  @override
  Widget build(BuildContext context) {
    final actions = <_ActionData>[
      _ActionData(
        label: context.l10n.homeEstimationAction,
        subtitle: context.l10n.homeEstimationSubtitle,
        icon: Icons.bar_chart_rounded,
        onTap: () => Get.toNamed(Routes.speed30),
      ),
      _ActionData(
        label: context.l10n.homeSimulationAction,
        subtitle: context.l10n.homeSimulationSubtitle,
        icon: Icons.calculate_outlined,
        onTap: () => Get.toNamed(Routes.simulation),
      ),
    ];

    return Padding(
      padding: const EdgeInsets.fromLTRB(AppConstants.spacingMd, 0,
          AppConstants.spacingMd, AppConstants.spacingMd),
      child: Container(
        decoration: BoxDecoration(
          gradient: AppGradients.purpleFade,
          borderRadius: BorderRadius.circular(AppConstants.radiusLg),
          boxShadow: [
            BoxShadow(
              color: AppColors.primary.withValues(alpha: 0.28),
              blurRadius: 18,
              offset: const Offset(0, 8),
            ),
          ],
        ),
        padding: const EdgeInsets.all(AppConstants.spacingSm),
        child: SizedBox(
          height: 64,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            padding: EdgeInsets.zero,
            itemCount: actions.length,
            separatorBuilder: (_, _) =>
                const SizedBox(width: AppConstants.spacingSm),
            itemBuilder: (_, i) => _ActionTile(data: actions[i]),
          ),
        ),
      ),
    );
  }
}

class _ActionData {
  final String label;
  final String subtitle;
  final IconData icon;
  final VoidCallback onTap;
  const _ActionData({
    required this.label,
    required this.subtitle,
    required this.icon,
    required this.onTap,
  });
}

/// Translucent tile inside the gradient action panel (horizontally scrollable).
class _ActionTile extends StatelessWidget {
  final _ActionData data;
  const _ActionTile({required this.data});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 196,
      child: Material(
        color: Colors.white.withValues(alpha: 0.15),
        borderRadius: BorderRadius.circular(AppConstants.radiusMd),
        clipBehavior: Clip.antiAlias,
        child: InkWell(
          onTap: data.onTap,
          splashColor: Colors.white24,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12),
            child: Row(
              children: [
                Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.22),
                    borderRadius: BorderRadius.circular(AppConstants.radiusSm),
                  ),
                  child: Icon(data.icon, size: 20, color: Colors.white),
                ),
                const SizedBox(width: AppConstants.spacingSm),
                Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(data.label,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: AppTextStyles.button
                              .copyWith(color: Colors.white)),
                      Text(data.subtitle,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: AppTextStyles.caption.copyWith(
                              color: Colors.white.withValues(alpha: 0.78))),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// ── Error state ───────────────────────────────────────────────────────────────

class _ErrorState extends StatelessWidget {
  final String message;
  final VoidCallback onRetry;
  const _ErrorState({required this.message, required this.onRetry});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(AppConstants.spacingMd,
          AppConstants.spacingXl, AppConstants.spacingMd, AppConstants.spacingXl),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(Icons.cloud_off, size: 48, color: AppColors.textHint),
          const SizedBox(height: AppConstants.spacingMd),
          Text(message, textAlign: TextAlign.center),
          const SizedBox(height: AppConstants.spacingMd),
          AppButton(
            label: context.l10n.commonRetry,
            icon: Icons.refresh,
            expanded: false,
            onPressed: onRetry,
          ),
        ],
      ),
    );
  }
}
