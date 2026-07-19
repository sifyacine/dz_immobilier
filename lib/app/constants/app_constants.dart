import 'package:flutter/widgets.dart';

/// App-wide non-API constants: naming, spacing scale, radii, durations.
class AppConstants {
  AppConstants._();

  static const String appName = 'DZ Immobilier';
  static const String websiteUrl = 'https://dz-immobilier.com';

  // Spacing scale
  static const double spacingXs = 4;
  static const double spacingSm = 8;
  static const double spacingMd = 16;
  static const double spacingLg = 24;
  static const double spacingXl = 32;

  // Corner radii (design scale)
  static const double radiusXs = 8; // chips
  static const double radiusSm = 12;
  static const double radiusMd = 16; // canonical ★ (cards, tiles)
  static const double radiusLg = 24; // modal / sheet
  static const double radiusXl = 32;
  static const double radiusPill = 999;

  // Common paddings
  static const EdgeInsets pagePadding = EdgeInsets.all(spacingMd);

  // Motion
  static const Duration animationDuration = Duration(milliseconds: 300);

  // Pagination
  static const int pageSize = 20;
}
