import 'dart:math' as math;
import 'dart:ui' as ui;

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';

/// Primitives that let the rest of the LightSignal skin be a faithful,
/// copy-paste port of the CSS in `LightSignal Visual Foundation v2` —
/// CSS gradient angles, `inset` box-shadows and masked gradient rims all
/// need explicit translation to reach Flutter unchanged.
class LsCss {
  LsCss._();

  /// Direction of a CSS `linear-gradient(<deg>, ...)` in screen space.
  ///
  /// CSS 0deg points to the top and angles increase clockwise, so with y
  /// pointing down the unit direction is `(sin d, -cos d)`.
  static Offset linearDirection(double degrees) {
    final radians = degrees * math.pi / 180.0;
    return Offset(math.sin(radians), -math.cos(radians));
  }

  /// Builds a CSS-equivalent linear gradient at [degrees].
  static Gradient linearGradient({
    required double degrees,
    required List<Color> colors,
    List<double>? stops,
  }) {
    return LsLinearGradient(degrees: degrees, colors: colors, stops: stops);
  }

  /// A CSS `transparent` stop for a colored gradient.
  ///
  /// Browsers interpolate gradients in premultiplied space, so
  /// `#2BD4FF -> transparent` fades out without darkening. Flutter lerps
  /// unpremultiplied, so fading to `Colors.transparent` (transparent black)
  /// would drag the ramp through gray. Fading to the *same* color at alpha 0
  /// reproduces the browser result.
  static Color fadeOut(Color color) => color.withValues(alpha: 0);

  /// CSS `box-shadow` blur radius -> Gaussian sigma. The spec's blur radius
  /// is twice the standard deviation.
  static double blurRadiusToSigma(double blurRadius) => blurRadius / 2.0;
}

/// A CSS `linear-gradient(<deg>, ...)`.
///
/// Flutter's [LinearGradient] takes begin/end [Alignment]s, which are
/// fractions of the box — so a fixed alignment pair renders a *different*
/// angle as the box's aspect ratio changes. A CSS angle is a true geometric
/// angle, independent of the box. This lays out the real CSS gradient line
/// instead: centred on the box, along the angle, with length
/// `|W·sin d| + |H·cos d|` so the ramp finishes exactly at the corners.
@immutable
class LsLinearGradient extends Gradient {
  const LsLinearGradient({
    required this.degrees,
    required super.colors,
    super.stops,
    this.tileMode = TileMode.clamp,
    super.transform,
  });

  final double degrees;
  final TileMode tileMode;

  List<double> _resolvedStops() {
    final existing = stops;
    if (existing != null) return existing;
    if (colors.length == 1) return const <double>[0.0];
    final step = 1.0 / (colors.length - 1);
    return List<double>.generate(colors.length, (i) => i * step);
  }

  @override
  Shader createShader(Rect rect, {TextDirection? textDirection}) {
    final direction = LsCss.linearDirection(degrees);
    final length = (rect.width * direction.dx).abs() +
        (rect.height * direction.dy).abs();
    final half = direction * (length / 2);
    return ui.Gradient.linear(
      rect.center - half,
      rect.center + half,
      colors,
      _resolvedStops(),
      tileMode,
      transform?.transform(rect)?.storage,
    );
  }

  @override
  LsLinearGradient scale(double factor) => LsLinearGradient(
        degrees: degrees,
        colors: colors
            .map((color) => Color.lerp(null, color, factor)!)
            .toList(growable: false),
        stops: stops,
        tileMode: tileMode,
        transform: transform,
      );

  @override
  LsLinearGradient withOpacity(double opacity) => LsLinearGradient(
        degrees: degrees,
        colors: colors
            .map((color) => color.withValues(alpha: opacity))
            .toList(growable: false),
        stops: stops,
        tileMode: tileMode,
        transform: transform,
      );

  /// Interpolates two gradients that share an angle and stop list.
  static LsLinearGradient lerpColors(
    LsLinearGradient a,
    LsLinearGradient b,
    double t,
  ) {
    assert(a.colors.length == b.colors.length);
    return LsLinearGradient(
      degrees: a.degrees,
      colors: <Color>[
        for (var i = 0; i < a.colors.length; i++)
          Color.lerp(a.colors[i], b.colors[i], t)!,
      ],
      stops: a.stops,
      tileMode: a.tileMode,
      transform: a.transform,
    );
  }

  @override
  Gradient? lerpFrom(Gradient? a, double t) {
    if (a is LsLinearGradient &&
        a.degrees == degrees &&
        a.colors.length == colors.length) {
      return lerpColors(a, this, t);
    }
    return null;
  }

  @override
  Gradient? lerpTo(Gradient? b, double t) {
    if (b is LsLinearGradient &&
        b.degrees == degrees &&
        b.colors.length == colors.length) {
      return lerpColors(this, b, t);
    }
    return null;
  }

  @override
  bool operator ==(Object other) =>
      other is LsLinearGradient &&
      other.degrees == degrees &&
      other.tileMode == tileMode &&
      other.transform == transform &&
      listEquals(other.colors, colors) &&
      listEquals(other.stops, stops);

  @override
  int get hashCode => Object.hash(
        degrees,
        tileMode,
        transform,
        Object.hashAll(colors),
        stops == null ? null : Object.hashAll(stops!),
      );
}

/// A single CSS `inset` box-shadow layer.
///
/// Flutter's [BoxShadow] only draws outer shadows, so the glass recipe's four
/// inner layers (§3) are modelled here and drawn by [LsInsetShadowPainter].
@immutable
class LsInsetShadow {
  const LsInsetShadow({
    this.offset = Offset.zero,
    this.blur = 0,
    this.spread = 0,
    required this.color,
  });

