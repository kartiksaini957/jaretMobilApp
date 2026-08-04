import 'package:flutter/widgets.dart';

import '../../theme/lightsignal/ls_css.dart';
import '../../theme/lightsignal/ls_tokens.dart';
import '../../theme/lightsignal/ls_typography.dart';
import 'ls_glass.dart';
import 'ls_motion.dart';
import 'ls_states.dart';

/// Rebuilds [builder] with the current hover state.
///
/// Flutter only reports hover for real pointer devices, which is exactly the
/// gate `@media (hover:hover) and (pointer:fine)` applies in the spec.
class LsHoverBuilder extends StatefulWidget {
  const LsHoverBuilder({super.key, required this.builder, this.enabled = true});

  final Widget Function(BuildContext context, bool hovered) builder;
  final bool enabled;

  @override
  State<LsHoverBuilder> createState() => _LsHoverBuilderState();
}

class _LsHoverBuilderState extends State<LsHoverBuilder> {
  bool _hovered = false;

  void _set(bool value) {
    if (_hovered == value) return;
    setState(() => _hovered = value);
  }

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: widget.enabled ? (_) => _set(true) : null,
      onExit: widget.enabled ? (_) => _set(false) : null,
      child: widget.builder(context, _hovered && widget.enabled),
    );
  }
}

/// §6.1 Primary button — `.glassbtn`.
///
/// A lit cyan glass surface, never a solid fill. Hover brightens the fill; it
/// does not go opaque.
class LsGlassButton extends StatelessWidget {
  const LsGlassButton({
    super.key,
    required this.label,
    required this.onPressed,
    this.icon,
    this.padding = const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
    this.borderRadius =
        const BorderRadius.all(Radius.circular(LsRadii.pill)),
    this.expand = false,
    this.fontSize = 15,
  });

  final String label;
  final VoidCallback? onPressed;
  final Widget? icon;
  final EdgeInsetsGeometry padding;
  final BorderRadius borderRadius;

  /// Stretch to the available width.
  final bool expand;

  final double fontSize;

  /// `linear-gradient(160deg, rgba(95,224,255,0.34), rgba(95,224,255,0.14))`
  static final Gradient fill = LsCss.linearGradient(
    degrees: 160,
    colors: const [Color(0x575FE0FF), Color(0x245FE0FF)],
  );

  /// `:hover` — brighten, not solid.
  static final Gradient fillHover = LsCss.linearGradient(
    degrees: 160,
    colors: const [Color(0x755FE0FF), Color(0x335FE0FF)],
  );

  /// `.glassbtn::before` — 1.25px rim at 150deg.
  static final Gradient rimGradient = LsCss.linearGradient(
    degrees: 150,
    colors: const [
      Color(0xFFFFFFFF),
      Color(0x99B4F5FF),
      Color(0xB35FE0FF),
    ],
    stops: const [0.0, 0.45, 1.0],
  );

  static const List<BoxShadow> outerShadows = <BoxShadow>[
    // 0 8px 26px -10px rgba(5,197,250,0.5)
    BoxShadow(
      color: Color(0x8005C5FA),
      offset: Offset(0, 8),
      blurRadius: 26,
      spreadRadius: -10,
    ),
  ];

  static const List<LsInsetShadow> insetShadows = <LsInsetShadow>[
    // inset 0 1px 0 rgba(255,255,255,0.6)
    LsInsetShadow(offset: Offset(0, 1), color: Color(0x99FFFFFF)),
    // inset 0 0 18px -6px rgba(150,240,255,0.7)
    LsInsetShadow(blur: 18, spread: -6, color: Color(0xB396F0FF)),
  ];

