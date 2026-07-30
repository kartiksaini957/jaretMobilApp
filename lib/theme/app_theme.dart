import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

/// Colors and text styles for the LightSignal "aurora glass" look shared by
/// every screen: a vivid cyan/blue layered gradient background with frosted
/// glass surfaces (cards, inputs, chips, buttons) floating on top of it.
class AppColors {
  AppColors._();

  // Base diagonal gradient behind everything.
  static const Color baseDeep = Color(0xFF064A63);
  static const Color baseMid = Color(0xFF05688A);
  static const Color baseLight = Color(0xFF0892C0);

  // Soft glow blobs layered over the base gradient.
  static const Color blobCyan = Color(0xFF2BD4FF);
  static const Color blobBlueA = Color(0xFF18A8DC);
  static const Color blobBlueB = Color(0xFF0E9ED0);
  static const Color blobBlueC = Color(0xFF1AAEDE);
  static const Color blobAqua = Color(0xFF4FE2FF);

  static const Color white = Colors.white;
  static const Color mutedText = Color(0xE6FFFFFF);
  static const Color faintText = Color(0xB3FFFFFF);

  /// Icy highlight used for accented headline text, links, focus rings.
  static const Color accent = Color(0xFFCFF7FF);

  static const Color yellow = Color(0xFFFFD98A);

  /// Positive/good-news indicator text (e.g. "outpacing by 30%").
  static const Color goodText = Color(0xFFA6F5DC);

  /// Urgent/overdue indicator (notification badge dot, overdue reminders).
  static const Color urgent = Color(0xFFFF5A5F);

  // Shared frosted-glass surface tokens — reused by cards, inputs, chips,
  // and buttons so every screen reads as one consistent system.
  static const Color glassLight = Color(0x29FFFFFF);
  static const Color glassDark = Color(0x33062230);
  static const Color glassBorder = Color(0x4DFFFFFF);
  static const Color glassBorderSoft = Color(0x26FFFFFF);
}

class AppTextStyles {
  AppTextStyles._();

  static const String fontFamily = 'Roboto';

  static const TextStyle logo = TextStyle(
    color: AppColors.white,
    fontSize: 18,
    fontWeight: FontWeight.w700,
    letterSpacing: 0.2,
  );

  static const TextStyle eyebrow = TextStyle(
    color: AppColors.faintText,
    fontSize: 12,
    fontWeight: FontWeight.w700,
    letterSpacing: 1.2,
  );

  // Layered text-shadow matching the reference .h1 style: a tight dark
  // contact shadow, a wider soft dark shadow for depth, and a cyan glow.
  static const List<Shadow> _headlineShadows = [
    Shadow(offset: Offset(0, 1), blurRadius: 2, color: Color(0xB304303F)),
    Shadow(offset: Offset(0, 2), blurRadius: 12, color: Color(0x8004303F)),
    Shadow(offset: Offset(0, 2), blurRadius: 22, color: Color(0x595FE0FF)),
  ];

  static TextStyle get headline => GoogleFonts.spaceGrotesk(
        color: AppColors.white,
        fontSize: 27,
        fontWeight: FontWeight.w700,
        height: 1.16,
        letterSpacing: -0.4,
        shadows: _headlineShadows,
      );

  static TextStyle get headlineAccent => GoogleFonts.spaceGrotesk(
        color: AppColors.accent,
        fontSize: 27,
        fontWeight: FontWeight.w700,
        height: 1.16,
        letterSpacing: -0.4,
        shadows: _headlineShadows,
      );

  static const TextStyle body = TextStyle(
    color: AppColors.mutedText,
    fontSize: 14.5,
    fontWeight: FontWeight.w400,
    height: 1.45,
  );

  static const TextStyle small = TextStyle(
    color: AppColors.faintText,
    fontSize: 12.5,
    fontWeight: FontWeight.w500,
    height: 1.4,
  );

  static const TextStyle buttonLabel = TextStyle(
    color: AppColors.white,
    fontSize: 16,
    fontWeight: FontWeight.w700,
  );

  static const TextStyle link = TextStyle(
    color: AppColors.white,
    fontSize: 13.5,
    fontWeight: FontWeight.w600,
  );
}

ThemeData buildAppTheme() {
  final base = ThemeData.dark(useMaterial3: true);
  return base.copyWith(
    scaffoldBackgroundColor: AppColors.baseDeep,
    colorScheme: base.colorScheme.copyWith(
      primary: AppColors.accent,
      surface: AppColors.baseDeep,
    ),
    textSelectionTheme: const TextSelectionThemeData(
      cursorColor: AppColors.accent,
      selectionColor: Color(0x552BD4FF),
      selectionHandleColor: AppColors.accent,
    ),
  );
}
