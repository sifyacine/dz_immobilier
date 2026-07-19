import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:latlong2/latlong.dart' hide Path;

import '../../../app/constants/app_constants.dart';
import '../../../app/routes/app_routes.dart';
import '../../../app/theme/app_colors.dart';
import '../../../app/theme/app_gradients.dart';
import '../../../app/theme/app_text_styles.dart';
import '../../../data/models/property_model.dart';
import '../../../shared/data/wilaya_coordinates.dart';
import '../../../shared/extensions/l10n_extension.dart';

/// Full-screen map representation of a set of listings, grouped by wilaya
/// centroid (listings have no per-property coordinates). Tapping a marker
/// opens a sheet with the listings in that wilaya.
class PropertiesMapView extends StatelessWidget {
  final List<Property> properties;
  const PropertiesMapView({super.key, required this.properties});

  @override
  Widget build(BuildContext context) {
    // Group by resolvable wilaya centroid.
    final groups = <LatLng, List<Property>>{};
    var offMap = 0;
    for (final p in properties) {
      final point = WilayaCoordinates.of(p.city);
      if (point == null) {
        offMap++;
        continue;
      }
      (groups[point] ??= []).add(p);
    }

    final points = groups.keys.toList();

    return Scaffold(
      body: Stack(
        children: [
          FlutterMap(
            options: MapOptions(
              initialCenter:
                  points.isNotEmpty ? points.first : WilayaCoordinates.algeriaCenter,
              initialZoom: points.length == 1 ? 11 : 5.2,
              initialCameraFit: points.length > 1
                  ? CameraFit.coordinates(
                      coordinates: points,
                      padding: const EdgeInsets.all(64),
                      maxZoom: 12,
                    )
                  : null,
              interactionOptions: const InteractionOptions(
                flags: InteractiveFlag.all & ~InteractiveFlag.rotate,
              ),
            ),
            children: [
              TileLayer(
                urlTemplate:
                    'https://{s}.basemaps.cartocdn.com/rastertiles/voyager/{z}/{x}/{y}.png',
                subdomains: const ['a', 'b', 'c', 'd'],
                userAgentPackageName: 'com.dzimmobilier.app',
              ),
              MarkerLayer(
                markers: [
                  for (final entry in groups.entries)
                    Marker(
                      point: entry.key,
                      width: 120,
                      height: 56,
                      alignment: Alignment.topCenter,
                      child: _WilayaMarker(
                        count: entry.value.length,
                        onTap: () => _showGroup(context, entry.value),
                      ),
                    ),
                ],
              ),
            ],
          ),

          // ── Top bar (back + title) ──────────────────────────────────────
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(AppConstants.spacingMd),
              child: Row(
                children: [
                  _CircleButton(
                    icon: Icons.arrow_back,
                    onTap: Get.back,
                  ),
                  const SizedBox(width: AppConstants.spacingSm),
                  Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 14, vertical: 8),
                    decoration: BoxDecoration(
                      color: AppColors.surface,
                      borderRadius:
                          BorderRadius.circular(AppConstants.radiusPill),
                      boxShadow: const [
                        BoxShadow(
                            color: Color(0x14000000),
                            blurRadius: 10,
                            offset: Offset(0, 2)),
                      ],
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(Icons.map_outlined,
                            size: 16, color: AppColors.primary),
                        const SizedBox(width: 6),
                        Text(
                          context.l10n.mapResultsCount(properties.length),
                          style: AppTextStyles.caption
                              .copyWith(fontWeight: FontWeight.w700),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),

          // ── Off-map notice ──────────────────────────────────────────────
          if (offMap > 0)
            Positioned(
              left: AppConstants.spacingMd,
              right: AppConstants.spacingMd,
              bottom: AppConstants.spacingMd,
              child: Container(
                padding: const EdgeInsets.symmetric(
                    horizontal: 14, vertical: 10),
                decoration: BoxDecoration(
                  color: AppColors.surface,
                  borderRadius: BorderRadius.circular(AppConstants.radiusMd),
                  boxShadow: const [
                    BoxShadow(
                        color: Color(0x14000000),
                        blurRadius: 10,
                        offset: Offset(0, 2)),
                  ],
                ),
                child: Row(
                  children: [
                    const Icon(Icons.info_outline,
                        size: 16, color: AppColors.textSecondary),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        context.l10n.mapOffMap(offMap),
                        style: AppTextStyles.caption
                            .copyWith(color: AppColors.textSecondary),
                      ),
                    ),
                  ],
                ),
              ),
            ),
        ],
      ),
    );
  }

  void _showGroup(BuildContext context, List<Property> group) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (_) => _GroupSheet(properties: group),
    );
  }
}

// ── Marker ────────────────────────────────────────────────────────────────────

