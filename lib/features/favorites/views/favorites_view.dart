import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import '../../../app/constants/app_constants.dart';
import '../../../app/routes/app_routes.dart';
import '../../../app/theme/app_colors.dart';
import '../../../app/theme/app_gradients.dart';
import '../../../app/theme/app_text_styles.dart';
import '../../../core/storage/storage_service.dart';
import '../../../data/models/property_model.dart';
import '../controllers/favorites_controller.dart';

class FavoritesView extends GetView<FavoritesController> {
  const FavoritesView({super.key});

  @override
  Widget build(BuildContext context) {
    final storage = Get.find<StorageService>();
    if (!storage.isLoggedIn) return const _GuestWishlist();

    final isDark = Theme.of(context).brightness == Brightness.dark;
    final bg = isDark ? AppColors.darkBackground : AppColors.background;

    return Scaffold(
      backgroundColor: bg,
      body: SafeArea(
        child: Obx(() {
          // ── Loading state ────────────────────────────────────────────
          if (controller.isLoading.value) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          return CustomScrollView(
            slivers: [
              // ── Header ────────────────────────────────────────────────
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(
                    AppConstants.spacingMd,
                    AppConstants.spacingMd,
                    AppConstants.spacingMd,
                    AppConstants.spacingSm,
                  ),
                  child: Row(
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Ma Wishlist', style: AppTextStyles.h2),
                          Obx(() => Text(
                                '${controller.favorites.length} bien${controller.favorites.length > 1 ? 's' : ''} sauvegardé${controller.favorites.length > 1 ? 's' : ''}',
                                style: AppTextStyles.bodySecondary,
                              )),
                        ],
                      ),
                      const Spacer(),
                      // Clear all button (only if list not empty)
                      if (controller.favorites.isNotEmpty)
                        TextButton.icon(
                          onPressed: () => _confirmClear(context),
                          icon: const Icon(Icons.delete_outline,
                              size: 18, color: AppColors.error),
                          label: Text('Tout effacer',
                              style: AppTextStyles.caption.copyWith(
                                  color: AppColors.error,
                                  fontWeight: FontWeight.w600)),
                        ),
                    ],
                  ),
                ),
              ),

              // ── Empty state ───────────────────────────────────────────
              if (controller.favorites.isEmpty)
                SliverFillRemaining(
                  hasScrollBody: false,
                  child: _EmptyState(),
                )
              else ...[
                // ── Filter chips row ──────────────────────────────────
                SliverToBoxAdapter(child: _FilterRow()),

                // ── Property list ─────────────────────────────────────
                Obx(() {
                  final list = controller.filteredFavorites;
                  if (list.isEmpty) {
                    return SliverFillRemaining(
                      hasScrollBody: false,
                      child: Center(
                        child: Padding(
                          padding: const EdgeInsets.all(AppConstants.spacingLg),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Icon(Icons.filter_list_off_rounded,
                                  size: 48, color: AppColors.textHint),
                              const SizedBox(height: AppConstants.spacingSm),
                              Text(
                                "Aucun résultat pour ce filtre",
                                style: AppTextStyles.h3,
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  }
                  return SliverPadding(
                    padding: const EdgeInsets.fromLTRB(
                      AppConstants.spacingMd,
                      AppConstants.spacingSm,
                      AppConstants.spacingMd,
                      AppConstants.spacingXl,
                    ),
                    sliver: SliverList(
                      delegate: SliverChildBuilderDelegate(
                        (context, i) => Padding(
                          padding: const EdgeInsets.only(
                              bottom: AppConstants.spacingMd),
                          child: _WishlistCard(
                            property: list[i],
                            onRemove: () =>
                                controller.remove(list[i]),
                          ),
                        ),
                        childCount: list.length,
                      ),
                    ),
                  );
                }),
              ],
            ],
          );
        }),
      ),
    );
  }

  void _confirmClear(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (_) => _ClearConfirmSheet(
        onConfirm: controller.clear,
      ),
    );
  }
}

// ══════════════════════════════════════════════════════════════════════════════
// FILTER ROW (Tous · À vendre · À louer)
// ══════════════════════════════════════════════════════════════════════════════

