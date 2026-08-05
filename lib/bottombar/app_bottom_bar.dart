import 'package:flutter/material.dart';

import '../theme/app_theme.dart';
import '../theme/lightsignal/ls_css.dart';
import '../theme/lightsignal/ls_tokens.dart';

/// One icon slot on [AppBottomBar]: an icon plus an optional badge count.
// class BottomBarItem {
//   const BottomBarItem({required this.icon, this.badgeCount, this.image,}): assert(
//           icon != null || image != null,
//           'Either icon or image must be provided',
//         );

//   final IconData icon;
//   final String? image;
//   final int? badgeCount;
// }
class BottomBarItem {
  const BottomBarItem({this.icon, this.image, this.badgeCount})
    : assert(
        icon != null || image != null,
        'Either icon or image must be provided',
      );

  final IconData? icon;
  final String? image; // asset image path
  final int? badgeCount;
}

/// Pill-shaped frosted-glass bottom navigation bar with a selected-state
/// highlight and small count badges per icon.
class AppBottomBar extends StatelessWidget {
  const AppBottomBar({
    super.key,
    required this.items,
    required this.selectedIndex,
    required this.onTap,
  });

  final List<BottomBarItem> items;
  final int selectedIndex;
  final ValueChanged<int> onTap;

  /// `border-radius: 999px`
  static const BorderRadius _radius = BorderRadius.all(Radius.circular(999));

  /// `background: linear-gradient(160deg, rgba(255,255,255,.17),
  /// rgba(255,255,255,.055))`
  static final Gradient _fill = LsCss.linearGradient(
    degrees: 160,
    colors: const [Color(0x2BFFFFFF), Color(0x0EFFFFFF)],
  );

  /// `backdrop-filter: blur(22px) saturate(1.3)`
  static const double _backdropBlur = 22;
  static const double _backdropSaturate = 1.3;

  /// `border: 1px solid rgba(255,255,255,.22)`
  static const Color _borderColor = Color(0x38FFFFFF);

  /// `box-shadow: 0 30px 70px -30px rgba(0,15,30,.6)`
  static const List<BoxShadow> _outerShadows = <BoxShadow>[
    BoxShadow(
      color: Color(0x99000F1E),
      offset: Offset(0, 30),
      blurRadius: 70,
      spreadRadius: -30,
    ),
  ];

  /// `inset 0 1.5px 1px rgba(255,255,255,.42)`
  static const List<LsInsetShadow> _insetShadows = <LsInsetShadow>[
    LsInsetShadow(offset: Offset(0, 1.5), blur: 1, color: Color(0x6BFFFFFF)),
  ];

  @override
  Widget build(BuildContext context) {
    final bar = ClipRRect(
      borderRadius: _radius,
      child: BackdropFilter(
        filter: lsBackdropFilter(
          blur: _backdropBlur,
          saturate: _backdropSaturate,
        ),
        child: CustomPaint(
          painter: LsInsetShadowPainter(
            borderRadius: _radius,
            fills: [_fill],
            shadows: _insetShadows,
          ),
          child: DecoratedBox(
            // The 1px border sits inside the box, as in CSS.
            position: DecorationPosition.foreground,
            decoration: BoxDecoration(
              borderRadius: _radius,
              border: Border.all(color: _borderColor, width: 1),
            ),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: List.generate(items.length, (index) {
                  // Each slot is 54px at rest (46 + 4 padding a side). Six of
                  // them plus the bar's own padding outgrow a ~360pt screen,
                  // so let them share the width and shrink a little rather
                  // than overflow — the SizedBox inside clamps to whatever
                  // the Flexible offers.
                  return Flexible(
                    child: _BottomBarButton(
                      item: items[index],
                      isSelected: index == selectedIndex,
                      onTap: () => onTap(index),
                    ),
                  );
                }),
              ),
            ),
          ),
        ),
      ),
    );

    // The drop shadow must sit outside the clip that contains the blur.
    return DecoratedBox(
      decoration: const BoxDecoration(
        borderRadius: _radius,
        boxShadow: _outerShadows,
      ),
      child: bar,
    );
  }
}

