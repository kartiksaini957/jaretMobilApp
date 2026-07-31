import 'package:flutter/material.dart';

import '../../../theme/app_theme.dart';

/// "This weekend / Rest of month / $ / slices" selector: the first two
/// (the time-period toggle) share one outer pill container with an inner
/// highlight on the selected side; any further tabs (here "$ / slices")
/// render as their own standalone pill.
class ForecastTabPills extends StatelessWidget {
  const ForecastTabPills({
    super.key,
    required this.labels,
    required this.selectedIndex,
    required this.onSelect,
  });

  final List<String> labels;
  final int selectedIndex;
  final ValueChanged<int> onSelect;

  @override
  Widget build(BuildContext context) {
    final groupCount = labels.length >= 2 ? 2 : labels.length;

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(3),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(22),
              border: Border.all(color: AppColors.glassBorder),
            ),
            child: Row(
              children: [
                for (var i = 0; i < groupCount; i++)
                  _SegmentPill(
                    label: labels[i],
                    selected: i == selectedIndex,
                    onTap: () => onSelect(i),
                  ),
              ],
            ),
          ),
          for (var i = groupCount; i < labels.length; i++) ...[
            const SizedBox(width: 8),
            _StandalonePill(
              label: labels[i],
              selected: i == selectedIndex,
              onTap: () => onSelect(i),
            ),
          ],
        ],
      ),
    );
  }
}

class _SegmentPill extends StatelessWidget {
  const _SegmentPill({
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
            color: selected ? AppColors.glassLight : Colors.transparent,
            borderRadius: BorderRadius.circular(20),
            border: selected ? Border.all(color: AppColors.white) : null,
          ),
          child: Text(
            label,
            style: TextStyle(
              color: selected ? AppColors.white : AppColors.faintText,
              fontSize: 12.5,
              fontWeight: selected ? FontWeight.w700 : FontWeight.w500,
            ),
          ),
        ),
      ),
    );
  }
}

class _StandalonePill extends StatelessWidget {
  const _StandalonePill({
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
            color: selected ? AppColors.glassLight : Colors.transparent,
            borderRadius: BorderRadius.circular(20),
            border: Border.all(
              color: selected ? AppColors.white : AppColors.glassBorder,
            ),
          ),
          child: Text(
            label,
            style: TextStyle(
              color: selected ? AppColors.white : AppColors.faintText,
              fontSize: 12.5,
              fontWeight: selected ? FontWeight.w700 : FontWeight.w500,
            ),
          ),
        ),
      ),
    );
  }
}