class _FilterRow extends GetView<FavoritesController> {
  static const _filters = ['Tous', 'À vendre', 'À louer'];

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 44,
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(
            horizontal: AppConstants.spacingMd),
        child: Obx(
          () => Row(
            children: _filters.map((f) {
              final selected = controller.selectedFilter.value == f;
              return Padding(
                padding: const EdgeInsets.only(right: AppConstants.spacingSm),
                child: GestureDetector(
                  onTap: () => controller.selectedFilter.value = f,
                  child: AnimatedContainer(
                    duration: AppConstants.animationDuration,
                    padding: const EdgeInsets.symmetric(
                        horizontal: 18, vertical: 8),
                    decoration: BoxDecoration(
                      gradient: selected ? AppGradients.purpleFade : null,
                      color: selected ? null : Colors.transparent,
                      borderRadius:
                          BorderRadius.circular(AppConstants.radiusPill),
                      border: selected
                          ? null
                          : Border.all(color: AppColors.border),
                    ),
                    child: Center(
                      child: Text(
                        f,
                        style: AppTextStyles.body.copyWith(
                          color: selected
                              ? Colors.white
                              : AppColors.textSecondary,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                ),
              );
            }).toList(),
          ),
        ),
      ),
    );
  }
}

// ══════════════════════════════════════════════════════════════════════════════
// WISHLIST CARD (horizontal layout)
// ══════════════════════════════════════════════════════════════════════════════

class _WishlistCard extends StatelessWidget {
  final Property property;
  final VoidCallback onRemove;

  const _WishlistCard({
    required this.property,
    required this.onRemove,
  });

  String get _price {
    final val = NumberFormat.decimalPattern('fr').format(property.price);
    return property.isRent
        ? '$val ${property.currency}/mois'
        : '$val ${property.currency}';
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final cardBg = isDark ? AppColors.darkCard : AppColors.surface;

    return Dismissible(
      key: ValueKey(property.id),
      direction: DismissDirection.endToStart,
      background: _SwipeBackground(),
      onDismissed: (_) => onRemove(),
      child: Container(
        decoration: BoxDecoration(
          color: cardBg,
          borderRadius: BorderRadius.circular(AppConstants.radiusMd),
          boxShadow: const [
            BoxShadow(
                color: Color(0x0A0A0A41),
                blurRadius: 12,
                offset: Offset(0, 4)),
          ],
        ),
        child: InkWell(
          borderRadius: BorderRadius.circular(AppConstants.radiusMd),
          onTap: () {},
          child: Row(
            children: [
              // ── Thumbnail ───────────────────────────────────────────
              ClipRRect(
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(AppConstants.radiusMd),
                  bottomLeft: Radius.circular(AppConstants.radiusMd),
                ),
                child: SizedBox(
                  width: 120,
                  height: 130,
                  child: property.thumbnail != null
                      ? CachedNetworkImage(
                          imageUrl: property.thumbnail!,
                          fit: BoxFit.cover,
                          placeholder: (context, url) =>
                              Container(color: AppColors.border),
                          errorWidget: (context, url, error) => Container(
                            color: AppColors.border,
                            child: const Icon(Icons.home_outlined,
                                color: AppColors.textHint),
                          ),
                        )
                      : Container(
                          color: AppColors.border,
                          child: const Icon(Icons.home_outlined,
                              color: AppColors.textHint),
                        ),
                ),
              ),

              // ── Details ─────────────────────────────────────────────
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(AppConstants.spacingMd),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Type badge
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 8, vertical: 3),
                        decoration: BoxDecoration(
                          color: property.isRent
                              ? AppColors.errorSurface
                              : AppColors.violetSurface,
                          borderRadius: BorderRadius.circular(
                              AppConstants.radiusPill),
                        ),
                        child: Text(
                          property.isRent ? 'À louer' : 'À vendre',
                          style: AppTextStyles.caption.copyWith(
                            color: property.isRent
                                ? AppColors.error
                                : AppColors.primary,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                      const SizedBox(height: 6),
                      Text(property.title,
                          style: AppTextStyles.title,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis),
                      const SizedBox(height: 4),
                      Row(children: [
                        const Icon(Icons.location_on_outlined,
                            size: 12, color: AppColors.textHint),
                        const SizedBox(width: 3),
                        Expanded(
                          child: Text(property.city,
                              style: AppTextStyles.caption,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis),
                        ),
                      ]),
                      const SizedBox(height: 8),
                      // Specs row
                      Row(children: [
                        _Spec(
                            icon: Icons.bed_outlined,
                            label: '${property.bedrooms}'),
                        const SizedBox(width: 10),
                        _Spec(
                            icon: Icons.bathtub_outlined,
                            label: '${property.bathrooms}'),
                        const SizedBox(width: 10),
                        _Spec(
                            icon: Icons.straighten,
                            label: '${property.area.toInt()}m²'),
                      ]),
                      const SizedBox(height: 8),
                      Text(_price, style: AppTextStyles.price),
                    ],
                  ),
                ),
              ),

              // ── Remove button ────────────────────────────────────────
              Padding(
                padding:
                    const EdgeInsets.only(right: AppConstants.spacingSm),
                child: IconButton(
                  icon: const Icon(Icons.favorite_rounded,
                      color: AppColors.error, size: 22),
                  onPressed: onRemove,
                  tooltip: 'Retirer des favoris',
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _Spec extends StatelessWidget {
  final IconData icon;
  final String label;
  const _Spec({required this.icon, required this.label});

  @override
  Widget build(BuildContext context) {
    return Row(children: [
      Icon(icon, size: 13, color: AppColors.textSecondary),
      const SizedBox(width: 3),
      Text(label, style: AppTextStyles.caption),
    ]);
  }
}

// ══════════════════════════════════════════════════════════════════════════════
// SWIPE BACKGROUND
// ══════════════════════════════════════════════════════════════════════════════

class _SwipeBackground extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.error,
        borderRadius: BorderRadius.circular(AppConstants.radiusMd),
      ),
      alignment: Alignment.centerRight,
      padding:
          const EdgeInsets.only(right: AppConstants.spacingLg),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(Icons.delete_outline,
              color: Colors.white, size: 26),
          const SizedBox(height: 4),
          Text('Supprimer',
              style: AppTextStyles.caption
                  .copyWith(color: Colors.white, fontWeight: FontWeight.w700)),
        ],
      ),
    );
  }
}

