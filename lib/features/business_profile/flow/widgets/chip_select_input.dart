import 'package:flutter/material.dart';

import '../../../../theme/app_theme.dart';

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
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
          alignment: fullWidth ? Alignment.center : null,
          decoration: BoxDecoration(
            color: isSelected ? AppColors.white : Colors.transparent,
            borderRadius: BorderRadius.circular(24),
            border: Border.all(
              color: isSelected ? AppColors.white : AppColors.glassBorder,
            ),
          ),
          child: Text(
            option,
            style: TextStyle(
              color: isSelected ? AppColors.ink : AppColors.white,
              fontSize: 13.5,
              fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
            ),
          ),
        ),
      ),
    );
    return fullWidth ? SizedBox(width: double.infinity, child: chip) : chip;
  }
}
