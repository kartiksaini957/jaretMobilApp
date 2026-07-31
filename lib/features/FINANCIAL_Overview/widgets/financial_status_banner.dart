import 'package:flutter/material.dart';

import '../../../theme/app_theme.dart';

/// "You're profitable — 1 thing needs you this week." top banner, plus
/// the sync/freshness line.
class FinancialStatusBanner extends StatelessWidget {
  const FinancialStatusBanner({
    super.key,
    required this.headline,
    required this.freshnessLabel,
  });

  final String headline;
  final String freshnessLabel;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppColors.glassDark,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppColors.glassBorder),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Padding(
            padding: EdgeInsets.only(top: 4),
            child: Icon(Icons.circle, size: 8, color: AppColors.warnDot),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  headline,
                  style: AppTextStyles.buttonLabel.copyWith(fontSize: 14),
                ),
                const SizedBox(height: 4),
                Text(freshnessLabel, style: AppTextStyles.small),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
