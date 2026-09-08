import 'package:flutter/material.dart';

import '../../../theme/app_theme.dart';

/// Everything here either aliases a shared [AppColors] token or adds a value
class SettingsColors {
  SettingsColors._();
  static const white = AppColors.white;
  static const mutedText = AppColors.mutedText;
  static const faintText = AppColors.faintText;
  static const soft = AppColors.soft;
  static const bright = Color(0xFFEAF8FF);
  static const cardFill = Color(0x1FFFFFFF);
  static const cardFillStrong = Color(0x2EFFFFFF);
  static const cardBorder = Color(0x33FFFFFF);
  static const rowDivider = Color(0x1AFFFFFF);
  static const connectorBorder = Color(0x42FFFFFF);
  static const pillFill = Color(0x1FFFFFFF);
  static const pillFillSelected = Color(0x4D5FE0FF);
  static const pillBorder = Color(0x38FFFFFF);
  static const pillBorderSelected = Color(0x6BFFFFFF);
  static const statusConnected = AppColors.good;
  static const statusNotConnected = Color(0x73FFFFFF);
  static const danger = Color(0xFFFFB9AE);
  static const critical = AppColors.critDot;
  static const warning = AppColors.warnDot;
  static const accent = AppColors.accent;
}
