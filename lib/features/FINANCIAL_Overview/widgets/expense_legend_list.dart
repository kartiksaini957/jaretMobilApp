import 'package:flutter/material.dart';
import '../../../theme/app_theme.dart';
import '../data/expense_breakdown_data.dart';

class ExpenseLegendList extends StatelessWidget {
  const ExpenseLegendList({
    super.key,
    required this.categories,
    required this.selectedIndex,
    required this.onSelect,
  });

  final List<ExpenseCategory> categories;
  final int? selectedIndex;
  final ValueChanged<int> onSelect;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        for (var i = 0; i < categories.length; i++)
          _LegendRow(
            category: categories[i],
            selected: i == selectedIndex,
            onTap: () => onSelect(i),
          ),
      ],
    );
  }
}

class _LegendRow extends StatelessWidget {
  const _LegendRow({
    required this.category,
    required this.selected,
    required this.onTap,
  });

  final ExpenseCategory category;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: selected ? AppColors.glassLight : Colors.transparent,
      borderRadius: BorderRadius.circular(12),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 12),
          child: Row(
            children: [
              Container(
                width: 10,
                height: 10,
                decoration: BoxDecoration(
                  color: category.color,
                  borderRadius: BorderRadius.circular(3),
                  shape: BoxShape.rectangle,
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Text(
                  category.label,
                  style: AppTextStyles.buttonLabel.copyWith(fontSize: 13),
                ),
              ),
              SizedBox(
                width: 40,
                child: Text(
                  '${category.percent}%',
                  textAlign: TextAlign.right,
                  style: AppTextStyles.buttonLabel.copyWith(fontSize: 13),
                ),
              ),
              const SizedBox(width: 12),
              Text(category.amount, style: AppTextStyles.small),
            ],
          ),
        ),
      ),
    );
  }
}
