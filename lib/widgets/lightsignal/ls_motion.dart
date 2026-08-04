import 'dart:ui' as ui;

import 'package:flutter/widgets.dart';

import '../../theme/lightsignal/ls_tokens.dart';

/// §8 Motion.
///
/// Hard rules enforced here: animate transform/opacity only, gate every
/// hover behind a real pointer, never loop a count-up, and honour
/// `prefers-reduced-motion`.
class LsMotion {
  LsMotion._();

  /// `@media (prefers-reduced-motion: reduce)`.
  static bool reduced(BuildContext context) =>
      MediaQuery.disableAnimationsOf(context);

  /// Stagger delay for the [index]th item of a group — ~60ms steps.
  static Duration staggerDelay(int index) =>
      LsDurations.stagger * index.clamp(0, 1 << 20);
}

/// `.ls-enter` — card entrance: `translateY(14px) + opacity 0` easing out
/// over 380ms. Reduced motion collapses it to a 220ms fade with no movement.
///
/// Pass [index] to stagger a group.
class LsEnter extends StatefulWidget {
  const LsEnter({
    super.key,
    required this.child,
    this.index = 0,
    this.delay,
    this.enabled = true,
  });

  final Widget child;

  /// Position within a staggered group.
  final int index;

  /// Explicit delay, overriding the [index]-derived stagger.
  final Duration? delay;

  final bool enabled;

  @override
  State<LsEnter> createState() => _LsEnterState();
}

class _LsEnterState extends State<LsEnter> with SingleTickerProviderStateMixin {
  late final AnimationController _controller = AnimationController(
    vsync: this,
    duration: LsDurations.enter,
  );

  bool _started = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_started) return;
    _started = true;

    if (!widget.enabled) {
      _controller.value = 1;
      return;
    }

    final reduced = LsMotion.reduced(context);
    _controller.duration =
        reduced ? LsDurations.enterReduced : LsDurations.enter;

    final delay = widget.delay ?? LsMotion.staggerDelay(widget.index);
    if (delay == Duration.zero) {
      _controller.forward();
    } else {
      Future<void>.delayed(delay, () {
        if (mounted) _controller.forward();
      });
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final reduced = LsMotion.reduced(context);
    final curved = CurvedAnimation(
      parent: _controller,
      curve: LsCurves.easeOut,
    );

    return AnimatedBuilder(
      animation: curved,
      builder: (context, child) {
        final t = curved.value;
        final content = Opacity(opacity: t, child: child);
        // `.ls-enter { transform: none }` under reduced motion — fade only.
        if (reduced) return content;
        return Transform.translate(
          offset: Offset(0, 14 * (1 - t)),
          child: content,
        );
      },
      child: widget.child,
    );
  }
}

/// `.ls-pressable` — `scale(0.97)` over 150ms `--ease-out` on press.
/// Every pressable surface in the system carries this.
class LsPressable extends StatefulWidget {
  const LsPressable({
    super.key,
    required this.child,
    this.onTap,
    this.onLongPress,
    this.borderRadius,
    this.semanticLabel,
    this.enabled = true,
  });

  final Widget child;
  final VoidCallback? onTap;
  final VoidCallback? onLongPress;
  final BorderRadius? borderRadius;
  final String? semanticLabel;
  final bool enabled;

  @override
  State<LsPressable> createState() => _LsPressableState();
}

class _LsPressableState extends State<LsPressable> {
  bool _pressed = false;

  bool get _interactive =>
      widget.enabled && (widget.onTap != null || widget.onLongPress != null);

  void _setPressed(bool value) {
    if (_pressed == value) return;
    setState(() => _pressed = value);
  }

  @override
  Widget build(BuildContext context) {
    final reduced = LsMotion.reduced(context);
    final scale = (_pressed && !reduced) ? 0.97 : 1.0;

    return Semantics(
      button: _interactive,
      label: widget.semanticLabel,
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: widget.enabled ? widget.onTap : null,
        onLongPress: widget.enabled ? widget.onLongPress : null,
        onTapDown: _interactive ? (_) => _setPressed(true) : null,
        onTapUp: _interactive ? (_) => _setPressed(false) : null,
        onTapCancel: _interactive ? () => _setPressed(false) : null,
        child: AnimatedScale(
          scale: scale,
          duration: LsDurations.press,
          curve: LsCurves.easeOut,
          child: widget.child,
        ),
      ),
    );
  }
}

