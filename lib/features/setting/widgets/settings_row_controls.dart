import 'package:flutter/material.dart';

import '../../../theme/app_theme.dart';
import '../../../theme/lightsignal/ls_css.dart';
import '../theme/settings_colors.dart';

/// `.frow .fl` — the bold label at the head of a settings row.
TextStyle get _rowLabelStyle => AppTextStyles.body.copyWith(
  color: SettingsColors.white,
  fontSize: 13.5,
  fontWeight: FontWeight.w700,
  height: 1.2,
);

/// `.frow .fs` — the quiet explanatory line under it.
TextStyle get _rowSubtitleStyle => AppTextStyles.body.copyWith(
  color: SettingsColors.soft,
  fontSize: 11.5,
  height: 1.5,
);

/// `.trow` — a plain list row (thresholds, sessions, team, invoices,
/// snapshots, corrections).
TextStyle get _listRowStyle => AppTextStyles.body.copyWith(
  color: SettingsColors.bright,
  fontSize: 13,
  height: 1.4,
);

/// Label + optional subtitle + trailing switch. The workhorse row for
/// every boolean setting across the Settings tabs.
class SettingsToggleRow extends StatelessWidget {
  const SettingsToggleRow({
    super.key,
    required this.label,
    this.subtitle,
    required this.value,
    required this.onChanged,
  });

  final String label;
  final String? subtitle;
  final bool value;
  final ValueChanged<bool> onChanged;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          Expanded(child: _RowLabel(label: label, subtitle: subtitle)),
          const SizedBox(width: 12),
          Switch(
            value: value,
            onChanged: onChanged,
            activeThumbColor: SettingsColors.white,
            activeTrackColor: SettingsColors.accent.withValues(alpha: 0.45),
            inactiveThumbColor: SettingsColors.white.withValues(alpha: 0.75),
            inactiveTrackColor: SettingsColors.cardFill,
          ),
        ],
      ),
    );
  }
}

/// Label + subtitle above a right-aligned dropdown pill.
class SettingsDropdownRow<T> extends StatelessWidget {
  const SettingsDropdownRow({
    super.key,
    required this.label,
    this.subtitle,
    required this.value,
    required this.options,
    required this.onChanged,
    this.labelBuilder,
  });

  final String label;
  final String? subtitle;
  final T value;
  final List<T> options;
  final ValueChanged<T> onChanged;
  final String Function(T)? labelBuilder;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          Expanded(child: _RowLabel(label: label, subtitle: subtitle)),
          const SizedBox(width: 12),
          Flexible(
            child: SettingsDropdown<T>(
              value: value,
              options: options,
              onChanged: onChanged,
              labelBuilder: labelBuilder,
            ),
          ),
        ],
      ),
    );
  }
}

/// The `select` control — radius 10, translucent fill, 13px label.
class SettingsDropdown<T> extends StatelessWidget {
  const SettingsDropdown({
    super.key,
    required this.value,
    required this.options,
    required this.onChanged,
    this.labelBuilder,
    this.compact = false,
  });

  final T value;
  final List<T> options;
  final ValueChanged<T> onChanged;
  final String Function(T)? labelBuilder;

  /// The 34px variant used inside connector cards.
  final bool compact;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: compact ? 34 : 38,
      padding: const EdgeInsets.symmetric(horizontal: 12),
      decoration: BoxDecoration(
        color: SettingsColors.white.withValues(alpha: 0.07),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: SettingsColors.white.withValues(alpha: 0.22)),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<T>(
          value: value,
          isDense: true,
          isExpanded: true,
          dropdownColor: const Color(0xFF0A4A63),
          borderRadius: BorderRadius.circular(12),
          icon: const Icon(
            Icons.keyboard_arrow_down,
            color: SettingsColors.white,
            size: 20,
          ),
          style: AppTextStyles.body.copyWith(
            color: SettingsColors.white,
            fontSize: 13,
            fontWeight: FontWeight.w600,
          ),
          items: [
            for (final option in options)
              DropdownMenuItem<T>(
                value: option,
                child: Text(
                  labelBuilder?.call(option) ?? option.toString(),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
          ],
          onChanged: (v) {
            if (v != null) onChanged(v);
          },
        ),
      ),
    );
  }
}

