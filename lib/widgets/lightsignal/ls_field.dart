import 'package:flutter/widgets.dart';

import '../../theme/lightsignal/ls_css.dart';
import '../../theme/lightsignal/ls_tokens.dart';
import 'ls_motes.dart';
import 'ls_streaks.dart';

/// §2 Field — the page background.
///
/// Deep cyan with a real tonal range and multiple luminous glows so open
/// areas read lit, not ominous. Glass only reads as glass over a field like
/// this; flat or light fields make glass look like opaque plastic (§0).
///
/// Layering (§2): field z-index 0, streaks + motes z-index 1, content
/// z-index 2. The field is painted behind scrolling content rather than
/// inside it, which is what `background-attachment: fixed` buys in CSS.
class LsField extends StatelessWidget {
  const LsField({
    super.key,
    required this.child,
    this.showStreaks = true,
    this.showMotes = true,
  });

  final Widget child;

  /// §4.1 flowing light streaks.
  final bool showStreaks;

  /// §4.2 drifting light motes.
  final bool showMotes;

  @override
  Widget build(BuildContext context) {
    return RepaintBoundary(
      child: Stack(
        fit: StackFit.expand,
        children: [
          // z-index 0
          const _LsFieldBackdrop(),
          // z-index 1
          if (showStreaks) const LsStreaks(),
          if (showMotes) const LsMotes(),
          // z-index 2
          child,
        ],
      ),
    );
  }
}

class _LsFieldBackdrop extends StatelessWidget {
  const _LsFieldBackdrop();

  @override
  Widget build(BuildContext context) {
    return const RepaintBoundary(
      child: CustomPaint(painter: LsFieldPainter(), size: Size.infinite),
    );
  }
}

/// One `radial-gradient(ellipse ... at ..., color 0%, transparent stop)`
/// layer of the field.
@immutable
class _FieldGlow {
  const _FieldGlow({
    required this.cx,
    required this.cy,
    required this.sizeX,
    required this.sizeY,
    required this.stop,
    required this.color,
  });

  /// Center, as a fraction of the box.
  final double cx;
  final double cy;

  /// Ending-shape radii, as a fraction of width / height.
  final double sizeX;
  final double sizeY;

  /// Where the color reaches full transparency along the gradient ray.
  final double stop;

  final Color color;
}

/// Paints the §2 field recipe verbatim.
class LsFieldPainter extends CustomPainter {
  const LsFieldPainter();

  /// CSS paints the first-listed background layer on top, so these are
  /// painted in reverse order over the base gradient.
  static const List<_FieldGlow> _glows = <_FieldGlow>[
    _FieldGlow(
      cx: 0.18,
      cy: 0.12,
      sizeX: 0.70,
      sizeY: 0.60,
      stop: 0.56,
      color: LsColors.fieldGlow0,
    ),
    _FieldGlow(
      cx: 0.92,
      cy: 0.30,
      sizeX: 0.55,
      sizeY: 0.55,
      stop: 0.60,
      color: LsColors.fieldGlow1,
    ),
    _FieldGlow(
      cx: 0.75,
      cy: 0.88,
      sizeX: 0.65,
      sizeY: 0.60,
      stop: 0.64,
      color: LsColors.fieldGlow2,
    ),
    _FieldGlow(
      cx: 0.35,
      cy: 0.70,
      sizeX: 0.50,
      sizeY: 0.50,
      stop: 0.62,
      color: LsColors.fieldGlow3,
    ),
    _FieldGlow(
      cx: 0.60,
      cy: 0.40,
      sizeX: 0.40,
      sizeY: 0.40,
      stop: 0.58,
      color: LsColors.fieldGlow4,
    ),
  ];

  /// `linear-gradient(150deg, #064A63 0%, #05688A 52%, #0892C0 100%)`.
  static final Gradient _base = LsCss.linearGradient(
    degrees: 150,
    colors: const [
      LsColors.fieldBase0,
      LsColors.fieldBase1,
      LsColors.fieldBase2,
    ],
    stops: const [0.0, 0.52, 1.0],
  );

  @override
  void paint(Canvas canvas, Size size) {
    if (size.isEmpty) return;
    final rect = Offset.zero & size;

    canvas.drawRect(rect, Paint()..shader = _base.createShader(rect));

    for (final glow in _glows.reversed) {
      _paintGlow(canvas, size, glow);
    }
  }

  void _paintGlow(Canvas canvas, Size size, _FieldGlow glow) {
    // The stop percentage is measured along the gradient ray, so the ellipse
    // that actually reaches transparency is the ending shape scaled by it.
    final rx = glow.sizeX * size.width * glow.stop;
    final ry = glow.sizeY * size.height * glow.stop;
    if (rx <= 0 || ry <= 0) return;

    const unit = Rect.fromLTRB(-1, -1, 1, 1);
    final shader = RadialGradient(
      colors: [glow.color, LsCss.fadeOut(glow.color)],
      stops: const [0.0, 1.0],
    ).createShader(unit);

    canvas.save();
    canvas.translate(glow.cx * size.width, glow.cy * size.height);
    // Draw a unit circle in a scaled space — an ellipse with radii rx/ry.
    canvas.scale(rx, ry);
    canvas.drawCircle(Offset.zero, 1, Paint()..shader = shader);
    canvas.restore();
  }

  @override
  bool shouldRepaint(LsFieldPainter oldDelegate) => false;
}
