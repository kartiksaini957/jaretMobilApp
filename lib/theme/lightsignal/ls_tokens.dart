import 'package:flutter/widgets.dart';

/// LightSignal Visual Foundation v2 — "Deep Cyan Glass" design tokens.
///
/// Direct port of §1 (color), §2 (field), §3.2 (radii) and §8 (motion) of
/// `LightSignal Visual Foundation v2`. These are the single source of truth
/// for the shared skin; tab specs own layout and reference these tokens.
///
/// Rule of thumb from §0: add light to the dark, never wash it out. Do not
/// lighten the base field to make something feel less "empty" — raise the
/// luminosity (glows, motes) instead.
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

/// §7 severity levels. Severity is carried by a plain solid dot's color
/// everywhere except KPI metric tiles — see `LsSeverityDot` / `LsSevPulse`.
enum LsSeverity {
  /// critical / pressing — `#FF5757`.
  critical(LsColors.critical),

  /// building / drift — `#FFD466`.
  building(LsColors.building),

  /// stable / affirmative — `#FFFFFF`.
  stable(LsColors.stable),

  /// resolved — `#26C281`.
  resolved(LsColors.resolved),

  /// accent / informational — `#5FE0FF`.
  accent(LsColors.accent);

  const LsSeverity(this.color);

  final Color color;
}

/// §3 glass `strength` (S) — the transparency <-> legibility dial. Scales
/// every white-fill alpha in the glass recipe.
class LsGlassStrength {
  LsGlassStrength._();

  /// Hero / showcase surfaces (most transparent).
  static const double hero = 1.0;

  /// Hero / showcase surfaces, upper bound of the band.
  static const double heroMax = 1.1;

  /// Standard data cards (panels, lists, banners).
  static const double standard = 1.4;

  /// Number / metric tiles — figures must stay solid.
  static const double metric = 1.5;
}

/// §3.2 border-radius mapping, per element type.
class LsRadii {
  LsRadii._();

  /// KPI tile / swipe card / banner.
  static const double card = 20;

  /// Hero / stage / drawer surface (24–28px band).
  static const double hero = 24;

  /// Hero / stage / drawer surface — upper bound of the band.
  static const double heroMax = 28;

  /// Collapsible glass dropdown section (§6.5).
  static const double section = 16;

  /// Chip / pill — fully rounded.
  static const double pill = 999;
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

/// §8 motion durations.
class LsDurations {
  LsDurations._();

  /// Card entrance — `lsEnter 380ms`.
  static const Duration enter = Duration(milliseconds: 380);

  /// Reduced-motion entrance fade.
  static const Duration enterReduced = Duration(milliseconds: 220);

  /// Stagger step between grouped items (30–80ms band).
  static const Duration stagger = Duration(milliseconds: 60);

  /// Count-up numbers — once, then stop. Never loops.
  static const Duration countUp = Duration(milliseconds: 750);

  /// Flowing light streak drift.
  static const Duration streakDrift = Duration(seconds: 26);

  /// Severity / urgent glow breathe.
  static const Duration breathe = Duration(milliseconds: 2600);

  /// Hover lift.
  static const Duration lift = Duration(milliseconds: 200);

  /// Press.
  static const Duration press = Duration(milliseconds: 150);

  /// Glass dropdown expand / glow transition (§6.5).
  static const Duration section = Duration(milliseconds: 280);

  /// Chevron rotation (§6.5).
  static const Duration chevron = Duration(milliseconds: 240);

  /// Scroll-cue fade (§6.6).
  static const Duration scrollCue = Duration(milliseconds: 300);

  /// Skeleton shimmer sweep (§9.1).
  static const Duration shimmer = Duration(milliseconds: 1400);

  /// Scroll-cue chevron bob (§6.6).
  static const Duration chevBob = Duration(milliseconds: 1800);
}