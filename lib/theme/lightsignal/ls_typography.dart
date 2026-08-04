import 'package:flutter/widgets.dart';
import 'package:google_fonts/google_fonts.dart';

import 'ls_tokens.dart';

/// §5 Typography & two-tier text.
///
/// Display face is Space Grotesk (600/700), body is DM Sans (400/500/700).
/// Two tiers: white headlines/numbers POP with a strong glow; secondary text
/// is luminous brand-tint, never dim gray-white and never white-at-low-opacity.
class LsType {
  LsType._();

  /// `.darktext, .darktext *` — the baseline legibility shadow carried by
  /// every text-bearing surface.
  static const List<Shadow> darktext = <Shadow>[
    Shadow(offset: Offset(0, 1), blurRadius: 1.5, color: Color(0x66001220)),
  ];

  /// `.pop` — headlines, big numbers, section-head titles.
  static const List<Shadow> pop = <Shadow>[
    Shadow(offset: Offset(0, 1), blurRadius: 2, color: Color(0x80001220)),
    Shadow(offset: Offset(0, 0), blurRadius: 16, color: Color(0x73001E32)),
  ];

  static TextStyle _display({
    required double fontSize,
    required FontWeight fontWeight,
    required Color color,
    double? letterSpacing,
    double? height,
    List<Shadow>? shadows,
  }) {
    return GoogleFonts.spaceGrotesk(
      fontSize: fontSize,
      fontWeight: fontWeight,
      color: color,
      letterSpacing: letterSpacing,
      height: height,
      shadows: shadows,
      fontFeatures: const [FontFeature.tabularFigures()],
    );
  }

  static TextStyle _body({
    required double fontSize,
    required FontWeight fontWeight,
    required Color color,
    double? letterSpacing,
    double? height,
    List<Shadow>? shadows,
  }) {
    return GoogleFonts.dmSans(
      fontSize: fontSize,
      fontWeight: fontWeight,
      color: color,
      letterSpacing: letterSpacing,
      height: height,
      shadows: shadows,
    );
  }

  // ── Type role scale (§5) ──────────────────────────────────────────────
  // Sizes given as clamp() ranges are resolved responsively by
  // [LsResponsiveType.scale]; the roles below take the resolved size.

  /// Display XL (hero headline) — clamp(26–42px), 700, fg + `.pop`.
  static TextStyle displayXl({double fontSize = 42}) => _display(
        fontSize: fontSize,
        fontWeight: FontWeight.w700,
        color: LsColors.fg,
        letterSpacing: fontSize * -0.025,
        height: 1.08,
        shadows: pop,
      );

  /// Display L (greeting / page title) — clamp(26–34px), 600, fg + `.pop`.
  static TextStyle displayL({double fontSize = 34}) => _display(
        fontSize: fontSize,
        fontWeight: FontWeight.w600,
        color: LsColors.fg,
        letterSpacing: fontSize * -0.02,
        height: 1.14,
        shadows: pop,
      );

  /// Section head — 19px, 600, fg + `.pop`.
  static TextStyle get sectionHead => _display(
        fontSize: 19,
        fontWeight: FontWeight.w600,
        color: LsColors.fg,
        letterSpacing: -0.2,
        height: 1.25,
        shadows: pop,
      );

  /// Stat number — large: 44–46px, 700, fg + `.pop`.
  static TextStyle statLarge({double fontSize = 44}) => _display(
        fontSize: fontSize,
        fontWeight: FontWeight.w700,
        color: LsColors.fg,
        letterSpacing: fontSize * -0.025,
        height: 1.0,
        shadows: pop,
      );

  /// Stat number — standard: 30–32px, 700, fg + `.pop`.
  static TextStyle statStandard({double fontSize = 30}) => _display(
        fontSize: fontSize,
        fontWeight: FontWeight.w700,
        color: LsColors.fg,
        letterSpacing: fontSize * -0.02,
        height: 1.05,
        shadows: pop,
      );

