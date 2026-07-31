import 'package:flutter/material.dart';

import '../../../theme/app_theme.dart';
import '../data/demand_forecast_data.dart';

/// "How the number breaks down" content: the four math rows.
class ForecastBreakdownPanel extends StatelessWidget {
  const ForecastBreakdownPanel({super.key, required this.data});

  final BreakdownData data;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _Row(label: 'Committed', value: data.committed),
        _Row(label: 'Expected losses', value: data.expectedLosses),
        _Row(label: 'Un-booked demand', value: data.unbookedDemand),
        _Row(label: 'External adjustment', value: data.externalAdjustment, last: true),
      ],
    );
  }
}

class _Row extends StatelessWidget {
  const _Row({required this.label, required this.value, this.last = false});

  final String label;
  final String value;
  final bool last;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(bottom: last ? 0 : 14),
      child: Container(
        padding: EdgeInsets.only(bottom: last ? 0 : 12),
        decoration: last
            ? null
            : const BoxDecoration(
                border: Border(
                  bottom: BorderSide(color: AppColors.glassBorderSoft),
                ),
              ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              label.toUpperCase(),
              style: AppTextStyles.small.copyWith(
                fontWeight: FontWeight.w700,
                letterSpacing: 0.4,
              ),
            ),
            const SizedBox(height: 4),
            Text(value, style: AppTextStyles.small.copyWith(height: 1.5)),
          ],
        ),
      ),
    );
  }
}
