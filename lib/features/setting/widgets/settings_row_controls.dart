import 'package:flutter/material.dart';

import '../../../theme/app_theme.dart';
import '../../../theme/lightsignal/ls_css.dart';
import '../../../widgets/smooth_animations.dart';
import '../theme/settings_colors.dart';

TextStyle get _rowLabelStyle => AppTextStyles.body.copyWith(
  color: SettingsColors.white,
  fontSize: 13.5,
  fontWeight: FontWeight.w700,
  height: 1.2,
);

TextStyle get _rowSubtitleStyle => AppTextStyles.body.copyWith(
  color: SettingsColors.soft,
  fontSize: 11.5,
  height: 1.5,
);

TextStyle get _listRowStyle => AppTextStyles.body.copyWith(
  color: SettingsColors.bright,
  fontSize: 13,
  height: 1.4,
);

class SettingsToggleRow extends StatelessWidget {
  const SettingsToggleRow({
    super.key,
    required this.label,
    this.subtitle,
    required this.value,
    required this.onChanged,
    this.isLoading = false,
  });

  final String label;
  final String? subtitle;
  final bool value;
  final ValueChanged<bool> onChanged;
  final bool isLoading;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          Expanded(child: _RowLabel(label: label, subtitle: subtitle)),
          const SizedBox(width: 12),
          if (isLoading)
            const SizedBox(
              width: 32,
              height: 32,
              child: Center(
                child: SizedBox(
                  width: 16,
                  height: 16,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    color: SettingsColors.accent,
                  ),
                ),
              ),
            )
          else
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

class SettingsDropdownRow<T> extends StatelessWidget {
  const SettingsDropdownRow({
    super.key,
    required this.label,
    this.subtitle,
    required this.value,
    required this.options,
    required this.onChanged,
    this.labelBuilder,
    this.isLoading = false,
  });

  final String label;
  final String? subtitle;
  final T value;
  final List<T> options;
  final ValueChanged<T> onChanged;
  final String Function(T)? labelBuilder;
  final bool isLoading;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          Expanded(child: _RowLabel(label: label, subtitle: subtitle)),
          const SizedBox(width: 12),
          if (isLoading)
            Container(
              height: 38,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              decoration: BoxDecoration(
                color: SettingsColors.white.withValues(alpha: 0.05),
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: SettingsColors.white.withValues(alpha: 0.15)),
              ),
              child: const Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  SizedBox(
                    width: 14,
                    height: 14,
                    child: CircularProgressIndicator(
                      strokeWidth: 1.8,
                      color: SettingsColors.accent,
                    ),
                  ),
                  SizedBox(width: 8),
                  Text(
                    'Loading…',
                    style: TextStyle(
                      color: SettingsColors.soft,
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
            )
          else
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
  final bool compact;

  @override
  Widget build(BuildContext context) {
    // Collect unique options
    final List<T> uniqueOptions = [];
    for (final opt in options) {
      if (!uniqueOptions.contains(opt)) {
        uniqueOptions.add(opt);
      }
    }

    // Resolve matching value safely (handle case-insensitivity or add if missing)
    T effectiveValue = value;
    if (!uniqueOptions.contains(value)) {
      if (value is String) {
        final valStr = (value as String).trim().toLowerCase();
        final match = uniqueOptions.cast<dynamic>().firstWhere(
              (opt) => opt.toString().trim().toLowerCase() == valStr,
              orElse: () => null,
            );
        if (match != null) {
          effectiveValue = match as T;
        } else {
          uniqueOptions.add(value);
        }
      } else {
        uniqueOptions.add(value);
      }
    }

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
          value: effectiveValue,
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
            for (final option in uniqueOptions)
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

class SettingsListRow extends StatelessWidget {
  const SettingsListRow({
    super.key,
    this.text,
    this.richText,
    this.trailing = const [],
  }) : assert(text != null || richText != null, 'give the row some content');

  final String? text;
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

enum SettingsButtonTone {
  neutral,
  primary,
  danger,
}

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
  final bool compact;
  static final Gradient _neutralFill = LsCss.linearGradient(
    degrees: 160,
    colors: const [Color(0x683E5763), Color(0x4D274351)],
  );

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
      SettingsButtonTone.neutral => const Color(0x3DFFFFFF),
      SettingsButtonTone.primary => const Color(0x52FFFFFF),
      SettingsButtonTone.danger => const Color(0x66FF9682),
    };

    return SmoothScaleTap(
      onTap: onPressed,
      scaleFactor: 0.94,
      child: Container(
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
    );
  }
}

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