  @override
  Widget build(BuildContext context) {
    final enabled = onPressed != null;

    return LsFocusRing(
      borderRadius: borderRadius,
      onPressed: onPressed,
      child: LsPressable(
        onTap: onPressed,
        semanticLabel: label,
        child: LsHoverBuilder(
          enabled: enabled,
          builder: (context, hovered) {
            return AnimatedOpacity(
              duration: LsDurations.press,
              opacity: enabled ? 1 : 0.55,
              child: LsGlassLayer(
                borderRadius: borderRadius,
                fills: [hovered ? fillHover : fill],
                insetShadows: insetShadows,
                outerShadows: outerShadows,
                rimGradient: rimGradient,
                blur: 10,
                saturate: 1.5,
                padding: padding,
                child: Row(
                  mainAxisSize: expand ? MainAxisSize.max : MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    if (icon != null) ...[
                      icon!,
                      const SizedBox(width: 8),
                    ],
                    Flexible(
                      child: Text(
                        label,
                        textAlign: TextAlign.center,
                        // White label paired with `.pop`.
                        style: LsType.button(fontSize: fontSize),
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}

/// §6.2 Nav item — `.navglass` when active (a lit glass pill with white
/// text), `--ls-soft` text when inactive.
class LsNavItem extends StatelessWidget {
  const LsNavItem({
    super.key,
    required this.label,
    required this.active,
    required this.onPressed,
    this.icon,
    this.padding = const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
    this.borderRadius =
        const BorderRadius.all(Radius.circular(LsRadii.pill)),
    this.fontSize = 14,
  });

  final String label;
  final bool active;
  final VoidCallback? onPressed;
  final Widget? icon;
  final EdgeInsetsGeometry padding;
  final BorderRadius borderRadius;
  final double fontSize;

  /// `linear-gradient(160deg, rgba(95,224,255,0.26), rgba(95,224,255,0.1))`
  static final Gradient fill = LsCss.linearGradient(
    degrees: 160,
    colors: const [Color(0x425FE0FF), Color(0x1A5FE0FF)],
  );

  /// `.navglass::before` — 1px rim at 150deg.
  static final Gradient rimGradient = LsCss.linearGradient(
    degrees: 150,
    colors: const [Color(0xE6FFFFFF), Color(0x805FE0FF)],
  );

  static const List<BoxShadow> outerShadows = <BoxShadow>[
    // 0 6px 18px -10px rgba(5,197,250,0.45)
    BoxShadow(
      color: Color(0x7305C5FA),
      offset: Offset(0, 6),
      blurRadius: 18,
      spreadRadius: -10,
    ),
  ];

  static const List<LsInsetShadow> insetShadows = <LsInsetShadow>[
    // inset 0 1px 0 rgba(255,255,255,0.5)
    LsInsetShadow(offset: Offset(0, 1), color: Color(0x80FFFFFF)),
    // inset 0 0 16px -6px rgba(150,240,255,0.6)
    LsInsetShadow(blur: 16, spread: -6, color: Color(0x9996F0FF)),
  ];

  /// `.ls-nav:not(.on):hover { background: rgba(255,255,255,0.1) }`
  static final Gradient inactiveHoverFill = LsCss.linearGradient(
    degrees: 160,
    colors: const [Color(0x1AFFFFFF), Color(0x1AFFFFFF)],
  );

  @override
  Widget build(BuildContext context) {
    return LsFocusRing(
      borderRadius: borderRadius,
      onPressed: onPressed,
      child: LsPressable(
        onTap: onPressed,
        semanticLabel: label,
        child: LsHoverBuilder(
          builder: (context, hovered) {
            final content = Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                if (icon != null) ...[
                  icon!,
                  const SizedBox(width: 8),
                ],
                Text(
                  label,
                  style: LsType.body(fontSize: fontSize).copyWith(
                    fontWeight: FontWeight.w600,
                    // Active nav is white text; inactive is `--ls-soft`, and
                    // brightens to white on hover.
                    color: active || hovered ? LsColors.fg : LsColors.soft,
                    shadows: active ? LsType.pop : LsType.darktext,
                  ),
                ),
              ],
            );

            if (active) {
              return LsGlassLayer(
                borderRadius: borderRadius,
                fills: [fill],
                insetShadows: insetShadows,
                outerShadows: outerShadows,
                rimGradient: rimGradient,
                rimWidth: 1,
                blur: 8,
                saturate: 1.4,
                padding: padding,
                child: content,
              );
            }

            return LsGlassLayer(
              borderRadius: borderRadius,
              fills: hovered ? [inactiveHoverFill] : const <Gradient>[],
              padding: padding,
              child: content,
            );
          },
        ),
      ),
    );
  }
}

/// §6.3 Status / info pill — `.pillglass`.
///
/// The rim is tinted toward the pill's status color; the fill stays neutral.
class LsPill extends StatelessWidget {
  const LsPill({
    super.key,
    required this.label,
    this.statusColor = LsColors.good,
    this.leading,
    this.onPressed,
    this.padding = const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
    this.textStyle,
  });

  final String label;

  /// Tints the rim. Defaults to the "good" mint shown in the spec.
  final Color statusColor;

  final Widget? leading;
  final VoidCallback? onPressed;
  final EdgeInsetsGeometry padding;
  final TextStyle? textStyle;

  static const BorderRadius _radius =
      BorderRadius.all(Radius.circular(LsRadii.pill));

  /// `linear-gradient(160deg, rgba(255,255,255,0.12), rgba(255,255,255,0.04))`
  static final Gradient fill = LsCss.linearGradient(
    degrees: 160,
    colors: const [Color(0x1FFFFFFF), Color(0x0AFFFFFF)],
  );

  static const List<LsInsetShadow> insetShadows = <LsInsetShadow>[
    // inset 0 1px 0 rgba(255,255,255,0.4)
    LsInsetShadow(offset: Offset(0, 1), color: Color(0x66FFFFFF)),
  ];

  /// `.pillglass::before` — white to the status color at 50% alpha.
  static Gradient rimGradientFor(Color statusColor) => LsCss.linearGradient(
        degrees: 150,
        colors: [
          const Color(0xB3FFFFFF),
          statusColor.withValues(alpha: 0.5),
        ],
      );

  @override
  Widget build(BuildContext context) {
    final pill = LsGlassLayer(
      borderRadius: _radius,
      fills: [fill],
      insetShadows: insetShadows,
      rimGradient: rimGradientFor(statusColor),
      rimWidth: 1,
      blur: 10,
      saturate: 1.3,
      padding: padding,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (leading != null) ...[
            leading!,
            const SizedBox(width: 6),
          ],
          Text(
            label,
            style: textStyle ??
                LsType.eyebrow(fontSize: 11.5, tracking: 0.05).copyWith(
                  color: LsColors.soft,
                ),
          ),
        ],
      ),
    );

    if (onPressed == null) return pill;
    return LsFocusRing(
      borderRadius: _radius,
      onPressed: onPressed,
      child: LsPressable(onTap: onPressed, semanticLabel: label, child: pill),
    );
  }
}

/// §6.4 Quiet / tertiary button — `.ls-soft-btn`.
///
/// For low-emphasis actions that must recede. No glass body — just a
/// hairline border that brightens on hover.
class LsSoftButton extends StatelessWidget {
  const LsSoftButton({
    super.key,
    required this.label,
    required this.onPressed,
    this.icon,
    this.padding = const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
    this.borderRadius =
        const BorderRadius.all(Radius.circular(LsRadii.pill)),
    this.fontSize = 13.5,
  });

  final String label;
  final VoidCallback? onPressed;
  final Widget? icon;
  final EdgeInsetsGeometry padding;
  final BorderRadius borderRadius;
  final double fontSize;

  static const Color _fill = Color(0x0AFFFFFF);
  static const Color _fillHover = Color(0x1AFFFFFF);
  static const Color _border = Color(0x2EFFFFFF);
  static const Color _borderHover = Color(0x52FFFFFF);

  @override
  Widget build(BuildContext context) {
    return LsFocusRing(
      borderRadius: borderRadius,
      onPressed: onPressed,
      child: LsPressable(
        onTap: onPressed,
        semanticLabel: label,
        child: LsHoverBuilder(
          enabled: onPressed != null,
          builder: (context, hovered) {
            return AnimatedContainer(
              duration: LsDurations.press,
              curve: LsCurves.easeOut,
              padding: padding,
              decoration: BoxDecoration(
                color: hovered ? _fillHover : _fill,
                borderRadius: borderRadius,
                border: Border.all(
                  color: hovered ? _borderHover : _border,
                  width: 1,
                ),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  if (icon != null) ...[
                    icon!,
                    const SizedBox(width: 8),
                  ],
                  Text(
                    label,
                    style: LsType.body(fontSize: fontSize).copyWith(
                      fontWeight: FontWeight.w600,
                      color: hovered ? LsColors.fg : LsColors.soft,
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
