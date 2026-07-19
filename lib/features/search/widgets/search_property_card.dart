import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import '../../../app/constants/app_constants.dart';
import '../../../app/theme/app_colors.dart';
import '../../../app/theme/app_text_styles.dart';
import '../../../data/models/property_model.dart';
import '../../../shared/extensions/l10n_extension.dart';
import '../../favorites/controllers/favorites_controller.dart';

class SearchPropertyCard extends StatelessWidget {
  final Property property;
  final VoidCallback? onTap;

  const SearchPropertyCard({
    super.key,
    required this.property,
    this.onTap,
  });

  String _formattedPrice(BuildContext context) {
    final value = NumberFormat.decimalPattern('fr').format(property.price);
    return property.isRent
        ? '$value ${property.currency}${context.l10n.commonPerMonth}'
        : '$value ${property.currency}';
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final cardBg = isDark ? AppColors.darkCard : AppColors.surface;
    final textPrimary =
        isDark ? AppColors.darkTextPrimary : AppColors.textPrimary;
    final textSecondary =
        isDark ? AppColors.darkTextSecondary : AppColors.textSecondary;
    final favoritesController = Get.find<FavoritesController>();

    return Container(
      decoration: BoxDecoration(
        color: cardBg,
        borderRadius: BorderRadius.circular(AppConstants.radiusMd),
        boxShadow: const [
          BoxShadow(
            color: Color(0x0A000000),
            blurRadius: 8,
            offset: Offset(0, 3),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(AppConstants.radiusMd),
        child: InkWell(
          onTap: onTap,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Image container
              AspectRatio(
                aspectRatio: 1.1,
                child: Stack(
                  fit: StackFit.expand,
                  children: [
                    if (property.thumbnail != null)
                      CachedNetworkImage(
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
                    else
                      Container(color: AppColors.border),

                    // Heart button overlay
                    Positioned(
                      top: 6,
                      right: 6,
                      child: Obx(() {
                        final isFav = favoritesController.isFavorite(property.id);
                        return Material(
                          color: Colors.black.withValues(alpha: 0.35),
                          shape: const CircleBorder(),
                          clipBehavior: Clip.antiAlias,
                          child: IconButton(
                            icon: Icon(
                              isFav ? Icons.favorite : Icons.favorite_border,
                              color: isFav ? AppColors.error : Colors.white,
                              size: 18,
                            ),
                            constraints: const BoxConstraints(
                              minWidth: 32,
                              minHeight: 32,
                            ),
                            padding: EdgeInsets.zero,
                            onPressed: () => favoritesController.toggle(property),
                          ),
                        );
                      }),
                    ),

                    // Type tag overlay
                    Positioned(
                      bottom: 6,
                      left: 6,
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 8, vertical: 3),
                        decoration: BoxDecoration(
                          color: property.isRent
                              ? AppColors.accent
                              : AppColors.primary,
                          borderRadius:
                              BorderRadius.circular(AppConstants.radiusPill),
                        ),
                        child: Text(
                          property.isRent
                              ? context.l10n.propertyBadgeRent
                              : context.l10n.propertyBadgeSale,
                          style: AppTextStyles.caption.copyWith(
                            color: Colors.white,
                            fontSize: 10,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              // Property details
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(AppConstants.spacingSm),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            _formattedPrice(context),
                            style: AppTextStyles.price.copyWith(
                              fontSize: 13,
                              fontWeight: FontWeight.w700,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                          const SizedBox(height: 2),
                          Text(
                            property.title,
                            style: AppTextStyles.title
                                .copyWith(fontSize: 12, color: textPrimary),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Icon(Icons.location_on_outlined,
                                  size: 11, color: textSecondary),
                              const SizedBox(width: 2),
                              Expanded(
                                child: Text(
                                  property.city,
                                  style: AppTextStyles.caption
                                      .copyWith(fontSize: 10, color: textSecondary),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 2),
                          // Compact specs row
                          Text(
                            context.l10n.propertyCardSpecs(
                                property.bedrooms, property.area.toInt()),
                            style: AppTextStyles.caption.copyWith(
                              fontSize: 10,
                              fontWeight: FontWeight.w500,
                              color: textSecondary,
                            ),
                          ),
                        ],
                      ),
                    ],
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
