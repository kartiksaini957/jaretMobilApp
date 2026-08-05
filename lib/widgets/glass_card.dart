import 'package:flutter/material.dart';

import '../theme/lightsignal/ls_css.dart';

/// The two frosted-glass recipes the v2 reference ships.
enum GlassSurface {
  /// The auth `.card` rule — `--s: 1.25`, lighter tint, plain 1px border.
  card,

  /// The Settings `.panel.ls-glass.glassrim` rule — `--s: 1.4`, deeper tint,
  /// and the gradient rim that reads as a lit edge.
  panel,
}

/// The LightSignal frosted-glass surface — a faithful port of the reference
/// `.ls-glass` rule (blur 13 / saturate 1.4, two stacked 160deg fills, one
/// drop shadow and three insets), with the [GlassSurface.panel] variant
/// adding the `.glassrim` gradient edge.
///
/// Glass in this app is always built the same way: [lsBackdropFilter] for the
/// backdrop, [LsInsetShadowPainter] for the fills and inset highlights, and a
/// foreground border so the edge sits *inside* the box as it does in CSS.
/// `AppBottomBar` uses the same recipe — this widget makes it reusable.
class GlassCard extends StatelessWidget {
  const GlassCard({
    super.key,
    required this.child,
    this.surface = GlassSurface.card,
    this.padding = const EdgeInsets.fromLTRB(30, 30, 30, 26),
    this.borderRadius = const BorderRadius.all(Radius.circular(24)),
  });

  final Widget child;
  final GlassSurface surface;
  final EdgeInsetsGeometry padding;
  final BorderRadius borderRadius;

  /// `backdrop-filter: blur(13px) saturate(1.4)`
  static const double _backdropBlur = 13;
  static const double _backdropSaturate = 1.4;

  /// `border: 1px solid rgba(255,255,255,.1)` — the card variant's edge.
  static const Color _borderColor = Color(0x1AFFFFFF);

  /// `.glassrim::before` — `linear-gradient(150deg, ...)` at 1.25px.
  static const double _rimWidth = 1.25;
  static final Gradient _rimGradient = LsCss.linearGradient(
    degrees: 150,
    colors: const [
      Color(0xFFFFFFFF), // 1.0
      Color(0xB3FFFFFF), // .7
      Color(0x61FFFFFF), // .38
      Color(0x57FFFFFF), // .34
      Color(0x9EFFFFFF), // .62
    ],
    stops: const [0, 0.24, 0.52, 0.74, 1],
  );

  /// The first-listed background layer, so it paints on top.
  static final Map<GlassSurface, Gradient> _tintFills = {
    // `linear-gradient(160deg, rgba(8,40,56,.30), rgba(8,40,56,.24))`
    GlassSurface.card: LsCss.linearGradient(
      degrees: 160,
      colors: const [Color(0x4D082838), Color(0x3D082838)],
    ),
    // `linear-gradient(160deg, rgba(8,40,56,.34), rgba(8,40,56,.30))`
    GlassSurface.panel: LsCss.linearGradient(
      degrees: 160,
      colors: const [Color(0x57082838), Color(0x4D082838)],
    ),
  };

  /// The sheen underneath it, with the reference's `--s` strength already
  /// folded into each stop's alpha.
  static final Map<GlassSurface, Gradient> _sheenFills = {
    // `--s: 1.25` over .14 / .05 / .025 / .06
    GlassSurface.card: LsCss.linearGradient(
      degrees: 160,
      colors: const [
        Color(0x2CFFFFFF),
        Color(0x10FFFFFF),
        Color(0x08FFFFFF),
        Color(0x13FFFFFF),
      ],
      stops: const [0, 0.3, 0.6, 1],
    ),
    // `--s: 1.4` over .12 / .045 / .02 / .035
    GlassSurface.panel: LsCss.linearGradient(
      degrees: 160,
      colors: const [
        Color(0x2BFFFFFF),
        Color(0x10FFFFFF),
        Color(0x07FFFFFF),
        Color(0x0CFFFFFF),
      ],
      stops: const [0, 0.3, 0.6, 1],
    ),
  };

  /// `0 22px 55px -22px rgba(0,20,40,.5)`
  static const List<BoxShadow> _outerShadows = <BoxShadow>[
    BoxShadow(
      color: Color(0x80001428),
      offset: Offset(0, 22),
      blurRadius: 55,
      spreadRadius: -22,
    ),
  ];

  /// The three `inset` layers, in CSS order.
  static const List<LsInsetShadow> _insetShadows = <LsInsetShadow>[
    LsInsetShadow(offset: Offset(0, 1.5), blur: 1, color: Color(0x8CFFFFFF)),
    LsInsetShadow(
      offset: Offset(0, 20),
      blur: 44,
      spread: -30,
      color: Color(0x73FFFFFF),
    ),
    LsInsetShadow(offset: Offset(0, -1), blur: 14, color: Color(0x24001428)),
  ];

  @override
  Widget build(BuildContext context) {
    final content = Padding(padding: padding, child: child);

    return DecoratedBox(
      decoration: BoxDecoration(
        borderRadius: borderRadius,
        boxShadow: _outerShadows,
      ),
      child: ClipRRect(
        borderRadius: borderRadius,
        child: BackdropFilter(
          filter: lsBackdropFilter(
            blur: _backdropBlur,
            saturate: _backdropSaturate,
          ),
          child: CustomPaint(
            painter: LsInsetShadowPainter(
              borderRadius: borderRadius,
              fills: [_tintFills[surface]!, _sheenFills[surface]!],
              shadows: _insetShadows,
            ),
            // The edge sits inside the box, as in CSS.
            foregroundPainter: surface == GlassSurface.panel
                ? _GradientRimPainter(borderRadius: borderRadius)
                : null,
            child: surface == GlassSurface.panel
                ? content
                : DecoratedBox(
                    position: DecorationPosition.foreground,
                    decoration: BoxDecoration(
                      borderRadius: borderRadius,
                      border: Border.all(color: _borderColor, width: 1),
                    ),
                    child: content,
                  ),
          ),
        ),
      ),
    );
  }
}

/// Strokes the `.glassrim` gradient edge just inside the border box.
class _GradientRimPainter extends CustomPainter {
  const _GradientRimPainter({required this.borderRadius});

  final BorderRadius borderRadius;

  @override
  void paint(Canvas canvas, Size size) {
    if (size.isEmpty) return;
    final rect = Offset.zero & size;
    // A stroke straddles its path, so inset by half the width to keep the
    // whole rim inside the box — CSS draws it fully within.
    final inset = GlassCard._rimWidth / 2;
    final rrect = borderRadius
        .toRRect(rect)
        .deflate(inset)
        .scaleRadii();

    canvas.drawRRect(
      rrect,
      Paint()
        ..style = PaintingStyle.stroke
        ..strokeWidth = GlassCard._rimWidth
        ..shader = GlassCard._rimGradient.createShader(rect),
    );
  }

  @override
  bool shouldRepaint(_GradientRimPainter oldDelegate) =>
      oldDelegate.borderRadius != borderRadius;
}