/// Label + subtitle with one or more trailing action buttons (e.g.
/// "Change password", "Contact support", "Restore"/"Delete").
class SettingsActionRow extends StatelessWidget {
  const SettingsActionRow({
    super.key,
    required this.label,
    this.subtitle,
    required this.actions,
  });

  final String label;
  final String? subtitle;
  final List<Widget> actions;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Wrap(
        crossAxisAlignment: WrapCrossAlignment.center,
        alignment: WrapAlignment.spaceBetween,
        spacing: 12,
        runSpacing: 10,
        children: [
          ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 260),
            child: _RowLabel(label: label, subtitle: subtitle),
          ),
          Wrap(spacing: 8, runSpacing: 8, children: actions),
        ],
      ),
    );
  }
}

/// `.trow` — text on the left, actions pushed to the right.
class SettingsListRow extends StatelessWidget {
  const SettingsListRow({
    super.key,
    this.text,
    this.richText,
    this.trailing = const [],
  }) : assert(text != null || richText != null, 'give the row some content');

  final String? text;

  /// For rows whose leading fragment is bold ("**Supply chain** — ...").
  final InlineSpan? richText;
  final List<Widget> trailing;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Expanded(
            child: richText != null
                ? Text.rich(richText!, style: _listRowStyle)
                : Text(text!, style: _listRowStyle),
          ),
          if (trailing.isNotEmpty) ...[
            const SizedBox(width: 10),
            Wrap(spacing: 8, runSpacing: 8, children: trailing),
          ],
        ],
      ),
    );
  }
}

/// The quiet trailing note on a `.trow` ("current", "full access").
class SettingsRowNote extends StatelessWidget {
  const SettingsRowNote(this.text, {super.key});

  final String text;

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: AppTextStyles.body.copyWith(
        color: SettingsColors.soft,
        fontSize: 11.5,
      ),
    );
  }
}

class _RowLabel extends StatelessWidget {
  const _RowLabel({required this.label, this.subtitle});

  final String label;
  final String? subtitle;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(label, style: _rowLabelStyle),
        if (subtitle != null) ...[
          const SizedBox(height: 2),
          Text(subtitle!, style: _rowSubtitleStyle),
        ],
      ],
    );
  }
}

/// Which `.gbtn` variant a pill uses.
enum SettingsButtonTone {
  /// `.gbtn` — the quiet default.
  neutral,

  /// `.gbtn.primary` — accent-tinted, for the one affirmative action.
  primary,

  /// `.gbtn.danger` — destructive.
  danger,
}

/// The `.gbtn` glass pill used for every row-level action ("Connect",
/// "View", "Undo", "Sign out", "Start deletion", ...).
class SettingsPillButton extends StatelessWidget {
  const SettingsPillButton({
    super.key,
    required this.label,
    required this.onPressed,
    this.tone = SettingsButtonTone.neutral,
    this.compact = false,
  });

  final String label;
  final VoidCallback? onPressed;
  final SettingsButtonTone tone;

  /// The 32px variant used inside `.trow`s.
  final bool compact;

  /// `.gbtn` — `rgba(8,40,56,.32→.26)` over `rgba(255,255,255,.13→.05)`,
  /// pre-composited so one gradient does the work of the reference's two.
  static final Gradient _neutralFill = LsCss.linearGradient(
    degrees: 160,
    colors: const [Color(0x683E5763), Color(0x4D274351)],
  );

  /// `.gbtn.primary` — the same dark layer over the accent sheen.
  static final Gradient _primaryFill = LsCss.linearGradient(
    degrees: 160,
    colors: const [Color(0x8A2E7990), Color(0x541B5164)],
  );

