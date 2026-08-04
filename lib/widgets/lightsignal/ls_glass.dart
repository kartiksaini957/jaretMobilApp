import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';

import '../../theme/lightsignal/ls_css.dart';
import '../../theme/lightsignal/ls_tokens.dart';
import '../../theme/lightsignal/ls_typography.dart';

/// A lit glass surface: backdrop blur + saturate, a stack of fill gradients,
/// CSS `inset` shadows, an outer drop, and a masked gradient rim.
///
/// Every glass thing in the system is one of these — cards (§3), buttons
/// (§6.1), nav pills (§6.2), status pills (§6.3), dropdown sections (§6.5).
/// Controls are glass too; there are no solid opaque blocks on the glass.
class LsGlassLayer extends StatelessWidget {
  const LsGlassLayer({
    super.key,
    required this.child,
    required this.borderRadius,
    this.fills = const <Gradient>[],
    this.insetShadows = const <LsInsetShadow>[],
    this.outerShadows = const <BoxShadow>[],
    this.border,
    this.rimGradient,
    this.rimWidth = 1.25,
    this.blur = 0,
    this.saturate = 1.0,
    this.padding,
    this.clipBehavior = Clip.antiAlias,
    this.foreground,
  });

  final Widget child;
  final BorderRadius borderRadius;

  /// Fill gradients in CSS order — first entry is the topmost layer.
  final List<Gradient> fills;

  final List<LsInsetShadow> insetShadows;
  final List<BoxShadow> outerShadows;

  /// A plain 1px border, for surfaces that use `border` instead of a rim.
  final BorderSide? border;

  /// The masked `::before` ring (§3.1). Drawn above the fill.
  final Gradient? rimGradient;
  final double rimWidth;

  /// `backdrop-filter: blur(<blur>px) saturate(<saturate>)`.
  final double blur;
  final double saturate;

  final EdgeInsetsGeometry? padding;
  final Clip clipBehavior;

  /// Extra content painted above the child (before the rim).
  final Widget? foreground;

  @override
  Widget build(BuildContext context) {
    Widget content = child;
    if (padding != null) {
      content = Padding(padding: padding!, child: content);
    }
    if (foreground != null) {
      content = Stack(
        children: [
          content,
          Positioned.fill(child: IgnorePointer(child: foreground!)),
        ],
      );
    }

    Widget surface = CustomPaint(
      painter: _LsGlassLayerPainter(
        fills: fills,
        insetShadows: insetShadows,
        borderRadius: borderRadius,
      ),
      foregroundPainter: rimGradient != null
          ? LsRimPainter(
              gradient: rimGradient!,
              borderRadius: borderRadius,
              width: rimWidth,
            )
          : null,
      child: content,
    );

    if (border != null) {
      surface = DecoratedBox(
        position: DecorationPosition.foreground,
        decoration: BoxDecoration(
          borderRadius: borderRadius,
          border: Border.fromBorderSide(border!),
        ),
        child: surface,
      );
    }

    surface = ClipRRect(
      borderRadius: borderRadius,
      clipBehavior: clipBehavior,
      child: blur > 0
          ? BackdropFilter(
              filter: lsBackdropFilter(blur: blur, saturate: saturate),
              child: surface,
            )
          : surface,
    );

    if (outerShadows.isEmpty) return surface;

    return DecoratedBox(
      decoration: BoxDecoration(
        borderRadius: borderRadius,
        boxShadow: outerShadows,
      ),
      child: surface,
    );
  }
}

class _LsGlassLayerPainter extends CustomPainter {
  const _LsGlassLayerPainter({
    required this.fills,
    required this.insetShadows,
    required this.borderRadius,
  });

  final List<Gradient> fills;
  final List<LsInsetShadow> insetShadows;
  final BorderRadius borderRadius;

  @override
  void paint(Canvas canvas, Size size) {
    if (size.isEmpty) return;
    final rect = Offset.zero & size;
    final rrect = borderRadius.toRRect(rect);

    // CSS paints the first-listed background layer on top, so fills go down
    // in reverse.
    for (final fill in fills.reversed) {
      canvas.drawRRect(rrect, Paint()..shader = fill.createShader(rect));
    }

    if (insetShadows.isNotEmpty) {
      LsInsetShadowPainter(
        shadows: insetShadows,
        borderRadius: borderRadius,
      ).paint(canvas, size);
    }
  }

  @override
  bool shouldRepaint(_LsGlassLayerPainter oldDelegate) =>
      !listEquals(oldDelegate.fills, fills) ||
      !listEquals(oldDelegate.insetShadows, insetShadows) ||
      oldDelegate.borderRadius != borderRadius;
}

/// §3 Glass surface — any card, panel or banner.
///
/// Near-transparent: mostly rim plus a whisper of fill, so the field reads
/// through. [strength] (S) scales every white-fill alpha — the
/// transparency <-> legibility dial (see [LsGlassStrength]).
///
/// The dark contrast scrim is **not optional**. The field's bright glows make
/// legibility position-dependent — the same card passes over the dark base
/// and fails over a glow — so the scrim floors the effective backdrop to
/// about `#2f6479` worst case, letting every approved text token clear its
/// WCAG floor wherever the card lands.
class LsGlass extends StatelessWidget {
  const LsGlass({
    super.key,
    required this.child,
    this.strength = LsGlassStrength.standard,
    this.borderRadius,
    this.padding,
    this.rim = true,
    this.outerShadow = true,
    this.darkText = true,
  });

