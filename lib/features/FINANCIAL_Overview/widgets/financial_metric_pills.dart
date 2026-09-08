import 'package:flutter/material.dart';
import '../../../theme/app_theme.dart';
import '../data/financial_overview_data.dart';
class FinancialMetricPills extends StatelessWidget {
  const FinancialMetricPills({
    super.key,
    required this.metrics,
    required this.selectedIndex,
    required this.onSelect,
  });

  final List<MetricDetail> metrics;
  final int selectedIndex;
  final ValueChanged<int> onSelect;

  static Color _dotColor(MetricTone tone) => switch (tone) {
    MetricTone.good => AppColors.goodDot,
    MetricTone.neutral => AppColors.warnDot,
    MetricTone.bad => AppColors.critDot,
  };

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: [
          for (var i = 0; i < metrics.length; i++) ...[
            if (i != 0) const SizedBox(width: 8),
            _Pill(
              label: metrics[i].label,
              dotColor: _dotColor(metrics[i].tone),
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
    required this.dotColor,
    required this.selected,
    required this.onTap,
  });

  final String label;
  final Color dotColor;
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
              color: selected ? const Color(0x805FE0FF) : AppColors.glassBorder,
            ),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.circle, size: 7, color: dotColor),
              const SizedBox(width: 6),
              Text(
                label,
                style: AppTextStyles.small.copyWith(
                  color: selected ? AppColors.white : AppColors.faintText,
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
