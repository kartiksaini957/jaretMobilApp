import 'package:flutter/material.dart';

import '../theme/settings_colors.dart';

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
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Expanded(child: _RowLabel(label: label, subtitle: subtitle)),
          const SizedBox(width: 12),
          Switch(
            value: value,
            onChanged: onChanged,
            activeThumbColor: SettingsColors.white,
            activeTrackColor: SettingsColors.accent.withValues(alpha: 0.55),
            inactiveThumbColor: SettingsColors.white.withValues(alpha: 0.7),
            inactiveTrackColor: SettingsColors.cardBorder,
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
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Expanded(child: _RowLabel(label: label, subtitle: subtitle)),
          const SizedBox(width: 12),
          _SettingsDropdown<T>(
            value: value,
            options: options,
            onChanged: onChanged,
            labelBuilder: labelBuilder,
          ),
        ],
      ),
    );
  }
}

class _SettingsDropdown<T> extends StatelessWidget {
  const _SettingsDropdown({
    required this.value,
    required this.options,
    required this.onChanged,
    this.labelBuilder,
  });

  final T value;
  final List<T> options;
  final ValueChanged<T> onChanged;
  final String Function(T)? labelBuilder;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12),
      decoration: BoxDecoration(
        color: SettingsColors.cardFillStrong,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: SettingsColors.cardBorder),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<T>(
          value: value,
          isDense: true,
          dropdownColor: const Color(0xFF0A4A63),
          borderRadius: BorderRadius.circular(12),
          icon: const Icon(
            Icons.keyboard_arrow_down,
            color: SettingsColors.white,
            size: 20,
          ),
          style: const TextStyle(
            color: SettingsColors.white,
            fontSize: 13,
            fontWeight: FontWeight.w600,
          ),
          items: [
            for (final option in options)
              DropdownMenuItem<T>(
                value: option,
                child: Text(labelBuilder?.call(option) ?? option.toString()),
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
        runSpacing: 10,
        children: [
          SizedBox(
            width: 220,
            child: _RowLabel(label: label, subtitle: subtitle),
          ),
          Wrap(spacing: 8, runSpacing: 8, children: actions),
        ],
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
        Text(
          label,
          style: const TextStyle(
            color: SettingsColors.white,
            fontSize: 14,
            fontWeight: FontWeight.w700,
          ),
        ),
        if (subtitle != null) ...[
          const SizedBox(height: 3),
          Text(
            subtitle!,
            style: const TextStyle(
              color: SettingsColors.faintText,
              fontSize: 12,
              height: 1.35,
            ),
          ),
        ],
      ],
    );
  }
}

/// Small glass-pill button used for row-level actions ("Connect", "View",
/// "Undo", "Sign out", ...). Supports a danger variant for destructive
/// actions like "Start deletion".
class SettingsPillButton extends StatelessWidget {
  const SettingsPillButton({
    super.key,
    required this.label,
    required this.onPressed,
    this.danger = false,
  });

  final String label;
  final VoidCallback? onPressed;
  final bool danger;

  @override
  Widget build(BuildContext context) {
    final color = danger ? SettingsColors.danger : SettingsColors.white;
    return OutlinedButton(
      onPressed: onPressed,
      style: OutlinedButton.styleFrom(
        foregroundColor: color,
        backgroundColor: danger
            ? SettingsColors.danger.withValues(alpha: 0.12)
            : SettingsColors.cardFillStrong,
        side: BorderSide(
          color: danger ? SettingsColors.danger.withValues(alpha: 0.6) : SettingsColors.cardBorder,
        ),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        minimumSize: Size.zero,
        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
      ),
      child: Text(
        label,
        style: TextStyle(fontSize: 12.5, fontWeight: FontWeight.w700, color: color),
      ),
    );
  }
}

/// Compact text-entry field styled to match the pill inputs in the mock
/// ("email@...", threshold labels).
class SettingsTextField extends StatelessWidget {
  const SettingsTextField({
    super.key,
    required this.controller,
    this.hintText,
    this.width,
    this.onChanged,
  });

  final TextEditingController controller;
  final String? hintText;
  final double? width;
  final ValueChanged<String>? onChanged;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width,
      child: TextField(
        controller: controller,
        onChanged: onChanged,
        style: const TextStyle(color: SettingsColors.white, fontSize: 13),
        decoration: InputDecoration(
          hintText: hintText,
          hintStyle: const TextStyle(color: SettingsColors.faintText, fontSize: 13),
          isDense: true,
          contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
          filled: true,
          fillColor: SettingsColors.cardFillStrong,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(color: SettingsColors.cardBorder),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(color: SettingsColors.cardBorder),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(color: SettingsColors.accent),
          ),
        ),
      ),
    );
  }
}

/// Small colored status dot (connected/not-connected, cloud-sync ok, ...).
class SettingsStatusDot extends StatelessWidget {
  const SettingsStatusDot({super.key, required this.color});

  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 7,
      height: 7,
      decoration: BoxDecoration(color: color, shape: BoxShape.circle),
    );
  }
}
