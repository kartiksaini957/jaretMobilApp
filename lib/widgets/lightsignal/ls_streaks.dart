import 'dart:ui' as ui;

import 'package:flutter/widgets.dart';

import '../../theme/lightsignal/ls_css.dart';
import '../../theme/lightsignal/ls_tokens.dart';
import 'ls_motion.dart';

/// §4.1 Flowing light streaks — decorative, behind glass (z-index 1).
///
/// Four blurred paths laid out in a `0 0 1400 700` viewBox stretched to fill
/// (`preserveAspectRatio: none`), stroked with a diagonal white gradient and
/// drifting on a 26s linear alternate loop. Transform-only, so it stays on
/// the GPU (§8).
class LsStreaks extends StatefulWidget {
  const LsStreaks({super.key, this.opacity = 0.55});

  /// Container opacity — `0.55` in the reference.
  final double opacity;

  @override
  State<LsStreaks> createState() => _LsStreaksState();
}

class _LsStreaksState extends State<LsStreaks>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller = AnimationController(
    vsync: this,
    duration: LsDurations.streakDrift,
  );

  bool _running = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _syncMotion();
  }

  /// `@media (prefers-reduced-motion: reduce) { .streaks { animation: none } }`
  void _syncMotion() {
    final shouldRun = !LsMotion.reduced(context);
    if (shouldRun == _running) return;
    _running = shouldRun;
    if (shouldRun) {
      _controller.repeat(reverse: true);
    } else {
      _controller.stop();
      _controller.value = 0;
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return IgnorePointer(
      child: RepaintBoundary(
        child: LayoutBuilder(
          builder: (context, constraints) {
            final width = constraints.maxWidth;
            final height = constraints.maxHeight;
            return AnimatedBuilder(
              animation: _controller,
              builder: (context, child) {
                // @keyframes drift — translateX(-3%) translateY(1.5%).
                final t = _controller.value;
                return Transform.translate(
                  offset: Offset(-0.03 * width * t, 0.015 * height * t),
                  child: child,
                );
              },
              child: Opacity(
                opacity: widget.opacity,
                child: const CustomPaint(
                  painter: _LsStreaksPainter(),
                  size: Size.infinite,
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}

/// A single `<path>` of the streak group.
@immutable
class _Streak {
  const _Streak({
    required this.start,
    required this.c1,
    required this.c2,
    required this.end,
    required this.strokeWidth,
    required this.opacity,
  });

  final Offset start;
  final Offset c1;
  final Offset c2;
  final Offset end;
  final double strokeWidth;
  final double opacity;
}

class _LsStreaksPainter extends CustomPainter {
  const _LsStreaksPainter();

  /// SVG `viewBox="0 0 1400 700"`.
  static const Size _viewBox = Size(1400, 700);

  /// `<filter id="sf"><feGaussianBlur stdDeviation="16"/></filter>`.
  static const double _blurStdDeviation = 16;

  static const List<_Streak> _streaks = <_Streak>[
    _Streak(
      start: Offset(-60, 180),
      c1: Offset(350, 40),
      c2: Offset(850, 140),
      end: Offset(1480, -30),
      strokeWidth: 18,
      opacity: 0.6,
    ),
    _Streak(
      start: Offset(-60, 340),
      c1: Offset(420, 200),
      c2: Offset(900, 320),
      end: Offset(1480, 140),
      strokeWidth: 26,
      opacity: 0.5,
    ),
    _Streak(
      start: Offset(-60, 540),
      c1: Offset(400, 410),
      c2: Offset(920, 500),
      end: Offset(1480, 340),
      strokeWidth: 16,
      opacity: 0.45,
    ),
    _Streak(
      start: Offset(-60, 640),
      c1: Offset(460, 540),
      c2: Offset(980, 620),
      end: Offset(1480, 500),
      strokeWidth: 30,
      opacity: 0.38,
    ),
  ];

  @override
  void paint(Canvas canvas, Size size) {
    if (size.isEmpty) return;

    final scaleX = size.width / _viewBox.width;
    final scaleY = size.height / _viewBox.height;

    canvas.save();
    // preserveAspectRatio="none" — stretch both axes independently.
    canvas.scale(scaleX, scaleY);

    // The blur filter sits on the <g>, so blur the whole group as one layer
    // rather than each stroke separately.
    final layerBounds = Rect.fromLTWH(0, 0, _viewBox.width, _viewBox.height)
        .inflate(_blurStdDeviation * 4);
    canvas.saveLayer(
      layerBounds,
      Paint()
        ..imageFilter = ui.ImageFilter.blur(
          sigmaX: _blurStdDeviation,
          sigmaY: _blurStdDeviation,
        ),
    );

    for (final streak in _streaks) {
      _paintStreak(canvas, streak);
    }

    canvas.restore(); // saveLayer
    canvas.restore(); // scale
  }

  void _paintStreak(Canvas canvas, _Streak streak) {
    final path = Path()
      ..moveTo(streak.start.dx, streak.start.dy)
      ..cubicTo(
        streak.c1.dx,
        streak.c1.dy,
        streak.c2.dx,
        streak.c2.dy,
        streak.end.dx,
        streak.end.dy,
      );

    // `<linearGradient id="st" x1="0" y1="0" x2="1" y2="1">` in
    // objectBoundingBox units — a diagonal across the path's own bounds.
    // The stop alphas are 0 -> 0.6 -> 0; the per-path `opacity` attribute is
    // folded into them, which is equivalent for a single stroke and keeps
    // the whole group in one blurred layer.
    final bounds = path.getBounds();
    final shader = LinearGradient(
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
      colors: [
        LsCss.fadeOut(LsColors.fg),
        LsColors.fg.withValues(alpha: 0.6 * streak.opacity),
        LsCss.fadeOut(LsColors.fg),
      ],
      stops: const [0.0, 0.5, 1.0],
    ).createShader(bounds);

    canvas.drawPath(
      path,
      Paint()
        ..style = PaintingStyle.stroke
        ..strokeWidth = streak.strokeWidth
        ..strokeCap = StrokeCap.round
        ..shader = shader,
    );
  }

  @override
  bool shouldRepaint(_LsStreaksPainter oldDelegate) => false;
}
