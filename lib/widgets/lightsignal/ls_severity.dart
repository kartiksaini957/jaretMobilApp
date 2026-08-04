import 'package:flutter/widgets.dart';

import '../../theme/lightsignal/ls_tokens.dart';
import '../../theme/lightsignal/ls_typography.dart';
import 'ls_motion.dart';

/// §7 Severity & illumination — the locked cross-tab rule.
///
/// A **colored glow** (halo, bloom, breathing pulse, colored background wash
/// or colored border) is permitted on **KPI metric tiles only**
/// ([LsSevPulse], [LsKpiSeverityBadge]). Everywhere else severity is carried
/// by a plain solid dot's color ([LsSeverityDot]) and, where needed, bold
/// text — no halo, no breathing, no background tint, no colored border.
///
/// The earlier breathing-`flagdot` treatment is superseded: a colored halo on
/// a bullet reads as a rendering defect on the deep-cyan field and breaks the
/// "one bold element" discipline.
class LsSeverityDot extends StatelessWidget {
  const LsSeverityDot({
    super.key,
    required this.color,
    this.size = sectionSize,
    this.opacity = 1.0,
  });

  /// Section / reminder dot — 9x9.
  const LsSeverityDot.section({super.key, required this.color})
      : size = sectionSize,
        opacity = 1.0;

  /// Flag / in-list dot — 8x8.
  const LsSeverityDot.inList({super.key, required this.color})
      : size = inListSize,
        opacity = 1.0;

  /// Context ("what changed") dot — 6x6 at 0.8 opacity.
  const LsSeverityDot.context({super.key, required this.color})
      : size = contextSize,
        opacity = 0.8;

  final Color color;
  final double size;
  final double opacity;

  static const double sectionSize = 9;
  static const double inListSize = 8;
  static const double contextSize = 6;

  @override
  Widget build(BuildContext context) {
    // Color is the ONLY signal: no box-shadow, no glow, no animation.
    return SizedBox(
      width: size,
      height: size,
      child: DecoratedBox(
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: opacity == 1.0 ? color : color.withValues(alpha: opacity),
        ),
      ),
    );
  }
}

/// §7.2 `.sevpulse` — the KPI tile halo. **The only place a colored glow is
/// allowed.**
///
/// Draws a breathing colored halo around a KPI metric tile to pull the eye to
/// a number that needs attention. Under reduced motion the halo stays static
/// at its base opacity.
class LsSevPulse extends StatefulWidget {
  const LsSevPulse({
    super.key,
    required this.child,
    required this.severity,
    required this.borderRadius,
    this.enabled = true,
  });

  final Widget child;

  /// `--sev`.
  final Color severity;

  /// `border-radius: inherit` — pass the tile's radius.
  final BorderRadius borderRadius;

  final bool enabled;

  /// `inset: -4px`
  static const double inset = 4;

  /// `box-shadow: 0 0 14px 2px var(--sev)`
  static const double blurRadius = 14;
  static const double spreadRadius = 2;

  /// The `::after` base opacity, used when the breathe animation is off.
  static const double baseOpacity = 0.5;

  @override
  State<LsSevPulse> createState() => _LsSevPulseState();
}

class _LsSevPulseState extends State<LsSevPulse>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller = AnimationController(
    vsync: this,
    duration: LsDurations.breathe,
  );

  bool _running = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _syncMotion();
  }

  @override
  void didUpdateWidget(LsSevPulse oldWidget) {
    super.didUpdateWidget(oldWidget);
    _syncMotion();
  }

  void _syncMotion() {
    final shouldRun = widget.enabled && !LsMotion.reduced(context);
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
    if (!widget.enabled) return widget.child;

    return Stack(
      clipBehavior: Clip.none,
      children: [
        Positioned(
          left: -LsSevPulse.inset,
          top: -LsSevPulse.inset,
          right: -LsSevPulse.inset,
          bottom: -LsSevPulse.inset,
          child: IgnorePointer(
            child: AnimatedBuilder(
              animation: _controller,
              builder: (context, _) {
                // @keyframes breathe — 0%,100% .3 -> 50% .85. The controller
                // reverses, so a single 0->1 ramp covers half the cycle.
                final opacity = _running
                    ? 0.3 +
                        (0.85 - 0.3) *
                            LsCurves.easeInOut.transform(_controller.value)
                    : LsSevPulse.baseOpacity;
                return DecoratedBox(
                  decoration: BoxDecoration(
                    borderRadius: widget.borderRadius,
                    boxShadow: [
                      BoxShadow(
                        color: widget.severity.withValues(alpha: opacity),
                        blurRadius: LsSevPulse.blurRadius,
                        spreadRadius: LsSevPulse.spreadRadius,
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
        ),
        widget.child,
      ],
    );
  }
}

/// §7.2 KPI severity badge — dark `--ls-ink` text on a solid severity fill
/// with a soft same-color glow. KPI tiles only.
class LsKpiSeverityBadge extends StatelessWidget {
  const LsKpiSeverityBadge({
    super.key,
    required this.label,
    required this.severity,
    this.padding = const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
  });

  final String label;
  final Color severity;
  final EdgeInsetsGeometry padding;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: padding,
      decoration: BoxDecoration(
        color: severity,
        borderRadius: const BorderRadius.all(Radius.circular(LsRadii.pill)),
        boxShadow: [
          // box-shadow: 0 0 10px -2px <sev>aa
          BoxShadow(
            color: severity.withValues(alpha: 0xAA / 0xFF),
            blurRadius: 10,
            spreadRadius: -2,
          ),
        ],
      ),
      child: Text(
        label,
        style: LsType.eyebrow(fontSize: 11, tracking: 0.06).copyWith(
          // Dark ink on a bright severity surface.
          color: LsColors.ink,
          shadows: const <Shadow>[],
        ),
      ),
    );
  }
}
