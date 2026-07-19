import 'package:flutter/material.dart';

import '../../app/theme/app_colors.dart';
import '../../app/theme/app_gradients.dart';
import '../../app/theme/app_text_styles.dart';

/// One entry in an [AmenityRibbon].
class AmenityItem {
  final IconData icon;
  final String label;
  const AmenityItem(this.icon, this.label);
}

/// Gradient pill listing a property's key amenities, separated by dividers.
/// Scrolls horizontally so it never overflows on small screens.
///
/// ```dart
/// AmenityRibbon(items: [
///   AmenityItem(Icons.place, 'Bordj El Kiffan'),
///   AmenityItem(Icons.meeting_room, '5 P'),
///   AmenityItem(Icons.local_parking, 'Parking'),
///   AmenityItem(Icons.waves, 'Vue mer'),
/// ])
/// ```
class AmenityRibbon extends StatelessWidget {
  const AmenityRibbon({super.key, required this.items});

  final List<AmenityItem> items;

  @override
  Widget build(BuildContext context) {
    final children = <Widget>[];
    for (var i = 0; i < items.length; i++) {
      if (i > 0) {
        children.add(Container(
          width: 1,
          height: 18,
          margin: const EdgeInsets.symmetric(horizontal: 12),
          color: Colors.white.withValues(alpha: 0.35),
        ));
      }
      children.add(
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(items[i].icon, size: 16, color: AppColors.textOnPrimary),
            const SizedBox(width: 6),
            Text(
              items[i].label,
              style: AppTextStyles.body.copyWith(
                  color: AppColors.textOnPrimary, fontWeight: FontWeight.w600),
            ),
          ],
        ),
      );
    }

    return DecoratedBox(
      decoration: const ShapeDecoration(
        shape: StadiumBorder(),
        gradient: AppGradients.purpleFade,
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 12),
        child: SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(children: children),
        ),
      ),
    );
  }
}