// ══════════════════════════════════════════════════════════════════════════════
// EMPTY STATE
// ══════════════════════════════════════════════════════════════════════════════

class _EmptyState extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: AppConstants.pagePadding,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 110,
              height: 110,
              decoration: const BoxDecoration(
                gradient: AppGradients.purpleFade,
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.favorite_border_rounded,
                size: 54,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: AppConstants.spacingLg),
            Text('Aucun bien sauvegardé',
                style: AppTextStyles.h2, textAlign: TextAlign.center),
            const SizedBox(height: AppConstants.spacingSm),
            Text(
              'Explorez les annonces et appuyez sur le ♡\npour sauvegarder vos biens préférés ici.',
              textAlign: TextAlign.center,
              style: AppTextStyles.bodySecondary,
            ),
            const SizedBox(height: AppConstants.spacingXl),
            SizedBox(
              width: double.infinity,
              height: 54,
              child: DecoratedBox(
                decoration: ShapeDecoration(
                  gradient: AppGradients.purpleFade,
                  shape: const StadiumBorder(),
                ),
                child: Material(
                  color: Colors.transparent,
                  shape: const StadiumBorder(),
                  child: InkWell(
                    onTap: () {
                      // Navigate back to home tab
                      try {
                        final shell =
                            Get.find<GetxController>(tag: 'shell');
                        // ignore: avoid_dynamic_calls
                        (shell as dynamic).goTo(0);
                      } catch (_) {}
                    },
                    child: Center(
                      child: Text('Explorer les annonces',
                          style: AppTextStyles.button),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ══════════════════════════════════════════════════════════════════════════════
// CLEAR CONFIRM BOTTOM SHEET
// ══════════════════════════════════════════════════════════════════════════════

class _ClearConfirmSheet extends StatelessWidget {
  final VoidCallback onConfirm;
  const _ClearConfirmSheet({required this.onConfirm});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final bg = isDark ? AppColors.darkCard : AppColors.surface;
    return Container(
      margin: const EdgeInsets.all(AppConstants.spacingMd),
      padding: const EdgeInsets.all(AppConstants.spacingLg),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(AppConstants.radiusLg),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: AppColors.errorSurface,
              shape: BoxShape.circle,
            ),
            child: const Icon(Icons.delete_outline,
                color: AppColors.error, size: 26),
          ),
          const SizedBox(height: AppConstants.spacingMd),
          Text('Vider la Wishlist',
              style: AppTextStyles.h3, textAlign: TextAlign.center),
          const SizedBox(height: AppConstants.spacingSm),
          Text(
            'Tous vos biens sauvegardés seront supprimés. Cette action est irréversible.',
            textAlign: TextAlign.center,
            style: AppTextStyles.bodySecondary,
          ),
          const SizedBox(height: AppConstants.spacingXl),
          Row(children: [
            Expanded(
              child: OutlinedButton(
                onPressed: () => Navigator.pop(context),
                style: OutlinedButton.styleFrom(
                  padding:
                      const EdgeInsets.symmetric(vertical: 14),
                  side: const BorderSide(color: AppColors.border),
                  shape: const StadiumBorder(),
                ),
                child: Text('Annuler',
                    style: AppTextStyles.button
                        .copyWith(color: AppColors.textPrimary)),
              ),
            ),
            const SizedBox(width: AppConstants.spacingMd),
            Expanded(
              child: ElevatedButton(
                onPressed: () {
                  onConfirm();
                  Navigator.pop(context);
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.error,
                  padding:
                      const EdgeInsets.symmetric(vertical: 14),
                  shape: const StadiumBorder(),
                  elevation: 0,
                ),
                child: Text('Supprimer',
                    style: AppTextStyles.button),
              ),
            ),
          ]),
          const SizedBox(height: AppConstants.spacingSm),
        ],
      ),
    );
  }
}