/// `.ls-lift` — hover lift of `translateY(-4px)` over 200ms
/// `--ease-spring`, plus the deeper drop shadow.
///
/// Flutter only reports hover for real pointer devices, which is exactly
/// what `@media (hover:hover) and (pointer:fine)` gates on.
class LsLift extends StatefulWidget {
  const LsLift({
    super.key,
    required this.child,
    this.borderRadius,
    this.enabled = true,
  });

  final Widget child;

  /// Radius used for the hover drop shadow.
  final BorderRadius? borderRadius;

  final bool enabled;

  @override
  State<LsLift> createState() => _LsLiftState();
}

class _LsLiftState extends State<LsLift> {
  bool _hovered = false;

  @override
  Widget build(BuildContext context) {
    final reduced = LsMotion.reduced(context);
    final lifted = _hovered && widget.enabled && !reduced;

    return MouseRegion(
      onEnter: widget.enabled ? (_) => setState(() => _hovered = true) : null,
      onExit: widget.enabled ? (_) => setState(() => _hovered = false) : null,
      child: AnimatedContainer(
        duration: LsDurations.lift,
        curve: LsCurves.easeSpring,
        transform: Matrix4.translationValues(0, lifted ? -4 : 0, 0),
        decoration: BoxDecoration(
          borderRadius: widget.borderRadius,
          boxShadow: lifted
              ? const [
                  // `0 28px 60px -26px rgba(0,20,40,0.6)`
                  BoxShadow(
                    color: Color(0x99001428),
                    offset: Offset(0, 28),
                    blurRadius: 60,
                    spreadRadius: -26,
                  ),
                ]
              : const [],
        ),
        child: widget.child,
      ),
    );
  }
}

/// `.ls-fadein` — the blur crossfade used for content revealed by an
/// expanding glass dropdown (§6.5).
///
/// Driven by an external [progress] so it stays locked to the expand
/// animation rather than running its own timeline. Reduced motion drops the
/// blur and keeps the fade.
class LsFadeIn extends StatelessWidget {
  const LsFadeIn({
    super.key,
    required this.child,
    required this.progress,
    this.blurSigma = 8,
  });

  final Widget child;

  /// 0 = hidden, 1 = fully revealed.
  final double progress;

  final double blurSigma;

  @override
  Widget build(BuildContext context) {
    final t = progress.clamp(0.0, 1.0);
    final faded = Opacity(opacity: t, child: child);
    if (t >= 1 || LsMotion.reduced(context)) return faded;

    final sigma = blurSigma * (1 - t);
    if (sigma <= 0.01) return faded;
    return ImageFiltered(
      imageFilter: ui.ImageFilter.blur(sigmaX: sigma, sigmaY: sigma),
      child: faded,
    );
  }
}

/// Count-up numbers — cubic ease-out, 750ms, **once, then stop**. No idle
/// motion on data (§8).
class LsCountUp extends StatefulWidget {
  const LsCountUp({
    super.key,
    required this.value,
    required this.builder,
    this.from = 0,
    this.enabled = true,
  });

  /// Target value.
  final double value;

  /// Starting value of the run.
  final double from;

  /// Renders the in-flight value.
  final Widget Function(BuildContext context, double value) builder;

  final bool enabled;

  @override
  State<LsCountUp> createState() => _LsCountUpState();
}

class _LsCountUpState extends State<LsCountUp>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller = AnimationController(
    vsync: this,
    duration: LsDurations.countUp,
  );

  late double _start = widget.from;
  bool _started = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_started) return;
    _started = true;
    if (!widget.enabled || LsMotion.reduced(context)) {
      _controller.value = 1;
    } else {
      _controller.forward();
    }
  }

  @override
  void didUpdateWidget(LsCountUp oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.value == widget.value) return;
    // A data change re-runs the count once from wherever it currently sits —
    // it still never loops.
    _start = _current(oldWidget.value);
    if (!widget.enabled || LsMotion.reduced(context)) {
      _controller.value = 1;
    } else {
      _controller.forward(from: 0);
    }
  }

  double _current(double target) {
    final t = LsCurves.easeOut.transform(_controller.value.clamp(0.0, 1.0));
    return _start + (target - _start) * t;
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, _) => widget.builder(context, _current(widget.value)),
    );
  }
}
