import 'package:flutter/scheduler.dart';
import 'package:flutter/widgets.dart';

import '../../theme/lightsignal/ls_css.dart';
import 'ls_motion.dart';

/// §4.2 Drifting light motes — 22 glowing dots filling the open field
/// (z-index 1, decorative, behind glass).
///
/// Raising field luminosity like this is how the system fights an "empty"
/// feel — never by lightening the base (§0).
class LsMotes extends StatefulWidget {
  const LsMotes({super.key, this.count = 22});

  final int count;

  @override
  State<LsMotes> createState() => _LsMotesState();
}

class _LsMotesState extends State<LsMotes>
    with SingleTickerProviderStateMixin {
  /// A single ticker drives all motes; each one derives its own phase from
  /// the absolute elapsed time, so their independent durations and negative
  /// delays stay in sync without 22 controllers.
  late final Ticker _ticker = createTicker(_onTick);
  final ValueNotifier<double> _elapsedSeconds = ValueNotifier<double>(0);

  late List<_Mote> _motes = _Mote.generate(widget.count);
  bool _running = false;

  void _onTick(Duration elapsed) {
    _elapsedSeconds.value = elapsed.inMicroseconds / Duration.microsecondsPerSecond;
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _syncMotion();
  }

  @override
  void didUpdateWidget(LsMotes oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.count != widget.count) {
      _motes = _Mote.generate(widget.count);
    }
  }

  /// `@media (prefers-reduced-motion: reduce) { .motes span { animation:none } }`
  void _syncMotion() {
    final shouldRun = !LsMotion.reduced(context);
    if (shouldRun == _running) return;
    _running = shouldRun;
    if (shouldRun) {
      _ticker.start();
    } else {
      _ticker.stop();
      _elapsedSeconds.value = 0;
    }
  }

  @override
  void dispose() {
    _ticker.dispose();
    _elapsedSeconds.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final animate = _running;
    return IgnorePointer(
      child: ClipRect(
        child: RepaintBoundary(
          child: CustomPaint(
            painter: _LsMotesPainter(
              motes: _motes,
              elapsed: _elapsedSeconds,
              animate: animate,
            ),
            size: Size.infinite,
          ),
        ),
      ),
    );
  }
}

/// One mote, generated deterministically from its index per §4.2.
@immutable
class _Mote {
  const _Mote({
    required this.left,
    required this.top,
    required this.size,
    required this.duration,
    required this.delay,
    required this.color,
    required this.glow,
    required this.baseOpacity,
  });

  /// Fraction of the container width / height.
  final double left;
  final double top;

  /// Diameter in logical pixels.
  final double size;

  /// Animation duration and (negative) delay, in seconds.
  final double duration;
  final double delay;

  final Color color;
  final Color glow;

  /// The span's own `opacity`. CSS animations outrank inline styles, so this
  /// only takes effect when the float animation is disabled.
  final double baseOpacity;

  static const Color _brightColor = Color(0xFFCFF6FF);
  static const Color _dimColor = Color(0xFF7FE3FF);
  static const Color _brightGlow = Color(0xFFA7ECFF);
  static const Color _dimGlow = Color(0xFF5FD8FF);

  static List<_Mote> generate(int count) {
    return List<_Mote>.generate(count, (i) {
      final bright = i % 3 == 0;
      final size = 2.0 + (i % 4);
      return _Mote(
        left: ((i * 47) % 100) / 100,
        top: ((i * 29 + 7) % 100) / 100,
        size: size,
        duration: 16 + (i % 7) * 3,
        delay: -(i * 1.7),
        color: bright ? _brightColor : _dimColor,
        glow: bright ? _brightGlow : _dimGlow,
        baseOpacity: bright ? 0.8 : 0.5,
      );
    });
  }
}

class _LsMotesPainter extends CustomPainter {
  _LsMotesPainter({
    required this.motes,
    required this.elapsed,
    required this.animate,
  }) : super(repaint: elapsed);

  final List<_Mote> motes;
  final ValueNotifier<double> elapsed;
  final bool animate;

  /// `animation-timing-function: ease-in-out` — the CSS keyword, i.e.
  /// `cubic-bezier(0.42, 0, 0.58, 1)`, not the `--ease-in-out` token.
  static const Curve _keyframeEase = Curves.easeInOut;

  /// `@keyframes float` — 50% is `translateY(-26px) translateX(10px)`.
  static const Offset _peak = Offset(10, -26);

  @override
  void paint(Canvas canvas, Size size) {
    if (size.isEmpty) return;
    final time = elapsed.value;

    for (final mote in motes) {
      final center = Offset(mote.left * size.width, mote.top * size.height);
      Offset translate = Offset.zero;
      double opacity = mote.baseOpacity;

      if (animate) {
        // A negative delay starts the animation already in progress.
        final progress = (((time - mote.delay) / mote.duration) % 1.0 + 1.0) % 1.0;
        translate = _transformAt(progress);
        opacity = _opacityAt(progress);
      }

      _paintMote(canvas, mote, center + translate, opacity);
    }
  }

  /// Transform keyframes exist at 0% / 50% / 100%, so there are two eased
  /// segments.
  Offset _transformAt(double t) {
    if (t <= 0.5) {
      final e = _keyframeEase.transform(t / 0.5);
      return Offset(_peak.dx * e, _peak.dy * e);
    }
    final e = _keyframeEase.transform((t - 0.5) / 0.5);
    return Offset(_peak.dx * (1 - e), _peak.dy * (1 - e));
  }

  /// Opacity keyframes: .2 -> .8 -> .55 -> .8 -> .2 at 0/25/50/75/100%.
  double _opacityAt(double t) {
    const stops = <double>[0.0, 0.25, 0.5, 0.75, 1.0];
    const values = <double>[0.2, 0.8, 0.55, 0.8, 0.2];
    for (var i = 0; i < stops.length - 1; i++) {
      if (t <= stops[i + 1]) {
        final span = stops[i + 1] - stops[i];
        final e = _keyframeEase.transform((t - stops[i]) / span);
        return values[i] + (values[i + 1] - values[i]) * e;
      }
    }
    return values.last;
  }

  void _paintMote(Canvas canvas, _Mote mote, Offset center, double opacity) {
    final radius = mote.size / 2;

    // `box-shadow: 0 0 (size*3)px <glow>`
    canvas.drawCircle(
      center,
      radius,
      Paint()
        ..color = mote.glow.withValues(alpha: opacity)
        ..maskFilter = MaskFilter.blur(
          BlurStyle.normal,
          LsCss.blurRadiusToSigma(mote.size * 3),
        ),
    );

    canvas.drawCircle(
      center,
      radius,
      Paint()..color = mote.color.withValues(alpha: opacity),
    );
  }

  @override
  bool shouldRepaint(_LsMotesPainter oldDelegate) =>
      oldDelegate.animate != animate || oldDelegate.motes != motes;
}
