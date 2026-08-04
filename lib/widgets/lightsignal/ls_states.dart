import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';

import '../../theme/lightsignal/ls_css.dart';
import '../../theme/lightsignal/ls_tokens.dart';
import 'ls_motion.dart';

/// §9.1 Loading — skeleton (NOT spinners), shape-matched.
///
/// `.ls-skel` — a translucent block with a highlight sweeping across it.
/// Match the skeleton's shape to the content it stands in for.
class LsSkeleton extends StatefulWidget {
  const LsSkeleton({
    super.key,
    this.width,
    this.height = 14,
    this.borderRadius =
        const BorderRadius.all(Radius.circular(LsSkeleton.radius)),
  });

  final double? width;
  final double height;
  final BorderRadius borderRadius;

  /// `border-radius: 7px`
  static const double radius = 7;

  /// `background: rgba(255,255,255,0.1)`
  static const Color fill = Color(0x1AFFFFFF);

  /// The sweeping highlight — `rgba(255,255,255,0.22)`.
  static const Color highlight = Color(0x38FFFFFF);

  @override
  State<LsSkeleton> createState() => _LsSkeletonState();
}

class _LsSkeletonState extends State<LsSkeleton>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller = AnimationController(
    vsync: this,
    duration: LsDurations.shimmer,
  );

  bool _running = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // `@media (prefers-reduced-motion: reduce) { .ls-skel::after {
    //   animation: none } }`
    final shouldRun = !LsMotion.reduced(context);
    if (shouldRun == _running) return;
    _running = shouldRun;
    if (shouldRun) {
      _controller.repeat();
    } else {
      _controller.stop();
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return RepaintBoundary(
      child: ClipRRect(
        borderRadius: widget.borderRadius,
        child: SizedBox(
          width: widget.width,
          height: widget.height,
          child: DecoratedBox(
            decoration: BoxDecoration(
              color: LsSkeleton.fill,
              borderRadius: widget.borderRadius,
            ),
            child: _running
                ? AnimatedBuilder(
                    animation: _controller,
                    builder: (context, _) {
                      // translateX(-100%) -> translateX(100%)
                      final t = Curves.ease.transform(_controller.value);
                      return FractionalTranslation(
                        translation: Offset(-1 + 2 * t, 0),
                        child: const DecoratedBox(
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              begin: Alignment.centerLeft,
                              end: Alignment.centerRight,
                              colors: [
                                Color(0x00FFFFFF),
                                LsSkeleton.highlight,
                                Color(0x00FFFFFF),
                              ],
                            ),
                          ),
                          child: SizedBox.expand(),
                        ),
                      );
                    },
                  )
                : null,
          ),
        ),
      ),
    );
  }
}

/// §9.2 Keyboard focus — a double ring that reads on any glass. Required,
/// not optional.
///
/// Only shown for focus-visible (keyboard traversal), matching the CSS
/// pseudo-class.
class LsFocusRing extends StatefulWidget {
  const LsFocusRing({
    super.key,
    required this.child,
    required this.borderRadius,
    this.onPressed,
    this.focusNode,
    this.autofocus = false,
  });

  final Widget child;
  final BorderRadius borderRadius;

  /// Activated by Enter / Space while focused.
  final VoidCallback? onPressed;

  final FocusNode? focusNode;
  final bool autofocus;

  /// `outline: 2px solid #5FE0FF`
  static const double outlineWidth = 2;

  /// `outline-offset: 3px`
  static const double outlineOffset = 3;

  @override
  State<LsFocusRing> createState() => _LsFocusRingState();
}

class _LsFocusRingState extends State<LsFocusRing> {
  bool _showFocus = false;

  @override
  Widget build(BuildContext context) {
    return FocusableActionDetector(
      focusNode: widget.focusNode,
      autofocus: widget.autofocus,
      enabled: widget.onPressed != null,
      onShowFocusHighlight: (value) {
        if (_showFocus == value) return;
        setState(() => _showFocus = value);
      },
      shortcuts: const <ShortcutActivator, Intent>{
        SingleActivator(LogicalKeyboardKey.enter): ActivateIntent(),
        SingleActivator(LogicalKeyboardKey.space): ActivateIntent(),
      },
      actions: <Type, Action<Intent>>{
        ActivateIntent: CallbackAction<ActivateIntent>(
          onInvoke: (_) {
            widget.onPressed?.call();
            return null;
          },
        ),
      },
      child: CustomPaint(
        foregroundPainter: _showFocus
            ? _LsFocusRingPainter(borderRadius: widget.borderRadius)
            : null,
        child: widget.child,
      ),
    );
  }
}

class _LsFocusRingPainter extends CustomPainter {
  const _LsFocusRingPainter({required this.borderRadius});

  final BorderRadius borderRadius;

  /// `box-shadow: 0 0 0 4px rgba(5,30,45,0.6)` — the dark backing ring that
  /// makes the cyan outline legible on any glass.
  static const Color backingRing = Color(0x99051E2D);
  static const double backingRingWidth = 4;

  /// `0 0 14px #5FE0FF`
  static const double glowBlur = 14;

  @override
  void paint(Canvas canvas, Size size) {
    if (size.isEmpty) return;
    final rect = Offset.zero & size;

    // Dark backing ring sits directly against the element edge.
    final backing = borderRadius
        .toRRect(rect.inflate(backingRingWidth / 2))
        .scaleRadii();
    canvas.drawRRect(
      backing,
      Paint()
        ..style = PaintingStyle.stroke
        ..strokeWidth = backingRingWidth
        ..color = backingRing,
    );

    // Cyan outline, offset 3px outward, 2px thick.
    final outlineInset =
        LsFocusRing.outlineOffset + LsFocusRing.outlineWidth / 2;
    final outline =
        borderRadius.toRRect(rect.inflate(outlineInset)).scaleRadii();

    // The cyan glow.
    canvas.drawRRect(
      outline,
      Paint()
        ..style = PaintingStyle.stroke
        ..strokeWidth = LsFocusRing.outlineWidth
        ..color = LsColors.accent
        ..maskFilter = MaskFilter.blur(
          BlurStyle.normal,
          LsCss.blurRadiusToSigma(glowBlur),
        ),
    );

    canvas.drawRRect(
      outline,
      Paint()
        ..style = PaintingStyle.stroke
        ..strokeWidth = LsFocusRing.outlineWidth
        ..color = LsColors.accent,
    );
  }

  @override
  bool shouldRepaint(_LsFocusRingPainter oldDelegate) =>
      oldDelegate.borderRadius != borderRadius;
}
