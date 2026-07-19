import 'package:flutter/material.dart';

/// Central color palette (DZ Immobilier brand). Reference these everywhere
/// instead of hard-coding `Color(0x...)` so the brand stays consistent.
class AppColors {
  AppColors._();

  // ── Brand ────────────────────────────────────────────────────────────
  static const Color violet = Color(0xFF7F00FD); // brand / primary
  static const Color federal = Color(0xFF0A0A41); // ink / dark
  static const Color magenta = Color(0xFFD640FF); // accent
  static const Color heliotrope = Color(0xFFE565FF); // light accent

  // Semantic aliases used across the app
  static const Color primary = violet;
  static const Color primaryDark = Color(0xFF6400C8); // darker violet (pressed)
  static const Color ink = federal;
  static const Color accent = magenta;
  static const Color accentLight = heliotrope;

  // ── Neutrals (light) ─────────────────────────────────────────────────
  static const Color background = Color(0xFFF8FAFC);
  static const Color surface = Color(0xFFFFFFFF);
  static const Color card = Color(0xFFFFFFFF);

  // ── Text (light) ─────────────────────────────────────────────────────
  static const Color textPrimary = federal;
  static const Color textSecondary = Color(0xFF475569);
  static const Color textHint = Color(0xFF94A3B8);
  static const Color textOnPrimary = Color(0xFFFFFFFF);

  // ── Status / semantic ────────────────────────────────────────────────
  static const Color success = Color(0xFF1F8A5B);
  static const Color warning = Color(0xFFC2820B);
  static const Color error = Color(0xFFD11A4A); // "Danger"
  static const Color info = violet;

  // ── Surface tints (badge / chip / ghost backgrounds) ─────────────────
  static const Color violetSurface = Color(0xFFF1E6FE);
  static const Color successSurface = Color(0xFFE3F5EC);
  static const Color warningSurface = Color(0xFFFBF1DC);
  static const Color errorSurface = Color(0xFFFCE4EA);

  // ── Borders / dividers ───────────────────────────────────────────────
  static const Color border = Color(0xFFE2E8F0);
  static const Color divider = Color(0xFFE2E8F0);

  // ── Dark theme ───────────────────────────────────────────────────────
  static const Color darkBackground = federal; // #0A0A41
  static const Color darkSurface = Color(0xFF12123F);
  static const Color darkCard = Color(0xFF1B1B57);
  static const Color darkTextPrimary = Color(0xFFF1F5F9);
  static const Color darkTextSecondary = Color(0xFFA5A5C8);
}