  /// Hero / showcase surface — S 1.0, radius 24px.
  const LsGlass.hero({
    super.key,
    required this.child,
    this.borderRadius = const BorderRadius.all(Radius.circular(LsRadii.hero)),
    this.padding,
    this.rim = true,
    this.outerShadow = true,
    this.darkText = true,
  }) : strength = LsGlassStrength.hero;

  /// Standard data card — S 1.4, radius 20px.
  const LsGlass.card({
    super.key,
    required this.child,
    this.borderRadius = const BorderRadius.all(Radius.circular(LsRadii.card)),
    this.padding,
    this.rim = true,
    this.outerShadow = true,
    this.darkText = true,
  }) : strength = LsGlassStrength.standard;

  /// Number / metric tile — S 1.5, radius 20px. Figures must stay solid.
  const LsGlass.metric({
    super.key,
    required this.child,
    this.borderRadius = const BorderRadius.all(Radius.circular(LsRadii.card)),
    this.padding,
    this.rim = true,
    this.outerShadow = true,
    this.darkText = true,
  }) : strength = LsGlassStrength.metric;

  final Widget child;

  /// `--s` — multiplies each white-fill alpha.
  final double strength;

  final BorderRadius? borderRadius;
  final EdgeInsetsGeometry? padding;

  /// `.glassrim` — the bright 1.25px gradient border (§3.1).
  final bool rim;

  /// The tinted outer drop shadow. Never pure black.
  final bool outerShadow;

  /// Wraps content in the `.darktext` treatment.
  final bool darkText;

  /// `backdrop-filter: blur(13px) saturate(1.4)`.
  static const double backdropBlur = 13;
  static const double backdropSaturate = 1.4;

  static const double rimWidth = 1.25;

  /// `0 22px 55px -22px rgba(0,20,40,0.5)` — tinted outer drop.
  static const List<BoxShadow> outerShadows = <BoxShadow>[
    BoxShadow(
      color: Color(0x80001428),
      offset: Offset(0, 22),
      blurRadius: 55,
      spreadRadius: -22,
    ),
  ];

  /// §3.1 rim gradient — a continuous 1.25px border, brightest top-left.
  static final Gradient rimGradient = LsCss.linearGradient(
    degrees: 150,
    colors: const [
      Color(0xFFFFFFFF),
      Color(0xB3FFFFFF),
      Color(0x61FFFFFF),
      Color(0x57FFFFFF),
      Color(0x9EFFFFFF),
    ],
    stops: const [0.0, 0.24, 0.52, 0.74, 1.0],
  );

  /// The mandatory dark contrast scrim. Do not remove it.
  static final Gradient scrim = LsCss.linearGradient(
    degrees: 160,
    colors: const [Color(0x57082838), Color(0x4D082838)],
  );

  /// The `inset` shadow stack from the glass recipe.
  static const List<LsInsetShadow> insetShadows = <LsInsetShadow>[
    // inner top highlight
    LsInsetShadow(offset: Offset(0, 1.5), blur: 1, color: Color(0x8CFFFFFF)),
    // glow bleeding down from the top edge
    LsInsetShadow(
      offset: Offset(0, 20),
      blur: 44,
      spread: -30,
      color: Color(0x73FFFFFF),
    ),
    // inner lower refraction shadow
    LsInsetShadow(offset: Offset(0, -1), blur: 14, color: Color(0x24001428)),
  ];

  /// The white fill, with each alpha multiplied by S.
  static Gradient fillFor(double strength) {
    double a(double base) => (base * strength).clamp(0.0, 1.0);
    return LsCss.linearGradient(
      degrees: 160,
      colors: [
        const Color(0xFFFFFFFF).withValues(alpha: a(0.12)),
        const Color(0xFFFFFFFF).withValues(alpha: a(0.045)),
        const Color(0xFFFFFFFF).withValues(alpha: a(0.02)),
        const Color(0xFFFFFFFF).withValues(alpha: a(0.035)),
      ],
      stops: const [0.0, 0.30, 0.60, 1.0],
    );
  }

  @override
  Widget build(BuildContext context) {
    final radius =
        borderRadius ?? const BorderRadius.all(Radius.circular(LsRadii.card));

    return LsGlassLayer(
      borderRadius: radius,
      // Scrim first: it is the topmost background layer.
      fills: [scrim, fillFor(strength)],
      insetShadows: insetShadows,
      outerShadows: outerShadow ? outerShadows : const <BoxShadow>[],
      rimGradient: rim ? rimGradient : null,
      rimWidth: rimWidth,
      blur: backdropBlur,
      saturate: backdropSaturate,
      padding: padding,
      child: DefaultTextStyle.merge(
        style: TextStyle(
          color: LsColors.fg,
          shadows: darkText ? LsType.darktext : null,
        ),
        child: child,
      ),
    );
  }
}
