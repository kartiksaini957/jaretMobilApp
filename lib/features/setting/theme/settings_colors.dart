import 'package:flutter/material.dart';

/// Colors for the Settings screen — reuses the shared aurora-glass tokens
/// with a couple of settings-specific status/action accents.
class SettingsColors {
  SettingsColors._();

  static const white = Colors.white;
  static const mutedText = Color(0xE6FFFFFF);
  static const faintText = Color(0xB3FFFFFF);

  static const cardFill = Color(0x1FFFFFFF);
  static const cardFillStrong = Color(0x2EFFFFFF);
  static const cardBorder = Color(0x33FFFFFF);

  static const pillFill = Color(0x1FFFFFFF);
  static const pillFillSelected = Color(0x40FFFFFF);
  static const pillBorder = Color(0x33FFFFFF);
  static const pillBorderSelected = Color(0x99FFFFFF);

  static const statusConnected = Color(0xFF6FDB6C);
  static const statusNotConnected = Color(0xB3FFFFFF);
  static const danger = Color(0xFFFF5A5F);
  static const accent = Color(0xFFCFF7FF);
}