  /// Body / lede — 15–17px, 400, soft.
  static TextStyle body({double fontSize = 15}) => _body(
        fontSize: fontSize,
        fontWeight: FontWeight.w400,
        color: LsColors.soft,
        height: 1.5,
        shadows: darktext,
      );

  /// Item title — 16px, 600 (700 if urgent), fg (+ `.pop` if urgent).
  static TextStyle itemTitle({bool urgent = false}) => _body(
        fontSize: 16,
        fontWeight: urgent ? FontWeight.w700 : FontWeight.w600,
        color: LsColors.fg,
        height: 1.35,
        shadows: urgent ? pop : darktext,
      );

  /// Eyebrow / label — 11.5–12.5px, .05–.09em tracking, uppercase, 600–700,
  /// soft.
  static TextStyle eyebrow({
    double fontSize = 11.5,
    double tracking = 0.09,
    FontWeight fontWeight = FontWeight.w700,
  }) =>
      _body(
        fontSize: fontSize,
        fontWeight: fontWeight,
        color: LsColors.soft,
        letterSpacing: fontSize * tracking,
        height: 1.2,
        shadows: darktext,
      );

  /// Meta / sublabel — 12–13px, 400/500, mute.
  ///
  /// `--ls-mute` is decorative / large-text only, which is why this role
  /// exists separately from [body].
  static TextStyle meta({
    double fontSize = 12,
    FontWeight fontWeight = FontWeight.w500,
  }) =>
      _body(
        fontSize: fontSize,
        fontWeight: fontWeight,
        color: LsColors.mute,
        height: 1.35,
        shadows: darktext,
      );

  /// Glass dropdown header title (§6.5) — body 15.5px / 700 / `--ls-fg`.
  static TextStyle get sectionTitle => _body(
        fontSize: 15.5,
        fontWeight: FontWeight.w700,
        color: LsColors.fg,
        height: 1.25,
        shadows: darktext,
      );

  /// Control label — pairs with `.pop` on glass buttons (§6.1).
  static TextStyle button({double fontSize = 15}) => _body(
        fontSize: fontSize,
        fontWeight: FontWeight.w700,
        color: LsColors.fg,
        letterSpacing: 0.1,
        height: 1.2,
        shadows: pop,
      );

  /// Positive text. Enforces the §1 contrast rule: `--ls-good` is safe only
  /// at >= 18px; anything smaller must use `--ls-goodText`.
  static TextStyle positive({double fontSize = 15}) => _body(
        fontSize: fontSize,
        fontWeight: FontWeight.w600,
        color: fontSize >= 18 ? LsColors.good : LsColors.goodText,
        height: 1.35,
        shadows: darktext,
      );
}

/// Resolves CSS `clamp()` type sizes against the viewport so the type scale
/// stays responsive without changing its visual identity.
class LsResponsiveType {
  LsResponsiveType._();

  /// Viewport band the reference mockup's `clamp()` values interpolate over.
  static const double _minViewport = 360;
  static const double _maxViewport = 1200;

  /// Linearly interpolates [min] -> [max] across the viewport band, exactly
  /// like `clamp(min, <fluid>, max)`.
  static double scale(
    BuildContext context, {
    required double min,
    required double max,
  }) {
    final width = MediaQuery.sizeOf(context).width;
    final t = ((width - _minViewport) / (_maxViewport - _minViewport))
        .clamp(0.0, 1.0);
    return min + (max - min) * t;
  }
}

/// Wraps a subtree in the `.darktext` treatment: every descendant text gets
/// the baseline legibility shadow. Mark pure-white hero text with
/// [LsType.pop] on top.
class LsDarkText extends StatelessWidget {
  const LsDarkText({super.key, required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    final inherited = DefaultTextStyle.of(context).style;
    return DefaultTextStyle(
      style: inherited.copyWith(
        color: inherited.color ?? LsColors.fg,
        shadows: LsType.darktext,
      ),
      child: child,
    );
  }
}