class _WilayaMarker extends StatelessWidget {
  final int count;
  final VoidCallback onTap;
  const _WilayaMarker({required this.count, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 7),
            decoration: BoxDecoration(
              gradient: AppGradients.purpleFade,
              borderRadius: BorderRadius.circular(AppConstants.radiusPill),
              border: Border.all(color: Colors.white, width: 2),
              boxShadow: [
                BoxShadow(
                  color: AppColors.primary.withValues(alpha: 0.35),
                  blurRadius: 8,
                  offset: const Offset(0, 3),
                ),
              ],
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(Icons.home_rounded, size: 14, color: Colors.white),
                const SizedBox(width: 5),
                Text('$count',
                    style: AppTextStyles.caption.copyWith(
                        color: Colors.white, fontWeight: FontWeight.w800)),
              ],
            ),
          ),
          // Little pointer triangle.
          CustomPaint(size: const Size(14, 7), painter: _PinTail()),
        ],
      ),
    );
  }
}

class _PinTail extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..color = AppColors.violet;
    final path = Path()
      ..moveTo(0, 0)
      ..lineTo(size.width, 0)
      ..lineTo(size.width / 2, size.height)
      ..close();
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

// ── Group sheet ───────────────────────────────────────────────────────────────

class _GroupSheet extends StatelessWidget {
  final List<Property> properties;
  const _GroupSheet({required this.properties});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final surface = isDark ? AppColors.darkSurface : AppColors.surface;
    final city = properties.first.city;

    return DraggableScrollableSheet(
      initialChildSize: 0.5,
      minChildSize: 0.3,
      maxChildSize: 0.9,
      expand: false,
      builder: (context, scrollController) => Container(
        decoration: BoxDecoration(
          color: surface,
          borderRadius: const BorderRadius.vertical(
              top: Radius.circular(AppConstants.radiusLg)),
        ),
        child: Column(
          children: [
            const SizedBox(height: 10),
            Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: AppColors.border,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(AppConstants.spacingMd,
                  AppConstants.spacingMd, AppConstants.spacingMd, AppConstants.spacingSm),
              child: Row(
                children: [
                  const Icon(Icons.location_on, size: 18, color: AppColors.primary),
                  const SizedBox(width: 6),
                  Text(city, style: AppTextStyles.h3),
                  const SizedBox(width: 8),
                  Text(context.l10n.mapResultsCount(properties.length),
                      style: AppTextStyles.caption
                          .copyWith(color: AppColors.textSecondary)),
                ],
              ),
            ),
            Expanded(
              child: ListView.separated(
                controller: scrollController,
                padding: const EdgeInsets.fromLTRB(AppConstants.spacingMd, 0,
                    AppConstants.spacingMd, AppConstants.spacingMd),
                itemCount: properties.length,
                separatorBuilder: (_, _) => const Divider(height: 1),
                itemBuilder: (_, i) => _MapPropertyTile(property: properties[i]),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _MapPropertyTile extends StatelessWidget {
  final Property property;
  const _MapPropertyTile({required this.property});

  @override
  Widget build(BuildContext context) {
    final price = NumberFormat.decimalPattern('fr').format(property.price);
    return InkWell(
      onTap: () {
        Get.back(); // close sheet
        Get.toNamed(Routes.propertyDetail, arguments: property);
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 10),
        child: Row(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(AppConstants.radiusSm),
              child: SizedBox(
                width: 64,
                height: 64,
                child: property.thumbnail != null
                    ? Image.network(property.thumbnail!,
                        fit: BoxFit.cover,
                        errorBuilder: (_, _, _) => Container(
                            color: AppColors.border,
                            child: const Icon(Icons.home_outlined,
                                color: AppColors.textHint)))
                    : Container(
                        color: AppColors.border,
                        child: const Icon(Icons.home_outlined,
                            color: AppColors.textHint)),
              ),
            ),
            const SizedBox(width: AppConstants.spacingSm),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('$price ${property.currency}',
                      style: AppTextStyles.price.copyWith(fontSize: 15)),
                  const SizedBox(height: 2),
                  Text(property.title,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: AppTextStyles.body),
                  const SizedBox(height: 2),
                  Text(
                    '${property.category} · ${property.area.toInt()} m²',
                    style: AppTextStyles.caption
                        .copyWith(color: AppColors.textSecondary),
                  ),
                ],
              ),
            ),
            const Icon(Icons.chevron_right_rounded, color: AppColors.textHint),
          ],
        ),
      ),
    );
  }
}

// ── Shared little round button ────────────────────────────────────────────────

class _CircleButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback onTap;
  const _CircleButton({required this.icon, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Material(
      color: AppColors.surface,
      shape: const CircleBorder(),
      clipBehavior: Clip.antiAlias,
      elevation: 2,
      child: InkWell(
        onTap: onTap,
        child: SizedBox(
          width: 42,
          height: 42,
          child: Icon(icon, size: 20, color: AppColors.textPrimary),
        ),
      ),
    );
  }
}
