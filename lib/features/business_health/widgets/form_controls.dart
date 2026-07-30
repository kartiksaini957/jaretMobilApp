import 'package:flutter/material.dart';

import '../theme/business_health_colors.dart';

/// Bold question text with an optional muted subtext/parenthetical line.
class QuestionLabel extends StatelessWidget {
  const QuestionLabel({super.key, required this.text, this.note});

  final String text;
  final String? note;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          text,
          style: const TextStyle(
            color: BusinessHealthColors.white,
            fontSize: 13.5,
            fontWeight: FontWeight.w600,
            height: 1.35,
          ),
        ),
        if (note != null) ...[
          const SizedBox(height: 2),
          Text(
            note!,
            style: const TextStyle(
              color: BusinessHealthColors.faintText,
              fontSize: 11.5,
              height: 1.3,
            ),
          ),
        ],
      ],
    );
  }
}

/// Self-contained tappable checkbox row (square box + label).
class CheckboxRow extends StatefulWidget {
  const CheckboxRow({super.key, required this.label});

  final String label;

  @override
  State<CheckboxRow> createState() => _CheckboxRowState();
}

class _CheckboxRowState extends State<CheckboxRow> {
  bool _checked = false;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => setState(() => _checked = !_checked),
      borderRadius: BorderRadius.circular(6),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 6),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: 18,
              height: 18,
              margin: const EdgeInsets.only(top: 1),
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: _checked
                    ? BusinessHealthColors.white
                    : Colors.transparent,
                borderRadius: BorderRadius.circular(4),
                border: Border.all(color: BusinessHealthColors.cardBorder),
              ),
              child: _checked
                  ? const Icon(
                      Icons.check,
                      size: 13,
                      color: BusinessHealthColors.bgBottom,
                    )
                  : null,
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Text(
                widget.label,
                style: const TextStyle(
                  color: BusinessHealthColors.white,
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Self-contained single-select radio group, optionally laid out in a
/// 2-column grid.
class RadioOptionGroup extends StatefulWidget {
  const RadioOptionGroup({super.key, required this.options, this.columns = 1});

  final List<String> options;
  final int columns;

  @override
  State<RadioOptionGroup> createState() => _RadioGroupState();
}

class _RadioGroupState extends State<RadioOptionGroup> {
  String? _selected;

  @override
  Widget build(BuildContext context) {
    if (widget.columns == 1) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          for (final option in widget.options)
            _RadioOption(
              label: option,
              selected: _selected == option,
              onTap: () => setState(() => _selected = option),
            ),
        ],
      );
    }
    return LayoutBuilder(
      builder: (context, constraints) {
        const spacing = 12.0;
        final itemWidth =
            (constraints.maxWidth - spacing * (widget.columns - 1)) /
            widget.columns;
        return Wrap(
          spacing: spacing,
          children: [
            for (final option in widget.options)
              SizedBox(
                width: itemWidth,
                child: _RadioOption(
                  label: option,
                  selected: _selected == option,
                  onTap: () => setState(() => _selected = option),
                ),
              ),
          ],
        );
      },
    );
  }
}

class _RadioOption extends StatelessWidget {
  const _RadioOption({
    required this.label,
    required this.selected,
    required this.onTap,
  });

  final String label;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(6),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 6),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: 18,
              height: 18,
              margin: const EdgeInsets.only(top: 1),
              alignment: Alignment.center,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(color: BusinessHealthColors.cardBorder),
              ),
              child: selected
                  ? Container(
                      width: 9,
                      height: 9,
                      decoration: const BoxDecoration(
                        color: BusinessHealthColors.white,
                        shape: BoxShape.circle,
                      ),
                    )
                  : null,
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Text(
                label,
                style: const TextStyle(
                  color: BusinessHealthColors.white,
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
