import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

/// Brand logo widget.
///
/// - [wordmark] = false (default) → icon-only mark (no text), use in nav bar,
///   app icon contexts, and small spaces.
/// - [wordmark] = true → full horizontal wordmark with text, use in app bars
///   and full-width header contexts.
///
/// Height defaults to 28 for app-bar use; override as needed.
class AppLogo extends StatelessWidget {
  final bool wordmark;
  final double height;
  final Color? color;

  const AppLogo({
    super.key,
    this.wordmark = false,
    this.height = 28,
    this.color,
  });

  static const _iconPath = 'assets/logo/logo-dz-immobilier-icon.svg';
  static const _wordmarkPath = 'assets/logo/logo-dz-immobilier-wordmark.svg';

  @override
  Widget build(BuildContext context) {
    return SvgPicture.asset(
      wordmark ? _wordmarkPath : _iconPath,
      height: height,
      colorFilter: color != null
          ? ColorFilter.mode(color!, BlendMode.srcIn)
          : null,
      semanticsLabel: wordmark ? 'DZ Immobilier' : 'DZ Immobilier icon',
    );
  }
}