class _BottomBarButton extends StatelessWidget {
  const _BottomBarButton({
    required this.item,
    required this.isSelected,
    required this.onTap,
  });

  final BottomBarItem item;
  final bool isSelected;
  final VoidCallback onTap;

  /// `height: 46px` — with `border-radius: 999px` this reads as a circle.
  static const double _size = 46;

  /// `border-radius: 999px`
  static const BorderRadius _radius = BorderRadius.all(Radius.circular(999));

  /// Selected fill —
  /// `linear-gradient(160deg, rgba(255,255,255,.2), rgba(255,255,255,.07))`.
  /// The base state is `background: transparent`, so the fill fades in.
  static const Color _fillFrom = Color(0x33FFFFFF);
  static const Color _fillTo = Color(0x12FFFFFF);

  /// `box-shadow: 0 0 24px -6px rgba(0,16,30,.5)`
  static const Color _dropColor = Color(0x8000101E);

  /// `inset 0 1px 1px rgba(255,255,255,.42)`
  static const Color _insetColor = Color(0x6BFFFFFF);

  /// `transition: background 160ms var(--ease-out),
  /// box-shadow 160ms var(--ease-out)`
  static const Duration _stateTransition = Duration(milliseconds: 160);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      customBorder: const CircleBorder(),
      child: Padding(
        padding: const EdgeInsets.all(4),
        child: Stack(
          clipBehavior: Clip.none,
          children: [
            // Both the fill and the two shadows cross-fade together, so a
            // single 0 -> 1 selection value drives all of them.
            TweenAnimationBuilder<double>(
              tween: Tween<double>(end: isSelected ? 1 : 0),
              duration: _stateTransition,
              curve: LsCurves.easeOut,
              builder: (context, t, child) {
                return DecoratedBox(
                  decoration: BoxDecoration(
                    borderRadius: _radius,
                    boxShadow: [
                      BoxShadow(
                        color: _dropColor.withValues(
                          alpha: _dropColor.a * t,
                        ),
                        blurRadius: 24,
                        spreadRadius: -6,
                      ),
                    ],
                  ),
                  child: CustomPaint(
                    painter: LsInsetShadowPainter(
                      borderRadius: _radius,
                      fills: [
                        LsCss.linearGradient(
                          degrees: 160,
                          colors: [
                            _fillFrom.withValues(alpha: _fillFrom.a * t),
                            _fillTo.withValues(alpha: _fillTo.a * t),
                          ],
                        ),
                      ],
                      shadows: [
                        LsInsetShadow(
                          offset: const Offset(0, 1),
                          blur: 1,
                          color: _insetColor.withValues(
                            alpha: _insetColor.a * t,
                          ),
                        ),
                      ],
                    ),
                    child: child,
                  ),
                );
              },
              child: SizedBox(
                width: _size,
                height: _size,
                // `display: flex; align-items: center; justify-content: center`
                child: Center(
                  child: item.image != null
                      ? Image.asset(
                          item.image!,
                          width: 30,
                          height: 30,
                          color: AppColors.white,
                        )
                      : Icon(item.icon, size: 20, color: AppColors.white),
                ),
              ),
            ),
            if (item.badgeCount != null)
              Positioned(
                top: -2,
                right: -2,
                child: Container(
                  padding: const EdgeInsets.all(3),
                  constraints: const BoxConstraints(
                    minWidth: 18,
                    minHeight: 18,
                  ),
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: AppColors.white,
                    shape: BoxShape.circle,
                    border: Border.all(color: AppColors.glassDark, width: 1.5),
                  ),
                  child: Text(
                    '${item.badgeCount}',
                    style: const TextStyle(
                      color: AppColors.baseDeep,
                      fontSize: 10,
                      fontWeight: FontWeight.w800,
                      height: 1,
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
