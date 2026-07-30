import 'package:flutter/material.dart';

import '../theme/business_profile_colors.dart';

/// Bold white label shown above every field.
class WizardFieldLabel extends StatelessWidget {
  const WizardFieldLabel(this.text, {super.key});

  final String text;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 6),
      child: Text(
        text,
        style: const TextStyle(
          color: BusinessProfileColors.white,
          fontSize: 13.5,
          fontWeight: FontWeight.w700,
          height: 1.3,
        ),
      ),
    );
  }
}

InputDecoration _fieldDecoration(String? hint) {
  return InputDecoration(
    hintText: hint,
    hintStyle: const TextStyle(color: BusinessProfileColors.faintText),
    filled: true,
    fillColor: BusinessProfileColors.fieldFill,
    contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
    border: OutlineInputBorder(
      borderRadius: BorderRadius.circular(10),
      borderSide: const BorderSide(color: BusinessProfileColors.fieldBorder),
    ),
    enabledBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(10),
      borderSide: const BorderSide(color: BusinessProfileColors.fieldBorder),
    ),
    focusedBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(10),
      borderSide: const BorderSide(
        color: BusinessProfileColors.white,
        width: 1.4,
      ),
    ),
  );
}

/// Single-line labeled text field matching the wizard's glass field style.
class WizardTextField extends StatelessWidget {
  const WizardTextField({
    super.key,
    required this.label,
    this.hint,
    this.keyboardType,
  });

  final String label;
  final String? hint;
  final TextInputType? keyboardType;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        WizardFieldLabel(label),
        TextField(
          keyboardType: keyboardType,
          style: const TextStyle(
            color: BusinessProfileColors.white,
            fontSize: 14,
          ),
          decoration: _fieldDecoration(hint),
        ),
      ],
    );
  }
}

/// Multiline labeled text field.
class WizardTextArea extends StatelessWidget {
  const WizardTextArea({
    super.key,
    required this.label,
    this.hint,
    this.minLines = 3,
  });

  final String label;
  final String? hint;
  final int minLines;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        WizardFieldLabel(label),
        TextField(
          minLines: minLines,
          maxLines: minLines + 3,
          style: const TextStyle(
            color: BusinessProfileColors.white,
            fontSize: 14,
          ),
          decoration: _fieldDecoration(hint),
        ),
      ],
    );
  }
}

/// Labeled dropdown matching the wizard's field style.
class WizardDropdown extends StatefulWidget {
  const WizardDropdown({
    super.key,
    required this.label,
    required this.options,
    this.placeholder = 'Select',
  });

  final String label;
  final List<String> options;
  final String placeholder;

  @override
  State<WizardDropdown> createState() => _WizardDropdownState();
}

class _WizardDropdownState extends State<WizardDropdown> {
  String? _value;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        WizardFieldLabel(widget.label),
        DropdownButtonFormField<String>(
          initialValue: _value,
          isExpanded: true,
          dropdownColor: const Color(0xFF1FBDB0),
          icon: const Icon(
            Icons.keyboard_arrow_down,
            color: BusinessProfileColors.white,
          ),
          style: const TextStyle(
            color: BusinessProfileColors.white,
            fontSize: 14,
          ),
          decoration: _fieldDecoration(null),
          hint: Text(
            widget.placeholder,
            style: const TextStyle(color: BusinessProfileColors.faintText),
          ),
          items: [
            for (final option in widget.options)
              DropdownMenuItem(value: option, child: Text(option)),
          ],
          onChanged: (value) => setState(() => _value = value),
        ),
      ],
    );
  }
}

/// Row of toggleable pill choices — single-select or multi-select.
class PillChoiceGroup extends StatefulWidget {
  const PillChoiceGroup({
    super.key,
    required this.label,
    required this.options,
    this.multiSelect = false,
  });

  final String label;
  final List<String> options;
  final bool multiSelect;

  @override
  State<PillChoiceGroup> createState() => _PillChoiceGroupState();
}

class _PillChoiceGroupState extends State<PillChoiceGroup> {
  final Set<String> _selected = {};

  void _toggle(String option) {
    setState(() {
      if (widget.multiSelect) {
        if (_selected.contains(option)) {
          _selected.remove(option);
        } else {
          _selected.add(option);
        }
      } else {
        _selected
          ..clear()
          ..add(option);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        WizardFieldLabel(widget.label),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: [
            for (final option in widget.options)
              _Pill(
                label: option,
                selected: _selected.contains(option),
                onTap: () => _toggle(option),
              ),
          ],
        ),
      ],
    );
  }
}

class _Pill extends StatelessWidget {
  const _Pill({
    required this.label,
    required this.selected,
    required this.onTap,
  });

  final String label;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      borderRadius: BorderRadius.circular(20),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(20),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 9),
          decoration: BoxDecoration(
            color: selected
                ? BusinessProfileColors.white
                : BusinessProfileColors.fieldFill,
            borderRadius: BorderRadius.circular(20),
            border: Border.all(
              color: selected
                  ? BusinessProfileColors.white
                  : BusinessProfileColors.fieldBorder,
            ),
          ),
          child: Text(
            label,
            style: TextStyle(
              color: selected
                  ? const Color(0xFF0C8F86)
                  : BusinessProfileColors.white,
              fontSize: 12.5,
              fontWeight: FontWeight.w700,
            ),
          ),
        ),
      ),
    );
  }
}
