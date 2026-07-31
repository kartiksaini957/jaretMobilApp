import 'package:flutter/material.dart';

import '../../../theme/app_theme.dart';

/// Small 5-bar sparkline: the last bar (current period) is highlighted.
class FinancialBarChart extends StatelessWidget {
  const FinancialBarChart({super.key, required this.values});

  /// Relative heights, 0..1, oldest to newest.
  final List<double> values;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 44,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          for (var i = 0; i < values.length; i++) ...[
            if (i != 0) const SizedBox(width: 6),
            Expanded(
              child: Container(
                height: 44 * values[i].clamp(0.08, 1.0),
                decoration: BoxDecoration(
                  color: i == values.length - 1
                      ? AppColors.warnDot
                      : AppColors.glassLight,
                  borderRadius: BorderRadius.circular(4),
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }
}
