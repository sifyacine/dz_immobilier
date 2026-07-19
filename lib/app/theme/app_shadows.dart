import 'package:flutter/material.dart';

/// Elevation tokens — layered, ink-tinted (Federal) shadows plus the violet
/// [glow] reserved for the primary call to action.
///
/// ```dart
/// Container(decoration: BoxDecoration(boxShadow: AppShadows.md, ...))
/// ```
class AppShadows {
  AppShadows._();

  /// xs · 1px ambient hairline.
  static const List<BoxShadow> xs = [
    BoxShadow(color: Color(0x0A0A0A41), blurRadius: 2, offset: Offset(0, 1)),
  ];

  /// sm · card resting.
  static const List<BoxShadow> sm = [
    BoxShadow(color: Color(0x0F0A0A41), blurRadius: 8, offset: Offset(0, 2)),
  ];

  /// md · hover lift.
  static const List<BoxShadow> md = [
    BoxShadow(color: Color(0x1A0A0A41), blurRadius: 16, offset: Offset(0, 6)),
  ];

  /// lg · modal / bottom sheet.
  static const List<BoxShadow> lg = [
    BoxShadow(color: Color(0x290A0A41), blurRadius: 32, offset: Offset(0, 12)),
  ];

  /// glow · primary CTA (violet halo).
  static const List<BoxShadow> glow = [
    BoxShadow(color: Color(0x4D7F00FD), blurRadius: 24, offset: Offset(0, 8)),
  ];
}