// ══════════════════════════════════════════════════════════════════════════════
// GUEST WALL
// ══════════════════════════════════════════════════════════════════════════════

class _GuestWishlist extends StatelessWidget {
  const _GuestWishlist();

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final bg = isDark ? AppColors.darkBackground : AppColors.background;

    return Scaffold(
      backgroundColor: bg,
      body: SafeArea(
        child: Center(
          child: Padding(
            padding: AppConstants.pagePadding,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 110,
                  height: 110,
                  decoration: const BoxDecoration(
                    gradient: AppGradients.purpleFade,
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.favorite_border_rounded,
                    size: 54,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: AppConstants.spacingLg),
                Text(
                  'Sauvegardez vos coups de cœur',
                  style: AppTextStyles.h2,
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: AppConstants.spacingSm),
                Text(
                  'Connectez-vous pour retrouver tous vos biens\nfavoris à tout moment.',
                  textAlign: TextAlign.center,
                  style: AppTextStyles.bodySecondary,
                ),
                const SizedBox(height: AppConstants.spacingXl),
                SizedBox(
                  width: double.infinity,
                  height: 54,
                  child: DecoratedBox(
                    decoration: const ShapeDecoration(
                      gradient: AppGradients.purpleFade,
                      shape: StadiumBorder(),
                    ),
                    child: Material(
                      color: Colors.transparent,
                      shape: const StadiumBorder(),
                      child: InkWell(
                        onTap: () => Get.toNamed(Routes.login),
                        child: Center(
                          child: Text('Se connecter', style: AppTextStyles.button),
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: AppConstants.spacingSm),
                SizedBox(
                  width: double.infinity,
                  height: 54,
                  child: OutlinedButton(
                    onPressed: () => Get.toNamed(Routes.register),
                    style: OutlinedButton.styleFrom(
                      side: const BorderSide(color: AppColors.border),
                      shape: const StadiumBorder(),
                    ),
                    child: Text(
                      'Créer un compte',
                      style: AppTextStyles.button
                          .copyWith(color: AppColors.textPrimary),
                    ),
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
