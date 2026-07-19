import 'dart:ui';

import 'package:flutter/material.dart';

import '../../app/constants/app_constants.dart';

/// Frosted translucent card for premium surfaces sitting on a gradient/photo.
/// Comes in a [GlassVariant.light] and a [GlassVariant.dark] finish.
///
/// ```dart
/// GlassCard(child: Text('Estimation officielle'))
/// GlassCard(variant: GlassVariant.dark, child: Text('ML confidence'))
/// ```
enum GlassVariant { light, dark }

class GlassCard extends StatelessWidget {
  const GlassCard({
    super.key,
    required this.child,
    this.variant = GlassVariant.light,
    this.padding = const EdgeInsets.all(AppConstants.spacingLg),
    this.blur = 18,
  });

  final Widget child;
  final GlassVariant variant;
  final EdgeInsets padding;
  final double blur;

  @override
  Widget build(BuildContext context) {
    final isDark = variant == GlassVariant.dark;
    final radius = BorderRadius.circular(AppConstants.radiusMd);
    return ClipRRect(
      borderRadius: radius,
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: blur, sigmaY: blur),
        child: Container(
          padding: padding,
          decoration: BoxDecoration(
            color: (isDark ? Colors.black : Colors.white)
                .withValues(alpha: isDark ? 0.28 : 0.30),
            borderRadius: radius,
            border: Border.all(
              color: Colors.white.withValues(alpha: isDark ? 0.18 : 0.45),
              width: 1,
            ),
          ),
          child: child,
        ),
      ),
    );
  }
}
