import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../app/constants/app_constants.dart';
import '../../../app/theme/app_colors.dart';
import '../../../app/theme/app_gradients.dart';
import '../../../app/theme/app_text_styles.dart';
import '../../../shared/extensions/l10n_extension.dart';
import '../../../shared/widgets/widgets.dart';
import '../controllers/search_controller.dart' as app_search;

class FilterBottomSheet extends StatefulWidget {
  const FilterBottomSheet({super.key});

  @override
  State<FilterBottomSheet> createState() => _FilterBottomSheetState();
}

class _FilterBottomSheetState extends State<FilterBottomSheet> {
  late final app_search.SearchController _controller;

  late String _type;
  late String _category;
  late int? _wilayaId;
  late final TextEditingController _minPriceController;
  late final TextEditingController _maxPriceController;
  late int _bedrooms;
  late final TextEditingController _minAreaController;

  @override
  void initState() {
    super.initState();
    _controller = Get.find<app_search.SearchController>();

    _type = _controller.selectedType.value;
    _category = _controller.selectedCategory.value;
    _wilayaId = _controller.selectedWilayaId.value;
    _bedrooms = _controller.minBedrooms.value;

    _minPriceController = TextEditingController(
      text: _controller.minPrice.value != null
          ? _controller.minPrice.value!.toInt().toString()
          : '',
    );
    _maxPriceController = TextEditingController(
      text: _controller.maxPrice.value != null
          ? _controller.maxPrice.value!.toInt().toString()
          : '',
    );
    _minAreaController = TextEditingController(
      text: _controller.minArea.value != null
          ? _controller.minArea.value!.toInt().toString()
          : '',
    );
  }

  @override
  void dispose() {
    _minPriceController.dispose();
    _maxPriceController.dispose();
    _minAreaController.dispose();
    super.dispose();
  }

  void _apply() {
    _controller.selectedType.value = _type;
    _controller.selectedCategory.value = _category;
    _controller.selectedWilayaId.value = _wilayaId;
    _controller.minBedrooms.value = _bedrooms;
    _controller.minPrice.value =
        double.tryParse(_minPriceController.text.trim());
    _controller.maxPrice.value =
        double.tryParse(_maxPriceController.text.trim());
    _controller.minArea.value =
        double.tryParse(_minAreaController.text.trim());
    Navigator.pop(context);
    // Trigger server-side search with the new filters
    _controller.applySearch();
  }