  /// CSS `inset <offset.dx> <offset.dy> ...`.
  final Offset offset;

  /// CSS blur radius (not sigma).
  final double blur;

  /// CSS spread radius. Positive shrinks the un-shadowed hole, growing the
  /// shadow inward; negative grows the hole.
  final double spread;

  final Color color;

  @override
  bool operator ==(Object other) =>
      other is LsInsetShadow &&
      other.offset == offset &&
      other.blur == blur &&
      other.spread == spread &&
      other.color == color;

  @override
  int get hashCode => Object.hash(offset, blur, spread, color);
}

/// Paints a list of [LsInsetShadow]s inside [rrect].
///
/// Mirrors the CSS model exactly: take the border box, shrink it by the
/// spread, offset it, and paint everything *outside* that shape while
/// clipping to the border box — blurred by `blur / 2`.
class LsInsetShadowPainter extends CustomPainter {
  const LsInsetShadowPainter({
    required this.shadows,
    required this.borderRadius,
  });

  final List<LsInsetShadow> shadows;
  final BorderRadius borderRadius;

  @override
  void paint(Canvas canvas, Size size) {
    if (shadows.isEmpty) return;
    final rect = Offset.zero & size;
    final rrect = borderRadius.toRRect(rect);

    canvas.save();
    canvas.clipRRect(rrect);
    for (final shadow in shadows) {
      _paintShadow(canvas, rrect, shadow);
    }
    canvas.restore();
  }

  void _paintShadow(Canvas canvas, RRect rrect, LsInsetShadow shadow) {
    // The hole: border box deflated by spread, then offset. Everything in the
    // border box that is *not* in the hole receives shadow.
    final hole = rrect.deflate(shadow.spread).shift(shadow.offset);

    // The outer bound must extend far enough that the blur never reveals the
    // edge of the painted region inside the clip.
    final reach = shadow.blur + shadow.spread.abs() + shadow.offset.distance;
    final outer = rrect.outerRect.inflate(reach + 24);

    final region = Path.combine(
      PathOperation.difference,
      Path()..addRect(outer),
      Path()..addRRect(hole),
    );

    final paint = Paint()..color = shadow.color;
    if (shadow.blur > 0) {
      paint.maskFilter = MaskFilter.blur(
        BlurStyle.normal,
        LsCss.blurRadiusToSigma(shadow.blur),
      );
    }
    canvas.drawPath(region, paint);
  }

  @override
  bool shouldRepaint(LsInsetShadowPainter oldDelegate) =>
      !listEquals(oldDelegate.shadows, shadows) ||
      oldDelegate.borderRadius != borderRadius;
}

/// Paints a gradient rim — the CSS `::before` ring built with
/// `padding: <width>` plus `mask-composite: exclude` (§3.1).
///
/// Instead of masking two boxes, the equivalent result is a stroke of
/// [width] laid just inside the element's edge, filled with the rim
/// gradient.
class LsRimPainter extends CustomPainter {
  const LsRimPainter({
    required this.gradient,
    required this.borderRadius,
    this.width = 1.25,
  });

  final Gradient gradient;
  final BorderRadius borderRadius;
  final double width;

  @override
  void paint(Canvas canvas, Size size) {
    final rect = Offset.zero & size;
    // A stroke straddles the path, so inset by half the width to keep the
    // whole rim inside the element — matching `inset: 0` + `padding`.
    final strokeRect = rect.deflate(width / 2);
    if (strokeRect.width <= 0 || strokeRect.height <= 0) return;
    final rrect = borderRadius
        .toRRect(rect)
        .deflate(width / 2)
        .scaleRadii();

    canvas.drawRRect(
      rrect,
      Paint()
        ..style = PaintingStyle.stroke
        ..strokeWidth = width
        ..shader = gradient.createShader(rect),
    );
  }

  @override
  bool shouldRepaint(LsRimPainter oldDelegate) =>
      oldDelegate.gradient != gradient ||
      oldDelegate.borderRadius != borderRadius ||
      oldDelegate.width != width;
}

/// Backdrop filter matching CSS `backdrop-filter: blur(Npx) saturate(S)`.
///
/// CSS `blur(N)` is a Gaussian with standard deviation N, which maps
/// directly onto [ui.ImageFilter.blur]'s sigma. Saturation is a colour
/// matrix composed over the blur.
ui.ImageFilter lsBackdropFilter({
  required double blur,
  required double saturate,
}) {
  final blurFilter = ui.ImageFilter.blur(sigmaX: blur, sigmaY: blur);
  if (saturate == 1.0) return blurFilter;
  return ui.ImageFilter.compose(
    outer: _saturationFilter(saturate),
    inner: blurFilter,
  );
}

/// Standard luminance-preserving saturation matrix (the same one the CSS
/// `saturate()` filter primitive is defined with).
ColorFilter _saturationFilter(double s) {
  const lr = 0.213;
  const lg = 0.715;
  const lb = 0.072;
  return ColorFilter.matrix(<double>[
    lr + (1 - lr) * s, lg - lg * s, lb - lb * s, 0, 0, //
    lr - lr * s, lg + (1 - lg) * s, lb - lb * s, 0, 0, //
    lr - lr * s, lg - lg * s, lb + (1 - lb) * s, 0, 0, //
    0, 0, 0, 1, 0, //
  ]);
}