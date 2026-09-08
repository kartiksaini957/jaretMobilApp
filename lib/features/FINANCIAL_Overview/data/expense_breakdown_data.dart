import 'package:flutter/material.dart';
import 'package:flutter_application_1/features/FINANCIAL_Overview/model/financialOverviewModel.dart';

import '../../../theme/app_theme.dart';
class ExpenseCategory {
  const ExpenseCategory({
    required this.label,
    required this.percent,
    required this.amount,
    required this.color,
  });

  final String label;
  final int percent;
  final String amount;
  final Color color;
}

// import '../model/financialOverviewModel.dart';

String expenseTotalLabel = '\$0';
String expensePeriodLabel = 'MONTHLY OPEX';
String expenseSummary = '';
List<ExpenseCategory> expenseCategories = [];

const _expenseColors = [
  AppColors.accent,
  AppColors.blobBlueA,
  AppColors.soft,
  AppColors.goodDot,
  AppColors.blobBlueB,
  AppColors.faintText,
];

String _formatMoney(double value) {
  final abs = value.abs().toStringAsFixed(0);
  final withCommas = abs.replaceAllMapped(
    RegExp(r'\B(?=(\d{3})+(?!\d))'),
    (m) => ',',
  );
  return '${value < 0 ? '-' : ''}\$$withCommas';
}

void applyFinancialOverviewToExpenses(FinancialOverviewResponse data) {
  final breakdown = data.expenseBreakdown;
  expenseTotalLabel = _formatMoney(breakdown.totalAmount);
  expenseSummary =
      "This month's operating spend — ${_formatMoney(breakdown.totalAmount)} "
      'of costs against ${_formatMoney(data.kpis.revenueMtd)} of revenue';

  expenseCategories = List.generate(breakdown.categories.length, (i) {
    final c = breakdown.categories[i];
    return ExpenseCategory(
      label: c.category,
      percent: c.percentage.round(),
      amount: _formatMoney(c.amount),
      color: _expenseColors[i % _expenseColors.length],
    );
  });
}