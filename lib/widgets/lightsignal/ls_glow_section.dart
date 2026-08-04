import 'package:flutter/widgets.dart';

import '../../theme/lightsignal/ls_css.dart';
import '../../theme/lightsignal/ls_tokens.dart';
import '../../theme/lightsignal/ls_typography.dart';
import 'ls_glass.dart';
import 'ls_motion.dart';
import 'ls_severity.dart';
import 'ls_states.dart';

/// §6.5 Glass dropdown section — `.glowsec`.
///
/// A frosted-glass bar whose header **is** the dropdown; there is no separate
/// label above it. Collapsed means a steady white smoky glow — a "tap me /
/// unread" cue. Open means the glow goes off and the surface settles to quiet
/// flat glass.
///
/// All collapsed bars glow steadily and at once: no pulse, no stagger, no
/// color. Severity, if any, lives only in the small solid dot at the left
/// (§7.1) — never in the bar's glow or fill. This is the only "glowing to
/// invite a tap" treatment outside KPI tiles and it carries no color meaning.
class LsGlowSection extends StatefulWidget {
  const LsGlowSection({
    super.key,
    required this.title,
    required this.child,
    this.severity,
    this.count,
    this.open,
    this.initiallyOpen = false,
    this.onOpenChanged,
    this.headerPadding =
        const EdgeInsets.symmetric(horizontal: 14, vertical: 13),
    this.contentPadding = const EdgeInsets.fromLTRB(14, 0, 14, 14),
  });

  final String title;

  /// Revealed when open.
  final Widget child;

  /// Drives the left-hand solid dot. Omit for no dot.
  final Color? severity;

  /// Optional neutral count badge. Never filled with a severity color.
  final int? count;

  /// Controlled open state. Leave null to let the section own it.
  final bool? open;

  final bool initiallyOpen;
  final ValueChanged<bool>? onOpenChanged;

  final EdgeInsetsGeometry headerPadding;
  final EdgeInsetsGeometry contentPadding;

  static const BorderRadius borderRadius =
      BorderRadius.all(Radius.circular(LsRadii.section));

  // ── Collapsed surface ─────────────────────────────────────────────────

  /// The scrim floor — carried over from `.ls-glass` so header and body text
  /// pass WCAG over any field zone.
  static final Gradient scrim = LsCss.linearGradient(
    degrees: 160,
    colors: const [Color(0x4D082838), Color(0x4D082838)],
  );

  static final Gradient fill = LsCss.linearGradient(
    degrees: 160,
    colors: const [Color(0x21FFFFFF), Color(0x0FFFFFFF)],
  );

  static const Color borderColor = Color(0x47FFFFFF);

  static const List<LsInsetShadow> insetShadows = <LsInsetShadow>[
    // inset 0 1px 0 rgba(255,255,255,0.45)
    LsInsetShadow(offset: Offset(0, 1), color: Color(0x73FFFFFF)),
  ];

  // ── Open surface ──────────────────────────────────────────────────────

  static final Gradient openScrim = LsCss.linearGradient(
    degrees: 160,
    colors: const [Color(0x52082838), Color(0x52082838)],
  );

  static final Gradient openFill = LsCss.linearGradient(
    degrees: 160,
    colors: const [Color(0x16FFFFFF), Color(0x09FFFFFF)],
  );

  static const Color openBorderColor = Color(0x1FFFFFFF);

  static const List<LsInsetShadow> openInsetShadows = <LsInsetShadow>[
    // inset 0 1px 0 rgba(255,255,255,0.14)
    LsInsetShadow(offset: Offset(0, 1), color: Color(0x24FFFFFF)),
  ];

  static const List<BoxShadow> openOuterShadows = <BoxShadow>[
    // 0 8px 24px -16px rgba(0,20,40,0.5)
    BoxShadow(
      color: Color(0x80001428),
      offset: Offset(0, 8),
      blurRadius: 24,
      spreadRadius: -16,
    ),
  ];

  // ── The white smoky halo (`::before`) ─────────────────────────────────

  static const List<BoxShadow> glow = <BoxShadow>[
    // 0 0 32px 3px rgba(220,244,255,0.7)
    BoxShadow(color: Color(0xB3DCF4FF), blurRadius: 32, spreadRadius: 3),
    // 0 0 72px 12px rgba(198,236,255,0.45)
    BoxShadow(color: Color(0x73C6ECFF), blurRadius: 72, spreadRadius: 12),
  ];

  static const List<BoxShadow> glowHover = <BoxShadow>[
    // 0 0 40px 5px rgba(228,247,255,0.85)
    BoxShadow(color: Color(0xD9E4F7FF), blurRadius: 40, spreadRadius: 5),
    // 0 0 88px 16px rgba(206,240,255,0.55)
    BoxShadow(color: Color(0x8CCEF0FF), blurRadius: 88, spreadRadius: 16),
  ];

  /// `inset: -1px` on the `::before`.
  static const double glowInset = 1;

  static const double backdropBlur = 16;
  static const double backdropSaturate = 1.3;

  @override
  State<LsGlowSection> createState() => _LsGlowSectionState();
}

