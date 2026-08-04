import 'package:flutter/material.dart';

import 'lightsignal/ls_field.dart';

/// Shared backdrop used by every screen — the LightSignal Visual Foundation
/// v2 field (§2): a deep cyan base with real tonal range, five luminous
/// glows so open areas read lit, and the decorative motion layers (flowing
/// light streaks + drifting motes) behind all glass.
///
/// Glass only reads as glass over a field like this, so every screen shares
/// it. See [LsField] for the recipe.
class GradientBackground extends StatelessWidget {
  const GradientBackground({
    super.key,
    required this.child,
    this.showStreaks = true,
    this.showMotes = true,
  });

  final Widget child;

  /// §4.1 flowing light streaks.
  final bool showStreaks;

  /// §4.2 drifting light motes.
  final bool showMotes;

  @override
  Widget build(BuildContext context) {
    return LsField(
      showStreaks: showStreaks,
      showMotes: showMotes,
      child: child,
    );
  }
}
