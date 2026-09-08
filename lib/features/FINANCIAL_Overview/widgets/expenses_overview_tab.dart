import 'package:flutter/material.dart';

import '../../../theme/app_theme.dart';
import '../data/expense_breakdown_data.dart';
import 'expense_donut_chart.dart';
import 'expense_legend_list.dart';

class ExpensesOverviewTab extends StatefulWidget {
  const ExpensesOverviewTab({super.key});

  @override
  State<ExpensesOverviewTab> createState() => _ExpensesOverviewTabState();
}

class _ExpensesOverviewTabState extends State<ExpensesOverviewTab> {
  int? _selectedIndex;

  void _select(int index) =>
      setState(() => _selectedIndex = _selectedIndex == index ? null : index);

  @override
  Widget build(BuildContext context) {
    final selected = _selectedIndex == null
        ? null
        : expenseCategories[_selectedIndex!];
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.glassDark,
        borderRadius: BorderRadius.circular(16),
        // border: Border.all(color: AppColors.glassBorder),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Where the money goes',
            style: AppTextStyles.headlineAccent.copyWith(
              fontSize: 17,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            expenseSummary,
            style: AppTextStyles.small.copyWith(height: 1.45),
          ),
          const SizedBox(height: 16),
          Text('TOTAL JANUARY SPEND', style: AppTextStyles.eyebrow),
          const SizedBox(height: 4),
          Text(
            expenseTotalLabel,
            style: AppTextStyles.headline.copyWith(
              fontSize: 44,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 12),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: ExpenseDonutChart(
              categories: expenseCategories,
              selectedIndex: _selectedIndex,
              onSelect: _select,
              centerLabel: selected == null
                  ? Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          expensePeriodLabel,
                          textAlign: TextAlign.center,
                          style: AppTextStyles.small.copyWith(
                            fontWeight: FontWeight.w700,
                            letterSpacing: 0.4,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          'tap a slice to break it down',
                          textAlign: TextAlign.center,
                          style: AppTextStyles.small.copyWith(fontSize: 11),
                        ),
                      ],
                    )
                  : Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          selected.label.toUpperCase(),
                          textAlign: TextAlign.center,
                          style: AppTextStyles.small.copyWith(
                            fontWeight: FontWeight.w700,
                            letterSpacing: 0.4,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          selected.amount,
                          style: const TextStyle(
                            color: AppColors.white,
                            fontSize: 22,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          '${selected.percent}% of January spend',
                          textAlign: TextAlign.center,
                          style: AppTextStyles.small.copyWith(fontSize: 11),
                        ),
                      ],
                    ),
            ),
          ),
          const SizedBox(height: 16),
          ExpenseLegendList(
            categories: expenseCategories,
            selectedIndex: _selectedIndex,
            onSelect: _select,
          ),
        ],
      ),
    );
  }
}