class _LsGlowSectionState extends State<LsGlowSection>
    with SingleTickerProviderStateMixin {
  late bool _open = widget.open ?? widget.initiallyOpen;
  bool _hovered = false;

  late final AnimationController _controller = AnimationController(
    vsync: this,
    duration: LsDurations.section,
    value: _open ? 1 : 0,
  );

  @override
  void didUpdateWidget(LsGlowSection oldWidget) {
    super.didUpdateWidget(oldWidget);
    final controlled = widget.open;
    if (controlled != null && controlled != _open) {
      _open = controlled;
      _animate();
    }
  }

  void _animate() {
    if (_open) {
      _controller.forward();
    } else {
      _controller.reverse();
    }
  }

  void _toggle() {
    final next = !_open;
    widget.onOpenChanged?.call(next);
    // Controlled sections wait for the parent to push the new value back.
    if (widget.open != null) return;
    setState(() => _open = next);
    _animate();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // `overflow: hidden` must never sit on the outer element — it would clip
    // the glow halo. The clip lives on the inner content wrapper only.
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, _) {
        final t = LsCurves.easeOut.transform(_controller.value);
        return Stack(
          clipBehavior: Clip.none,
          children: [
            Positioned(
              left: -LsGlowSection.glowInset,
              top: -LsGlowSection.glowInset,
              right: -LsGlowSection.glowInset,
              bottom: -LsGlowSection.glowInset,
              child: IgnorePointer(child: _buildGlow(t)),
            ),
            _buildSurface(context, t),
          ],
        );
      },
    );
  }

  /// The steady white halo. Only its opacity transitions (280ms), so the
  /// text above never re-rasterises.
  Widget _buildGlow(double t) {
    final opacity = 1 - t;
    if (opacity <= 0) return const SizedBox.shrink();
    return Opacity(
      opacity: opacity,
      child: DecoratedBox(
        decoration: BoxDecoration(
          borderRadius: LsGlowSection.borderRadius,
          boxShadow:
              _hovered ? LsGlowSection.glowHover : LsGlowSection.glow,
        ),
      ),
    );
  }

  Widget _buildSurface(BuildContext context, double t) {
    // background + border-color transition across 280ms.
    final scrim = Gradient.lerp(
      LsGlowSection.scrim,
      LsGlowSection.openScrim,
      t,
    )!;
    final fill = Gradient.lerp(
      LsGlowSection.fill,
      LsGlowSection.openFill,
      t,
    )!;
    final borderColor = Color.lerp(
      LsGlowSection.borderColor,
      LsGlowSection.openBorderColor,
      t,
    )!;
    final insetShadow = LsInsetShadow(
      offset: const Offset(0, 1),
      color: Color.lerp(
        LsGlowSection.insetShadows.first.color,
        LsGlowSection.openInsetShadows.first.color,
        t,
      )!,
    );
    final outerShadows = t == 0
        ? const <BoxShadow>[]
        : <BoxShadow>[
            BoxShadow.lerp(
              const BoxShadow(color: Color(0x00001428)),
              LsGlowSection.openOuterShadows.first,
              t,
            )!,
          ];

    return MouseRegion(
      onEnter: (_) => setState(() => _hovered = true),
      onExit: (_) => setState(() => _hovered = false),
      child: LsGlassLayer(
        borderRadius: LsGlowSection.borderRadius,
        fills: [scrim, fill],
        insetShadows: [insetShadow],
        outerShadows: outerShadows,
        border: BorderSide(color: borderColor, width: 1),
        blur: LsGlowSection.backdropBlur,
        saturate: LsGlowSection.backdropSaturate,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _buildHeader(t),
            // `grid-template-rows: 0fr -> 1fr`
            ClipRect(
              child: Align(
                alignment: Alignment.topCenter,
                heightFactor: t,
                child: t == 0
                    ? const SizedBox.shrink()
                    : LsFadeIn(
                        progress: t,
                        child: Padding(
                          padding: widget.contentPadding,
                          child: widget.child,
                        ),
                      ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(double t) {
    return LsFocusRing(
      borderRadius: LsGlowSection.borderRadius,
      onPressed: _toggle,
      child: LsPressable(
        onTap: _toggle,
        semanticLabel: widget.title,
        child: Padding(
          padding: widget.headerPadding,
          child: Row(
            children: [
              if (widget.severity != null) ...[
                // Severity lives here and nowhere else on this bar.
                LsSeverityDot.section(color: widget.severity!),
                const SizedBox(width: 10),
              ],
              Expanded(
                child: Text(
                  widget.title,
                  style: LsType.sectionTitle,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              if (widget.count != null) ...[
                const SizedBox(width: 10),
                _CountBadge(count: widget.count!),
              ],
              const SizedBox(width: 10),
              // Chevron rotates 180 degrees on open, 240ms.
              Transform.rotate(
                angle: 3.141592653589793 * t,
                child: Text(
                  '⌄',
                  style: LsType.body(fontSize: 15).copyWith(
                    color: LsColors.soft,
                    height: 1,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// The neutral count badge — `--ls-soft` text on `rgba(255,255,255,0.12)`
/// with a hairline border. Never a severity fill.
class _CountBadge extends StatelessWidget {
  const _CountBadge({required this.count});

  final int count;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 2),
      constraints: const BoxConstraints(minWidth: 20),
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: const Color(0x1FFFFFFF),
        borderRadius: const BorderRadius.all(Radius.circular(LsRadii.pill)),
        border: Border.all(color: const Color(0x2EFFFFFF), width: 1),
      ),
      child: Text(
        '$count',
        style: LsType.body(fontSize: 12).copyWith(
          fontWeight: FontWeight.w700,
          color: LsColors.soft,
          height: 1.2,
        ),
      ),
    );
  }
}
