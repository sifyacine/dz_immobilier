import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../app/constants/app_constants.dart';
import '../../../app/routes/app_routes.dart';
import '../../../app/theme/app_colors.dart';
import '../../../app/theme/app_gradients.dart';
import '../../../app/theme/app_text_styles.dart';
import '../../../shared/extensions/l10n_extension.dart';
import '../../../shared/widgets/widgets.dart';
import '../../properties/views/properties_map_view.dart';
import '../controllers/search_controller.dart' as app_search;
import '../widgets/filter_bottom_sheet.dart';
import '../widgets/search_property_card.dart';

class SearchView extends StatefulWidget {
  const SearchView({super.key});

  @override
  State<SearchView> createState() => _SearchViewState();
}

class _SearchViewState extends State<SearchView> {
  late final app_search.SearchController _controller;
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _controller = Get.find<app_search.SearchController>();
    _searchController.text = _controller.searchQuery.value;

    _searchController.addListener(() {
      _controller.searchQuery.value = _searchController.text;
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _openFilters() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => const FilterBottomSheet(),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final bg = isDark ? AppColors.darkBackground : AppColors.background;
    final titleColor =
        isDark ? AppColors.darkTextPrimary : AppColors.textPrimary;
    final secondaryColor =
        isDark ? AppColors.darkTextSecondary : AppColors.textSecondary;

    return Scaffold(
      backgroundColor: bg,
      body: SafeArea(
        child: Obx(() {
          final showSuggestions = _controller.searchQuery.value.trim().isEmpty &&
              !_controller.isFilterActive;
          final results = _controller.filteredProperties;

          final content = CustomScrollView(
            slivers: [
              // ── Search Header ──────────────────────────────────────────
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.all(AppConstants.spacingMd),
                  child: Row(
                    children: [
                      Expanded(
                        child: Container(
                          decoration: BoxDecoration(
                            color: isDark ? AppColors.darkCard : AppColors.surface,
                            borderRadius: BorderRadius.circular(AppConstants.radiusPill),
                            boxShadow: const [
                              BoxShadow(
                                color: Color(0x05000000),
                                blurRadius: 8,
                                offset: Offset(0, 2),
                              ),
                            ],
                          ),
                          child: TextField(
                            controller: _searchController,
                            onSubmitted: (val) => _controller.addRecentSearch(val),
                            decoration: InputDecoration(
                              hintText: context.l10n.searchBarHint,
                              prefixIcon: const Icon(
                                Icons.search_rounded,
                                color: AppColors.primary,
                              ),
                              suffixIcon: _controller.searchQuery.value.isNotEmpty
                                  ? IconButton(
                                      icon: const Icon(Icons.clear, size: 18),
                                      onPressed: () {
                                        _searchController.clear();
                                        _controller.searchQuery.value = '';
                                      },
                                    )
                                  : null,
                              border: InputBorder.none,
                              enabledBorder: InputBorder.none,
                              focusedBorder: InputBorder.none,
                              contentPadding: const EdgeInsets.symmetric(
                                horizontal: 16,
                                vertical: 14,
                              ),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: AppConstants.spacingSm),
                      // Filter button
                      Stack(
                        clipBehavior: Clip.none,
                        children: [
                          Container(
                            decoration: BoxDecoration(
                              gradient: _controller.isFilterActive
                                  ? AppGradients.purpleFade
                                  : null,
                              color: _controller.isFilterActive
                                  ? null
                                  : (isDark ? AppColors.darkCard : AppColors.surface),
                              shape: BoxShape.circle,
                              boxShadow: const [
                                BoxShadow(
                                  color: Color(0x05000000),
                                  blurRadius: 8,
                                  offset: Offset(0, 2),
                                ),
                              ],
                            ),
                            child: IconButton(
                              icon: Icon(
                                Icons.tune_rounded,
                                color: _controller.isFilterActive
                                    ? Colors.white
                                    : AppColors.primary,
                              ),
                              onPressed: _openFilters,
                            ),
                          ),
                          if (_controller.isFilterActive)
                            Positioned(
                              top: -2,
                              right: -2,
                              child: Container(
                                width: 10,
                                height: 10,
                                decoration: const BoxDecoration(
                                  color: AppColors.error,
                                  shape: BoxShape.circle,
                                ),
                              ),
                            ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),

              // ── Suggestions view (if untouched) ─────────────────────────
              if (showSuggestions) ...[
                // Recent searches
                if (_controller.recentSearches.isNotEmpty) ...[
                  SliverToBoxAdapter(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: AppConstants.spacingMd),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(context.l10n.searchRecent,
                              style: AppTextStyles.title
                                  .copyWith(color: titleColor)),
                          TextButton(
                            onPressed: _controller.clearRecentSearches,
                            child: Text(
                              context.l10n.commonClear,
                              style: AppTextStyles.caption.copyWith(
                                color: AppColors.error,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  SliverToBoxAdapter(
                    child: SizedBox(
                      height: 38,
                      child: ListView.separated(
                        scrollDirection: Axis.horizontal,
                        padding: const EdgeInsets.symmetric(
                            horizontal: AppConstants.spacingMd),
                        itemCount: _controller.recentSearches.length,
                        separatorBuilder: (_, index) =>
                            const SizedBox(width: AppConstants.spacingSm),
                        itemBuilder: (context, i) {
                          final query = _controller.recentSearches[i];
                          return GestureDetector(
                            onTap: () {
                              _searchController.text = query;
                              _controller.searchQuery.value = query;
                            },
                            child: Chip(
                              label: Text(query),
                              deleteIcon: const Icon(Icons.close, size: 14),
                              onDeleted: () =>
                                  _controller.recentSearches.remove(query),
                              backgroundColor: isDark
                                  ? AppColors.darkCard
                                  : Colors.grey.shade100,
                              labelStyle: AppTextStyles.caption,
                              side: BorderSide.none,
                              shape: const StadiumBorder(),
                            ),
                          );
                        },
                      ),
                    ),
                  ),
                  const SliverToBoxAdapter(child: SizedBox(height: 16)),
                ],

                // Popular cities
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: AppConstants.spacingMd),
                    child: Text(context.l10n.searchPopularCities,
                        style: AppTextStyles.title.copyWith(color: titleColor)),
                  ),
                ),
                const SliverToBoxAdapter(child: SizedBox(height: 10)),
                SliverToBoxAdapter(
                  child: SizedBox(
                    height: 40,
                    child: ListView(
                      scrollDirection: Axis.horizontal,
                      padding: const EdgeInsets.symmetric(
                          horizontal: AppConstants.spacingMd),
                      children: [
                        _buildPopularCityChip('Alger', Icons.location_on),
                        const SizedBox(width: AppConstants.spacingSm),
                        _buildPopularCityChip('Oran', Icons.location_on),
                        const SizedBox(width: AppConstants.spacingSm),
                        _buildPopularCityChip('Constantine', Icons.location_on),
                      ],
                    ),
                  ),
                ),
                const SliverToBoxAdapter(child: SizedBox(height: 20)),

                // Recommandations section title
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: AppConstants.spacingMd),
                    child: Text(context.l10n.searchAllListings,
                        style: AppTextStyles.title.copyWith(color: titleColor)),
                  ),
                ),
              ] else ...[
                // Results Header
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: AppConstants.spacingMd,
                      vertical: AppConstants.spacingSm,
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          context.l10n.searchResultsCount(results.length),
                          style: AppTextStyles.bodySecondary.copyWith(
                            fontWeight: FontWeight.w600,
                            color: secondaryColor,
                          ),
                        ),
                        if (_controller.isFilterActive)
                          TextButton(
                            onPressed: () {
                              _controller.resetFilters();
                              _searchController.clear();
                              _controller.searchQuery.value = '';
                            },
                            child: Text(
                              context.l10n.searchResetFilters,
                              style: AppTextStyles.caption.copyWith(
                                color: AppColors.primary,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                      ],
                    ),
                  ),
                ),
              ],

              // ── Empty State ──────────────────────────────────────────────
              if (results.isEmpty)
                SliverFillRemaining(
                  hasScrollBody: false,
                  child: Center(
                    child: Padding(
                      padding: const EdgeInsets.all(AppConstants.spacingLg),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                            width: 80,
                            height: 80,
                            decoration: BoxDecoration(
                              color: AppColors.violetSurface,
                              shape: BoxShape.circle,
                            ),
                            child: const Icon(
                              Icons.search_off_rounded,
                              size: 40,
                              color: AppColors.primary,
                            ),
                          ),
                          const SizedBox(height: AppConstants.spacingMd),
                          Text(
                            context.l10n.searchNoResultsTitle,
                            style: AppTextStyles.h3.copyWith(color: titleColor),
                          ),
                          const SizedBox(height: AppConstants.spacingSm),
                          Text(
                            context.l10n.searchNoResultsBody,
                            textAlign: TextAlign.center,
                            style: AppTextStyles.bodySecondary
                                .copyWith(color: secondaryColor),
                          ),
                          const SizedBox(height: AppConstants.spacingLg),
                          AppButton(
                            label: context.l10n.searchResetFiltersBtn,
                            variant: AppButtonVariant.outline,
                            expanded: false,
                            onPressed: () {
                              _controller.resetFilters();
                              _searchController.clear();
                              _controller.searchQuery.value = '';
                            },
                          ),
                        ],
                      ),
                    ),
                  ),
                )
              else
                // ── Results Grid ─────────────────────────────────────────────
                SliverPadding(
                  padding: const EdgeInsets.fromLTRB(AppConstants.spacingMd,
                      AppConstants.spacingMd, AppConstants.spacingMd, 120),
                  sliver: SliverGrid.builder(
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      mainAxisSpacing: AppConstants.spacingMd,
                      crossAxisSpacing: AppConstants.spacingMd,
                      childAspectRatio: 0.68,
                    ),
                    itemCount: results.length,
                    itemBuilder: (context, i) {
                      final property = results[i];
                      return SearchPropertyCard(
                        property: property,
                        onTap: () => Get.toNamed(
                          Routes.propertyDetail,
                          arguments: property,
                        ),
                      );
                    },
                  ),
                ),
            ],
          );

          if (results.isEmpty) return content;
          return Stack(
            children: [
              content,
              // Small bordered circular "map" toggle, floating above the nav.
              Positioned(
                left: 0,
                right: 0,
                bottom: 96,
                child: Center(
                  child: _MapFab(
                    onTap: () => Get.to(
                      () => PropertiesMapView(properties: results.toList()),
                    ),
                  ),
                ),
              ),
            ],
          );
        }),
      ),
    );
  }

  Widget _buildPopularCityChip(String city, IconData icon) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return GestureDetector(
      onTap: () {
        _searchController.text = city;
        _controller.searchQuery.value = city;
        _controller.addRecentSearch(city);
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: isDark ? AppColors.darkCard : AppColors.surface,
          borderRadius: BorderRadius.circular(AppConstants.radiusPill),
          border: Border.all(
              color: isDark ? AppColors.darkCard : AppColors.border),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 14, color: AppColors.primary),
            const SizedBox(width: 6),
            Text(
              city,
              style: AppTextStyles.body.copyWith(
                fontWeight: FontWeight.w600,
                color: isDark
                    ? AppColors.darkTextPrimary
                    : AppColors.textPrimary,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// White "Carte" pill that floats above the nav and opens the map view.
class _MapFab extends StatelessWidget {
  final VoidCallback onTap;
  const _MapFab({required this.onTap});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Material(
      color: isDark ? AppColors.darkCard : AppColors.surface,
      shape: StadiumBorder(
        side: BorderSide(
          color: isDark ? AppColors.darkCard : AppColors.border,
        ),
      ),
      clipBehavior: Clip.antiAlias,
      elevation: 6,
      shadowColor: AppColors.federal.withValues(alpha: 0.30),
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Icons.map_outlined,
                  color: AppColors.primary, size: 20),
              const SizedBox(width: 8),
              Text(
                context.l10n.homeViewMap,
                style: AppTextStyles.button.copyWith(
                  color: isDark
                      ? AppColors.darkTextPrimary
                      : AppColors.textPrimary,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
