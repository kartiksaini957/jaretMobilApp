import 'package:flutter/material.dart';

/// Wrap of pill chips; selected chips fill white with dark text, matching
/// the mock. [fullWidthOptions] render on their own row full-width (e.g.
/// "Fairly consistent year-round").
class ChipSelectInput extends StatelessWidget {
  const ChipSelectInput({
    super.key,
    required this.options,
    required this.selected,
    required this.onToggle,
    this.fullWidthOptions = const [],
  });

  final List<String> options;
  final Set<String> selected;
  final ValueChanged<String> onToggle;
  final List<String> fullWidthOptions;

  @override
  Widget build(BuildContext context) {
    final wide = options.where(fullWidthOptions.contains).toList();
    final narrow = options.where((o) => !fullWidthOptions.contains(o)).toList();

    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: [
        for (final option in narrow) _buildChip(option),
        for (final option in wide) _buildChip(option, fullWidth: true),
      ],
    );
  }

  Widget _buildChip(String option, {bool fullWidth = false}) {
    final isSelected = selected.contains(option);
    final chip = Material(
      color: Colors.transparent,
      borderRadius: BorderRadius.circular(24),
      child: InkWell(
        onTap: () => onToggle(option),
        borderRadius: BorderRadius.circular(24),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 10),
          alignment: fullWidth ? Alignment.center : null,
          decoration: BoxDecoration(
            color: isSelected
                ? const Color.fromRGBO(14, 130, 170, 0.75)
                : const Color.fromRGBO(10, 48, 70, 0.4),
            borderRadius: BorderRadius.circular(24),
            border: Border.all(
              color: isSelected
                  ? const Color.fromRGBO(127, 227, 255, 0.85)
                  : const Color.fromRGBO(127, 227, 255, 0.35),
              width: 1.2,
            ),
            boxShadow: isSelected
                ? const [
                    BoxShadow(
                      color: Color.fromRGBO(0, 50, 80, 0.4),
                      blurRadius: 10,
                      offset: Offset(0, 3),
                    ),
                  ]
                : null,
          ),
          child: Text(
            option,
            style: TextStyle(
              color: Colors.white,
              fontSize: 13.5,
              fontWeight: isSelected ? FontWeight.w700 : FontWeight.w600,
            ),
          ),
        ),
      ),
    );
    return fullWidth ? SizedBox(width: double.infinity, child: chip) : chip;
  }
}