  @override
  Widget build(BuildContext context) {
    final isDanger = tone == SettingsButtonTone.danger;
    final foreground = switch (tone) {
      SettingsButtonTone.neutral => SettingsColors.soft,
      SettingsButtonTone.primary => SettingsColors.white,
      SettingsButtonTone.danger => SettingsColors.danger,
    };
    final border = switch (tone) {
      // rgba(255,255,255,.24) / .32 / rgba(255,150,130,.4)
      SettingsButtonTone.neutral => const Color(0x3DFFFFFF),
      SettingsButtonTone.primary => const Color(0x52FFFFFF),
      SettingsButtonTone.danger => const Color(0x66FF9682),
    };

    return Material(
      color: Colors.transparent,
      borderRadius: BorderRadius.circular(99),
      child: InkWell(
        onTap: onPressed,
        borderRadius: BorderRadius.circular(99),
        splashColor: SettingsColors.white.withValues(alpha: 0.10),
        highlightColor: SettingsColors.white.withValues(alpha: 0.06),
        child: Ink(
          decoration: BoxDecoration(
            gradient: isDanger
                ? null
                : tone == SettingsButtonTone.primary
                ? _primaryFill
                : _neutralFill,
            color: isDanger ? const Color(0x33FF9682) : null,
            borderRadius: BorderRadius.circular(99),
            border: Border.all(color: border),
            boxShadow: const [
              BoxShadow(
                color: Color(0x80001422),
                offset: Offset(0, 6),
                blurRadius: 16,
                spreadRadius: -9,
              ),
            ],
          ),
          // `Center(widthFactor: 1)` rather than `Container(alignment:)` —
          // an aligned Container fills whatever width it is offered, so in a
          // Wrap every button would claim its own line.
          child: SizedBox(
            height: compact ? 32 : 40,
            child: Center(
              widthFactor: 1,
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: compact ? 14 : 20),
                child: Text(
                  label,
                  style: AppTextStyles.body.copyWith(
                    color: foreground,
                    fontSize: compact ? 12 : 13,
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

/// Compact text-entry field matching the reference's `input[type=text]`.
class SettingsTextField extends StatelessWidget {
  const SettingsTextField({
    super.key,
    required this.controller,
    this.hintText,
    this.width,
    this.onChanged,
    this.onSubmitted,
  });

  final TextEditingController controller;
  final String? hintText;
  final double? width;
  final ValueChanged<String>? onChanged;
  final ValueChanged<String>? onSubmitted;

  @override
  Widget build(BuildContext context) {
    final border = OutlineInputBorder(
      borderRadius: BorderRadius.circular(10),
      borderSide: BorderSide(
        color: SettingsColors.white.withValues(alpha: 0.22),
      ),
    );

    return SizedBox(
      width: width,
      height: 38,
      child: TextField(
        controller: controller,
        onChanged: onChanged,
        onSubmitted: onSubmitted,
        style: AppTextStyles.body.copyWith(
          color: SettingsColors.white,
          fontSize: 13,
        ),
        decoration: InputDecoration(
          hintText: hintText,
          hintStyle: AppTextStyles.body.copyWith(
            color: SettingsColors.soft.withValues(alpha: 0.6),
            fontSize: 13,
          ),
          isDense: true,
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 12,
            vertical: 10,
          ),
          filled: true,
          fillColor: SettingsColors.white.withValues(alpha: 0.07),
          border: border,
          enabledBorder: border,
          focusedBorder: border.copyWith(
            borderSide: const BorderSide(color: SettingsColors.accent),
          ),
        ),
      ),
    );
  }
}

/// Small colored status dot (connected/not-connected, cloud-sync ok, ...).
class SettingsStatusDot extends StatelessWidget {
  const SettingsStatusDot({super.key, required this.color, this.size = 7});

  final Color color;
  final double size;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(color: color, shape: BoxShape.circle),
    );
  }
}
