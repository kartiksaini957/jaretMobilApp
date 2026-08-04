import 'package:flutter/material.dart';

/// Standalone teal palette for the Business Health screen.
class BusinessHealthColors {
  BusinessHealthColors._();

  static const bgTop = Color(0xFF1FE0D2);
  static const bgBottom = Color(0xFF0C8F86);

  static const white = Colors.white;
  static const mutedText = Color(0xCCFFFFFF);
  static const faintText = Color(0xFFCFEFFB);

  static const cardFill = Color(0x26FFFFFF);
  static const cardDarkFill = Color(0x330B4A44);
  static const cardBorder = Color(0x33FFFFFF);

  // CYAN v2 tokens (LightSignalKit LSColor — locked design system).
  static const goodText = Color(0xFFA6F5DC); // --ls-goodText

  static const dotGood = Color(0xFF26C281); // goodDot
  static const dotNeutral = Color(0xB3FFFFFF);
  static const negativeText = Color(0xFFFF7A7A); // --ls-crit
  static const warnColor = Color(0xFFFFD466); // warnDot / --ls-warnText
  static const pillGoodBg = Color(0x3326C281); // dotGood @ 20%
  static const trackFill = Color(0x24FFFFFF);

  /// Solid backing for the snapshot-history bottom sheet.
  static const sheetBg = Color(0xFF08364C); // --ls-sheetSurface
}
