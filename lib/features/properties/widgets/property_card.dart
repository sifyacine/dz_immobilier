import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../../app/constants/app_constants.dart';
import '../../../app/theme/app_colors.dart';
import '../../../app/theme/app_text_styles.dart';
import '../../../data/models/property_model.dart';
import '../../../shared/extensions/l10n_extension.dart';

/// Listing card: image, sale/rent badge, price, title, location and key specs.
class PropertyCard extends StatelessWidget {
  final Property property;
  final VoidCallback? onTap;

  const PropertyCard({super.key, required this.property, this.onTap});

  String _formattedPrice(BuildContext context) {
    final value = NumberFormat.decimalPattern('fr').format(property.price);
    return property.isRent
        ? '$value ${property.currency}${context.l10n.commonPerMonth}'
        : '$value ${property.currency}';
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final textPrimary =
        isDark ? AppColors.darkTextPrimary : AppColors.textPrimary;
    final textSecondary =
        isDark ? AppColors.darkTextSecondary : AppColors.textSecondary;
    return Card(
      child: InkWell(
        onTap: onTap,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            AspectRatio(
              aspectRatio: 16 / 10,
              child: Stack(
                fit: StackFit.expand,
                children: [
                  if (property.thumbnail != null)
                    CachedNetworkImage(
                      imageUrl: property.thumbnail!,
                      fit: BoxFit.cover,
                      placeholder: (_, _) =>
                          Container(color: AppColors.border),
                      errorWidget: (_, _, _) => Container(
                        color: AppColors.border,
                        child: const Icon(Icons.home_outlined,
                            color: AppColors.textHint),
                      ),
                    )
                  else
                    Container(color: AppColors.border),
                  Positioned(
                    top: AppConstants.spacingSm,
                    left: AppConstants.spacingSm,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 10, vertical: 4),
                      decoration: BoxDecoration(
                        color:
                            property.isRent ? AppColors.accent : AppColors.primary,
                        borderRadius:
                            BorderRadius.circular(AppConstants.radiusPill),
                      ),
                      child: Text(
                        property.isRent
                            ? context.l10n.propertyBadgeRent
                            : context.l10n.propertyBadgeSale,
                        style: AppTextStyles.caption
                            .copyWith(color: Colors.white),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(AppConstants.spacingMd),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(_formattedPrice(context), style: AppTextStyles.price),
                  const SizedBox(height: 4),
                  Text(property.title,
                      style: AppTextStyles.title.copyWith(color: textPrimary),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      Icon(Icons.location_on_outlined,
                          size: 14, color: textSecondary),
                      const SizedBox(width: 4),
                      Expanded(
                        child: Text(property.address,
                            style: AppTextStyles.bodySecondary
                                .copyWith(color: textSecondary),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis),
                      ),
                    ],
                  ),
                  const SizedBox(height: AppConstants.spacingSm),
                  Row(
                    children: [
                      _Feature(
                          icon: Icons.bed_outlined,
                          label: '${property.bedrooms}',
                          color: textSecondary),
                      const SizedBox(width: 16),
                      _Feature(
                          icon: Icons.bathtub_outlined,
                          label: '${property.bathrooms}',
                          color: textSecondary),
                      const SizedBox(width: 16),
                      _Feature(
                          icon: Icons.straighten,
                          label: '${property.area.toInt()} m²',
                          color: textSecondary),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _Feature extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color color;
  const _Feature({required this.icon, required this.label, required this.color});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, size: 16, color: color),
        const SizedBox(width: 4),
        Text(label, style: AppTextStyles.bodySecondary.copyWith(color: color)),
      ],
    );
  }
}
