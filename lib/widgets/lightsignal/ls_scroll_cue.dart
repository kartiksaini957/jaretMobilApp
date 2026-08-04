import 'package:flutter/widgets.dart';

import '../../theme/lightsignal/ls_css.dart';
import '../../theme/lightsignal/ls_tokens.dart';
import '../../theme/lightsignal/ls_typography.dart';
import 'ls_motion.dart';

/// §6.6 Scroll cue — the "more below" affordance.
///
/// For a tab whose primary content can fall below the fold under a tall hero:
/// a bottom fade plus a small frosted pill that smooth-scrolls, with a
/// chevron that bobs. Both fade out once the bottom is reached.
///
/// Place it as the last child of a [Stack] over the scrolling content.
class LsScrollCue extends StatefulWidget {
  const LsScrollCue({
    super.key,
    required this.controller,
    this.label = 'More below',
    this.onTap,
    this.bottomInset = 18,
    this.scrollDuration = const Duration(milliseconds: 420),
  });

  final ScrollController controller;
  final String label;

  /// Overrides the default "scroll to the bottom" behaviour.
  final VoidCallback? onTap;

  /// Gap between the pill and the bottom of the safe area.
  final double bottomInset;

  final Duration scrollDuration;

  /// `height: 96px`
  static const double fadeHeight = 96;

  /// `linear-gradient(to top, rgba(4,40,56,0.55), transparent)`
  static const Color fadeColor = Color(0x8C042838);

  /// Pill fill — `rgba(8,40,56,0.6)`.
  static const Color pillFill = Color(0x99082838);

  /// Pill border — `rgba(255,255,255,0.28)`.
  static const Color pillBorder = Color(0x47FFFFFF);

  static const double pillBlur = 12;

  @override
  State<LsScrollCue> createState() => _LsScrollCueState();
}

class _LsScrollCueState extends State<LsScrollCue> {
  bool _atBottom = true;

  @override
  void initState() {
    super.initState();
    widget.controller.addListener(_onScroll);
    WidgetsBinding.instance.addPostFrameCallback((_) => _onScroll());
  }

  @override
  void didUpdateWidget(LsScrollCue oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.controller != widget.controller) {
      oldWidget.controller.removeListener(_onScroll);
      widget.controller.addListener(_onScroll);
    }
  }

  @override
  void dispose() {
    widget.controller.removeListener(_onScroll);
    super.dispose();
  }

  void _onScroll() {
    if (!mounted || !widget.controller.hasClients) return;
    final position = widget.controller.position;
    // A hair of tolerance so the cue clears on the last pixel of travel.
    final atBottom = position.pixels >= position.maxScrollExtent - 1;
    if (atBottom == _atBottom) return;
    setState(() => _atBottom = atBottom);
  }

  void _scrollDown() {
    if (widget.onTap != null) {
      widget.onTap!();
      return;
    }
    if (!widget.controller.hasClients) return;
    widget.controller.animateTo(
      widget.controller.position.maxScrollExtent,
      duration: widget.scrollDuration,
      curve: LsCurves.easeOut,
    );
  }

  @override
  Widget build(BuildContext context) {
    final visible = !_atBottom;
    final bottomPadding = MediaQuery.paddingOf(context).bottom;

    return Positioned(
      left: 0,
      right: 0,
      bottom: 0,
      child: AnimatedOpacity(
        opacity: visible ? 1 : 0,
        duration: LsDurations.scrollCue,
        curve: LsCurves.easeOut,
        child: IgnorePointer(
          ignoring: !visible,
          child: Stack(
            alignment: Alignment.bottomCenter,
            children: [
              IgnorePointer(
                child: Container(
                  height: LsScrollCue.fadeHeight + bottomPadding,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.bottomCenter,
                      end: Alignment.topCenter,
                      colors: [
                        LsScrollCue.fadeColor,
                        LsCss.fadeOut(LsScrollCue.fadeColor),
                      ],
                    ),
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.only(
                  bottom: widget.bottomInset + bottomPadding,
                ),
                child: _ScrollCuePill(
                  label: widget.label,
                  onTap: _scrollDown,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _ScrollCuePill extends StatelessWidget {
  const _ScrollCuePill({required this.label, required this.onTap});

  final String label;
  final VoidCallback onTap;

  static const BorderRadius _radius =
      BorderRadius.all(Radius.circular(LsRadii.pill));

  @override
  Widget build(BuildContext context) {
    return LsPressable(
      onTap: onTap,
      semanticLabel: label,
      child: ClipRRect(
        borderRadius: _radius,
        child: BackdropFilter(
          filter: lsBackdropFilter(
            blur: LsScrollCue.pillBlur,
            saturate: 1.0,
          ),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
            decoration: BoxDecoration(
              color: LsScrollCue.pillFill,
              borderRadius: _radius,
              border: Border.all(color: LsScrollCue.pillBorder, width: 1),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  label,
                  style: LsType.body(fontSize: 13).copyWith(
                    fontWeight: FontWeight.w600,
                    color: LsColors.soft,
                  ),
                ),
                const SizedBox(width: 8),
                const LsScrollChevron(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

/// `.scrollchev` — `chevbob 1.8s var(--ease-in-out) infinite`, a 3px bob.
class LsScrollChevron extends StatefulWidget {
  const LsScrollChevron({super.key});

  @override
  State<LsScrollChevron> createState() => _LsScrollChevronState();
}

class _LsScrollChevronState extends State<LsScrollChevron>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller = AnimationController(
    vsync: this,
    duration: LsDurations.chevBob,
  );

  bool _running = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final shouldRun = !LsMotion.reduced(context);
    if (shouldRun == _running) return;
    _running = shouldRun;
    if (shouldRun) {
      // 0%,100% translateY(0), 50% translateY(3px) — a reversing half-cycle.
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
    final chevron = Text(
      '↓',
      style: LsType.body(fontSize: 13).copyWith(
        fontWeight: FontWeight.w700,
        color: LsColors.soft,
        height: 1,
      ),
    );

    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) => Transform.translate(
        offset: Offset(0, 3 * LsCurves.easeInOut.transform(_controller.value)),
        child: child,
      ),
      child: chevron,
    );
  }
}
