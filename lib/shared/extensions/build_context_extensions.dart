import 'package:flutter/widgets.dart';

/// Convenience accessors for screen metrics, keeping `MediaQuery.of(context)`
/// noise out of widgets.
extension BuildContextX on BuildContext {
  Size get screenSize => MediaQuery.sizeOf(this);
  double get screenWidth => screenSize.width;
  double get screenHeight => screenSize.height;
  EdgeInsets get viewPadding => MediaQuery.viewPaddingOf(this);
  bool get isDarkMode =>
      MediaQuery.platformBrightnessOf(this) == Brightness.dark;
}
