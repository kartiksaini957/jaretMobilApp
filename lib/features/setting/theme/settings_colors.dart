import 'package:flutter/material.dart';

import '../../../theme/app_theme.dart';

/// Colors for the Settings screen.
///
/// Everything here either aliases a shared [AppColors] token or adds a value
/// the v2 Settings reference introduces on top of it — nothing is a second
/// definition of a color the design system already owns.
class SettingsColors {
  SettingsColors._();

  static const white = AppColors.white;
  static const mutedText = AppColors.mutedText;
  static const faintText = AppColors.faintText;

  /// `--ls-soft` — row subtitles, group labels, secondary button text.
  static const soft = AppColors.soft;

  /// `--ls-bright: #EAF8FF` — the list-row text in `.trow`.
  static const bright = Color(0xFFEAF8FF);

  // Surfaces. The panel itself is [GlassCard]; these are the smaller fills
  // layered on top of it (dropdowns, inputs, connector cards).
  static const cardFill = Color(0x1FFFFFFF);
  static const cardFillStrong = Color(0x2EFFFFFF);
  static const cardBorder = Color(0x33FFFFFF);

  /// `border-top: 1px solid rgba(255,255,255,0.10)` between `.frow`s.
  static const rowDivider = Color(0x1AFFFFFF);

  /// `.concard { border: 1px solid rgba(255,255,255,0.26) }`
  static const connectorBorder = Color(0x42FFFFFF);

  // `.stab` pill tabs.
  static const pillFill = Color(0x1FFFFFFF);
  static const pillFillSelected = Color(0x4D5FE0FF);
  static const pillBorder = Color(0x38FFFFFF);
  static const pillBorderSelected = Color(0x6BFFFFFF);

  /// Connected / not-connected status dots — `--ls-good` and a dimmed white.
  static const statusConnected = AppColors.good;
  static const statusNotConnected = Color(0x73FFFFFF);

  /// `.gbtn.danger { color: #FFB9AE }`
  static const danger = Color(0xFFFFB9AE);

  /// Severity dots in the notification bell — `--red` / `--amber`.
  static const critical = AppColors.critDot;
  static const warning = AppColors.warnDot;

  static const accent = AppColors.accent;
}
