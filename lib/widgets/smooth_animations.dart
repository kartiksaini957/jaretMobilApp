import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

/// App-wide haptic feedback utility for smooth vibrations on screen switches,
/// tab changes, button taps, and micro-interactions.
class AppHaptics {
  AppHaptics._();

  /// Very light subtle vibration (ideal for screen navigation and drawer transitions).
  static void lightImpact() {
    try {
      HapticFeedback.lightImpact();
    } catch (_) {}
  }

  /// Medium tactile vibration for primary actions and confirmations.
  static void mediumImpact() {
    try {
      HapticFeedback.mediumImpact();
    } catch (_) {}
  }

  /// Delicate selection tick for tabs, pills, and chips.
  static void selectionClick() {
    try {
      HapticFeedback.selectionClick();
    } catch (_) {}
  }

  /// Standard short vibration.
  static void vibrate() {
    try {
      HapticFeedback.vibrate();
    } catch (_) {}
  }
}

/// Smooth staggered entrance animation widget.
/// Fades in and slides in with cubic bezier easing.
class SmoothFadeSlide extends StatefulWidget {
  const SmoothFadeSlide({
    super.key,
    required this.child,
    this.delay = Duration.zero,
    this.duration = const Duration(milliseconds: 380),
    this.curve = Curves.easeOutCubic,
    this.slideDistance = 18.0,
    this.direction = AxisDirection.up,
  });

  final Widget child;
  final Duration delay;
  final Duration duration;
  final Curve curve;
  final double slideDistance;
  final AxisDirection direction;

  @override
  State<SmoothFadeSlide> createState() => _SmoothFadeSlideState();
}

class _SmoothFadeSlideState extends State<SmoothFadeSlide>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _fadeAnimation;
  late final Animation<Offset> _slideAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: widget.duration,
    );

    _fadeAnimation = CurvedAnimation(
      parent: _controller,
      curve: widget.curve,
    );

    final double dx = switch (widget.direction) {
      AxisDirection.left => widget.slideDistance / 100,
      AxisDirection.right => -widget.slideDistance / 100,
      _ => 0.0,
    };
    final double dy = switch (widget.direction) {
      AxisDirection.up => widget.slideDistance / 100,
      AxisDirection.down => -widget.slideDistance / 100,
      _ => 0.0,
    };

    _slideAnimation = Tween<Offset>(
      begin: Offset(dx, dy),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: widget.curve,
    ));

    if (widget.delay == Duration.zero) {
      _controller.forward();
    } else {
      Future.delayed(widget.delay, () {
        if (mounted) {
          _controller.forward();
        }
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
    return FadeTransition(
      opacity: _fadeAnimation,
      child: SlideTransition(
        position: _slideAnimation,
        child: widget.child,
      ),
    );
  }
}

/// Smooth scale micro-interaction wrapper for cards, tiles, and buttons.
/// Scales slightly down on press and smoothly springs back on release.
class SmoothScaleTap extends StatefulWidget {
  const SmoothScaleTap({
    super.key,
    required this.child,
    this.onTap,
    this.onLongPress,
    this.scaleFactor = 0.96,
    this.duration = const Duration(milliseconds: 120),
    this.behavior = HitTestBehavior.opaque,
    this.enableHaptic = true,
  });

  final Widget child;
  final VoidCallback? onTap;
  final VoidCallback? onLongPress;
  final double scaleFactor;
  final Duration duration;
  final HitTestBehavior behavior;
  final bool enableHaptic;

  @override
  State<SmoothScaleTap> createState() => _SmoothScaleTapState();
}

class _SmoothScaleTapState extends State<SmoothScaleTap>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: widget.duration,
      reverseDuration: widget.duration,
    );
    _scaleAnimation = Tween<double>(
      begin: 1.0,
      end: widget.scaleFactor,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.easeOutCubic,
      reverseCurve: Curves.easeOutCubic,
    ));
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _onTapDown(TapDownDetails _) {
    if (widget.onTap != null || widget.onLongPress != null) {
      if (widget.enableHaptic) {
        AppHaptics.selectionClick();
      }
      _controller.forward();
    }
  }

  void _onTapUp(TapUpDetails _) {
    if (widget.onTap != null || widget.onLongPress != null) {
      _controller.reverse();
    }
  }

  void _onTapCancel() {
    if (widget.onTap != null || widget.onLongPress != null) {
      _controller.reverse();
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: widget.behavior,
      onTapDown: _onTapDown,
      onTapUp: _onTapUp,
      onTapCancel: _onTapCancel,
      onTap: widget.onTap,
      onLongPress: widget.onLongPress,
      child: ScaleTransition(
        scale: _scaleAnimation,
        child: widget.child,
      ),
    );
  }
}

/// Smooth page route with cubic bezier slide-up, fade transitions, and haptic feedback.
class SmoothPageRoute<T> extends PageRouteBuilder<T> {
  SmoothPageRoute({
    required WidgetBuilder builder,
    super.settings,
    Duration duration = const Duration(milliseconds: 280),
    Duration reverseDuration = const Duration(milliseconds: 240),
    bool enableHaptic = true,
  }) : super(
          pageBuilder: (context, animation, secondaryAnimation) {
            if (enableHaptic) {
              AppHaptics.lightImpact();
            }
            return builder(context);
          },
          transitionDuration: duration,
          reverseTransitionDuration: reverseDuration,
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            final curvedAnimation = CurvedAnimation(
              parent: animation,
              curve: Curves.easeOutCubic,
              reverseCurve: Curves.easeInCubic,
            );
            return FadeTransition(
              opacity: curvedAnimation,
              child: SlideTransition(
                position: Tween<Offset>(
                  begin: const Offset(0, 0.06),
                  end: Offset.zero,
                ).animate(curvedAnimation),
                child: child,
              ),
            );
          },
        );
}

/// Smooth animated switcher transition builder for switching tabs or views.
Widget smoothSlideFadeTransitionBuilder(
  Widget child,
  Animation<double> animation, {
  Offset beginOffset = const Offset(0.04, 0),
}) {
  final curvedAnimation = CurvedAnimation(
    parent: animation,
    curve: Curves.easeOutCubic,
    reverseCurve: Curves.easeInCubic,
  );
  return FadeTransition(
    opacity: curvedAnimation,
    child: SlideTransition(
      position: Tween<Offset>(
        begin: beginOffset,
        end: Offset.zero,
      ).animate(curvedAnimation),
      child: child,
    ),
  );
}

/// Gentle pulsing indicator badge for unread notifications / alerts.
class SmoothPulsingBadge extends StatefulWidget {
  const SmoothPulsingBadge({
    super.key,
    required this.child,
    this.duration = const Duration(milliseconds: 1400),
  });

  final Widget child;
  final Duration duration;

  @override
  State<SmoothPulsingBadge> createState() => _SmoothPulsingBadgeState();
}

class _SmoothPulsingBadgeState extends State<SmoothPulsingBadge>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: widget.duration,
    )..repeat(reverse: true);

    _scaleAnimation = Tween<double>(
      begin: 1.0,
      end: 1.18,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.easeInOutSine,
    ));
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ScaleTransition(
      scale: _scaleAnimation,
      child: widget.child,
    );
  }
}
