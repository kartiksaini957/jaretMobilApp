import 'package:flutter/material.dart';
import '../../../theme/app_theme.dart';
import '../data/financial_overview_data.dart';
class FinancialSuggestedActionsSheet extends StatelessWidget {
  const FinancialSuggestedActionsSheet({
    super.key,
    required this.metricLabel,
    required this.actions,
  });

  final String metricLabel;
  final List<SuggestedAction> actions;

  static Future<void> show(
    BuildContext context, {
    required String metricLabel,
    required List<SuggestedAction> actions,
  }) {
    return showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (_) => FinancialSuggestedActionsSheet(
        metricLabel: metricLabel,
        actions: actions,
      ),
    );
  }

  Color _priorityColor(String priority) =>
      priority == 'HIGH' ? AppColors.critDot : AppColors.warnDot;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: false,
      child: Container(
        constraints: BoxConstraints(
          maxHeight: MediaQuery.of(context).size.height * 0.8,
        ),
        padding: const EdgeInsets.fromLTRB(20, 12, 20, 20),
        decoration: const BoxDecoration(
          color: AppColors.sheetSurface,
          borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Container(
                width: 36,
                height: 4,
                decoration: BoxDecoration(
                  color: AppColors.glassBorder,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),
            const SizedBox(height: 16),
            Text(
              'SUGGESTED ACTIONS — ${metricLabel.toUpperCase()}',
              style: AppTextStyles.eyebrow,
            ),
            const SizedBox(height: 14),
            Flexible(
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    for (final action in actions)
                      Padding(
                        padding: const EdgeInsets.only(bottom: 14),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 8,
                                vertical: 3,
                              ),
                              decoration: BoxDecoration(
                                color: _priorityColor(
                                  action.priority,
                                ).withValues(alpha: 0.18),
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: Text(
                                action.priority,
                                style: TextStyle(
                                  color: _priorityColor(action.priority),
                                  fontSize: 10,
                                  fontWeight: FontWeight.w800,
                                ),
                              ),
                            ),
                            const SizedBox(width: 10),
                            Expanded(
                              child: Text(
                                action.body,
                                style: AppTextStyles.small.copyWith(
                                  height: 1.5,
                                  color: AppColors.white,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
