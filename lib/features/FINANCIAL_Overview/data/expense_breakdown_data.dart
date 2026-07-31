import 'package:flutter/material.dart';

import '../../../theme/app_theme.dart';

/// One slice of "Where the money goes".
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

const expenseTotalLabel = '\$89.5K';
const expensePeriodLabel = 'JANUARY SPEND';
const expenseSummary =
    'January operating spend — \$89.5K of costs against \$101.3K of '
    'revenue';

const expenseCategories = [
  ExpenseCategory(
    label: 'Food & ingredients',
    percent: 37,
    amount: '\$33.4K',
    color: AppColors.accent,
  ),
  ExpenseCategory(
    label: 'Labor',
    percent: 32,
    amount: '\$29.1K',
    color: AppColors.blobBlueA,
  ),
  ExpenseCategory(
    label: 'Insurance, software & other',
    percent: 15,
    amount: '\$13.3K',
    color: AppColors.soft,
  ),
  ExpenseCategory(
    label: 'Rent (5th Ave storefront)',
    percent: 8,
    amount: '\$6.8K',
    color: AppColors.goodDot,
  ),
  ExpenseCategory(
    label: 'Delivery-app fees',
    percent: 6,
    amount: '\$5.1K',
    color: AppColors.blobBlueB,
  ),
  ExpenseCategory(
    label: 'Utilities (winter gas)',
    percent: 2,
    amount: '\$1.9K',
    color: AppColors.faintText,
  ),
];
