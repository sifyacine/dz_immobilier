import 'package:flutter/material.dart';

import '../../../app/constants/app_constants.dart';
import '../../../shared/widgets/app_shimmer.dart';

/// Skeleton placeholder matching [PropertyCard]'s layout, shown while listings
/// load. The shimmer lives inside the white card so only the skeleton boxes
/// sweep (grey bars on white) rather than the whole card becoming one block.
class PropertyCardSkeleton extends StatelessWidget {
  const PropertyCardSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: AppShimmer(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Image
            const AspectRatio(
              aspectRatio: 16 / 10,
              child: ShimmerBox(
                height: double.infinity,
                radius: AppConstants.radiusMd,
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(AppConstants.spacingMd),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: const [
                  ShimmerBox(width: 140, height: 18), // price
                  SizedBox(height: 10),
                  ShimmerBox(width: double.infinity, height: 14), // title
                  SizedBox(height: 8),
                  ShimmerBox(width: 180, height: 12), // location
                  SizedBox(height: AppConstants.spacingMd),
                  Row(
                    children: [
                      ShimmerBox(width: 44, height: 12),
                      SizedBox(width: 16),
                      ShimmerBox(width: 44, height: 12),
                      SizedBox(width: 16),
                      ShimmerBox(width: 60, height: 12),
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
