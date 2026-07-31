import 'package:flutter/material.dart';

import '../../../theme/app_theme.dart';

/// Top pill row: Home / Pressing now / Ratios / Expenses. "Pressing now"
/// and "Ratios" always carry a red dot, matching the mock.
class FinancialCategoryTabs extends StatelessWidget {
  const FinancialCategoryTabs({
    super.key,
    required this.labels,
    required this.selectedIndex,
    required this.onSelect,
  });

  final List<String> labels;
  final int selectedIndex;
  final ValueChanged<int> onSelect;

  static const _dotted = {'Pressing now', 'Ratios'};

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: [
          for (var i = 0; i < labels.length; i++) ...[
            if (i != 0) const SizedBox(width: 8),
            _Pill(
              label: labels[i],
              showDot: _dotted.contains(labels[i]),
              selected: i == selectedIndex,
              onTap: () => onSelect(i),
            ),
          ],
        ],
      ),
    );
  }
}

class _Pill extends StatelessWidget {
  const _Pill({
    required this.label,
    required this.showDot,
    required this.selected,
    required this.onTap,
  });

  final String label;
  final bool showDot;
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
            color: selected ? AppColors.glassLight : Colors.transparent,
            borderRadius: BorderRadius.circular(20),
            border: Border.all(
              color: selected ? AppColors.white : AppColors.glassBorder,
            ),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (showDot) ...[
                const Icon(Icons.circle, size: 7, color: AppColors.critDot),
                const SizedBox(width: 6),
              ],
              Text(
                label,
                style: TextStyle(
                  color: selected ? AppColors.white : AppColors.faintText,
                  fontSize: 12.5,
                  fontWeight: selected ? FontWeight.w700 : FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