  void _reset() {
    setState(() {
      _type = 'all';
      _category = 'all';
      _wilayaId = null;
      _bedrooms = 0;
      _minPriceController.clear();
      _maxPriceController.clear();
      _minAreaController.clear();
    });
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final bg = isDark ? AppColors.darkCard : AppColors.surface;

    return Container(
      decoration: BoxDecoration(
        color: bg,
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(AppConstants.radiusLg),
          topRight: Radius.circular(AppConstants.radiusLg),
        ),
      ),
      padding: EdgeInsets.only(
        top: AppConstants.spacingMd,
        left: AppConstants.spacingLg,
        right: AppConstants.spacingLg,
        bottom:
            MediaQuery.of(context).viewInsets.bottom + AppConstants.spacingLg,
      ),
      child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Drag handle
            Center(
              child: Container(
                width: 48,
                height: 4,
                decoration: BoxDecoration(
                  color: AppColors.border,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),
            const SizedBox(height: AppConstants.spacingLg),
            Text(context.l10n.searchFiltersTitle, style: AppTextStyles.h2),
            const SizedBox(height: AppConstants.spacingLg),

            // Transaction type
            Text(context.l10n.filterTransactionType, style: AppTextStyles.title),
            const SizedBox(height: AppConstants.spacingSm),
            Row(
              children: [
                _buildTypeChip('all', context.l10n.commonAll),
                const SizedBox(width: AppConstants.spacingSm),
                _buildTypeChip('sale', context.l10n.propertyBadgeSale),
                const SizedBox(width: AppConstants.spacingSm),
                _buildTypeChip('rent', context.l10n.propertyBadgeRent),
              ],
            ),
            const SizedBox(height: AppConstants.spacingLg),

            // Category
            Text(context.l10n.filterCategory, style: AppTextStyles.title),
            const SizedBox(height: AppConstants.spacingSm),
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: [
                  _buildCategoryChip('all', context.l10n.commonAll),
                  const SizedBox(width: AppConstants.spacingSm),
                  _buildCategoryChip(
                      'Appartement', context.l10n.propertyTypeApartment),
                  const SizedBox(width: AppConstants.spacingSm),
                  _buildCategoryChip('Villa', context.l10n.propertyTypeVilla),
                  const SizedBox(width: AppConstants.spacingSm),
                  _buildCategoryChip('Terrain', context.l10n.propertyTypeLand),
                  const SizedBox(width: AppConstants.spacingSm),
                  _buildCategoryChip('Studio', context.l10n.propertyTypeStudio),
                ],
              ),
            ),
            const SizedBox(height: AppConstants.spacingLg),

            // Wilaya picker
            Text(context.l10n.filterWilaya, style: AppTextStyles.title),
            const SizedBox(height: AppConstants.spacingSm),
            Obx(() {
              final wilayas = _controller.wilayas;
              if (wilayas.isEmpty) {
                // Fallback chips while loading or if API failed
                return SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: [
                      _buildWilayaChip(null, context.l10n.commonAllF),
                      const SizedBox(width: AppConstants.spacingSm),
                      // show current selection label if set
                      if (_wilayaId != null)
                        _buildWilayaChip(
                            _wilayaId, '${context.l10n.filterWilaya} #$_wilayaId'),
                    ],
                  ),
                );
              }
              return SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: [
                    _buildWilayaChip(null, context.l10n.commonAllF),
                    ...wilayas.map((w) => Padding(
                          padding: const EdgeInsets.only(
                              left: AppConstants.spacingSm),
                          child: _buildWilayaChip(w.id, w.name),
                        )),
                  ],
                ),
              );
            }),
            const SizedBox(height: AppConstants.spacingLg),

            // Price range
            Text(context.l10n.filterBudget, style: AppTextStyles.title),
            const SizedBox(height: AppConstants.spacingSm),
            Row(
              children: [
                Expanded(
                  child: TextFormField(
                    controller: _minPriceController,
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                      labelText: context.l10n.filterPriceMin,
                      hintText: context.l10n.filterPriceMinHint,
                      prefixIcon: const Icon(Icons.remove, size: 14),
                    ),
                  ),
                ),
                const SizedBox(width: AppConstants.spacingMd),
                Expanded(
                  child: TextFormField(
                    controller: _maxPriceController,
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                      labelText: context.l10n.filterPriceMax,
                      hintText: context.l10n.filterPriceMaxHint,
                      prefixIcon: const Icon(Icons.add, size: 14),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: AppConstants.spacingLg),

            // Bedrooms + Area
            Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(context.l10n.filterBedroomsMin,
                          style: AppTextStyles.title),
                      const SizedBox(height: AppConstants.spacingSm),
                      Row(
                        children: [
                          IconButton.filledTonal(
                            onPressed: _bedrooms > 0
                                ? () => setState(() => _bedrooms--)
                                : null,
                            icon: const Icon(Icons.remove, size: 16),
                          ),
                          Padding(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 16),
                            child: Text(
                              '$_bedrooms+',
                              style:
                                  AppTextStyles.title.copyWith(fontSize: 16),
                            ),
                          ),
                          IconButton.filledTonal(
                            onPressed: () => setState(() => _bedrooms++),
                            icon: const Icon(Icons.add, size: 16),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: AppConstants.spacingLg),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(context.l10n.filterAreaMin,
                          style: AppTextStyles.title),
                      const SizedBox(height: AppConstants.spacingSm),
                      TextFormField(
                        controller: _minAreaController,
                        keyboardType: TextInputType.number,
                        decoration: InputDecoration(
                          hintText: context.l10n.filterAreaHint,
                          prefixIcon: const Icon(Icons.straighten, size: 16),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: AppConstants.spacingXl),

            // Actions
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: _reset,
                    style: OutlinedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      side: const BorderSide(color: AppColors.border),
                      shape: const StadiumBorder(),
                    ),
                    child: Text(
                      context.l10n.searchResetFilters,
                      style: AppTextStyles.button
                          .copyWith(color: AppColors.textPrimary),
                    ),
                  ),
                ),
                const SizedBox(width: AppConstants.spacingMd),
                Expanded(
                  child: SizedBox(
                    height: 52,
                    child: DecoratedBox(
                      decoration: ShapeDecoration(
                        gradient: AppGradients.purpleFade,
                        shape: const StadiumBorder(),
                      ),
                      child: Material(
                        color: Colors.transparent,
                        shape: const StadiumBorder(),
                        child: InkWell(
                          onTap: _apply,
                          borderRadius: BorderRadius.circular(
                              AppConstants.radiusPill),
                          child: Center(
                            child: Text(context.l10n.commonApply,
                                style: AppTextStyles.button),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: AppConstants.spacingSm),
          ],
        ),
      ),
    );
  }

  Widget _buildTypeChip(String type, String label) => AppChip(
        label: label,
        selected: _type == type,
        onTap: () => setState(() => _type = type),
      );

  Widget _buildCategoryChip(String category, String label) => AppChip(
        label: label,
        selected: _category == category,
        onTap: () => setState(() => _category = category),
      );

  Widget _buildWilayaChip(int? id, String label) => AppChip(
        label: label,
        selected: _wilayaId == id,
        onTap: () => setState(() => _wilayaId = id),
      );
}
