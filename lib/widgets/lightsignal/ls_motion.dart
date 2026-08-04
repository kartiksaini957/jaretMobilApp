import 'package:flutter/widgets.dart';

/// §8 Motion helpers for the field's decorative layers.
///
/// Hard rules from the spec: animate transform/opacity only, keep everything
/// on the GPU, and honour `prefers-reduced-motion` — the reduced-motion block
/// disables the streaks and the motes.
class LsMotion {
  LsMotion._();

  /// `@media (prefers-reduced-motion: reduce)`.
  static bool reduced(BuildContext context) =>
      MediaQuery.disableAnimationsOf(context);
}
