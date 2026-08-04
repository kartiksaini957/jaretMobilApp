import 'package:flutter/widgets.dart';

/// LightSignal Visual Foundation v2 — "Deep Cyan Glass" design tokens.
///
/// Direct port of §1 (color), §2 (field) and §8 (motion) of the
/// `LightSignal Visual Foundation v2` spec.
///
/// Rule of thumb from §0: add light to the dark, never wash it out. To reduce
/// an "ominous/empty" feel, raise the field's luminosity (glows, motes) —
/// do not lighten the base.
class LsColors {
  LsColors._();

  // ── §1 Color tokens ───────────────────────────────────────────────────

  /// `--ls-fg` primary text (headlines, numbers).
  static const Color fg = Color(0xFFFFFFFF);

  /// `--ls-soft` secondary text — luminous cyan-tint (NOT gray-white).
  /// Small-text safe.
  static const Color soft = Color(0xFFCFEFFB);

  /// `--ls-mute` DECORATIVE / large text only — fails 4.5:1, NEVER on small
  /// text. Use [soft] for small secondary text.
  static const Color mute = Color(0xFFA7DCF0);

  /// `--ls-good` mint-positive — LARGE text only (>= 18px).
  static const Color good = Color(0xFF7BEFD0);

  /// `--ls-goodText` small-text-safe positive mint — positive text <= 17px.
  static const Color goodText = Color(0xFFA6F5DC);

  /// `--ls-warn` warning amber.
  static const Color warn = Color(0xFFFFD98A);

  /// `--ls-accent` bright cyan "signal" — primary buttons, active nav, focus.
  /// Large text / non-text only.
  static const Color accent = Color(0xFF5FE0FF);

  /// `--ls-ink` text/icon color ON a bright accent or severity surface.
  static const Color ink = Color(0xFF04303F);

  /// Field hue anchor — brand cyan. Used as a glow / light source, never as
  /// a flat fill.
  static const Color brand = Color(0xFF05C5FA);

  // ── §1 Severity / status colors (locked set) ──────────────────────────

  /// critical / pressing.
  static const Color critical = Color(0xFFFF5757);

  /// building / drift.
  static const Color building = Color(0xFFFFD466);

  /// stable / affirmative.
  static const Color stable = Color(0xFFFFFFFF);

  /// resolved.
  static const Color resolved = Color(0xFF26C281);

  // ── §2 Field stops ────────────────────────────────────────────────────

  /// Base floor — deliberately lifted from near-black to kill the "void"
  /// feel. Do not go darker.
  static const Color fieldBase0 = Color(0xFF064A63);
  static const Color fieldBase1 = Color(0xFF05688A);
  static const Color fieldBase2 = Color(0xFF0892C0);

  /// The light sources. Keep them.
  static const Color fieldGlow0 = Color(0xFF2BD4FF);
  static const Color fieldGlow1 = Color(0xFF18A8DC);
  static const Color fieldGlow2 = Color(0xFF0E9ED0);
  static const Color fieldGlow3 = Color(0xFF1AAEDE);
  static const Color fieldGlow4 = Color(0xFF4FE2FF);
}

/// §8 motion easing curves.
class LsCurves {
  LsCurves._();

  /// `--ease-out: cubic-bezier(0.23, 1, 0.32, 1)`.
  static const Cubic easeOut = Cubic(0.23, 1, 0.32, 1);

  /// `--ease-in-out: cubic-bezier(0.77, 0, 0.175, 1)`.
  static const Cubic easeInOut = Cubic(0.77, 0, 0.175, 1);

  /// `--ease-spring: cubic-bezier(0.34, 1.56, 0.64, 1)`.
  static const Cubic easeSpring = Cubic(0.34, 1.56, 0.64, 1);
}

/// §8 motion durations used by the field's decorative layers.
class LsDurations {
  LsDurations._();

  /// Flowing light streak drift — constant motion, so linear.
  static const Duration streakDrift = Duration(seconds: 26);
}
