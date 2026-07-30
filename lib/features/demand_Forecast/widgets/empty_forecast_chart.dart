import 'package:flutter/material.dart';

import '../theme/demand_colors.dart';

/// Empty-state axis grid shown while there isn't yet a forecast to plot.
class EmptyForecastChart extends StatelessWidget {
  const EmptyForecastChart({super.key});

  static const _labels = ['\$1', '\$0.75', '\$0.5', '\$0.25', '\$0'];

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 160,
      child: Column(
        children: [
          for (final label in _labels)
            Expanded(
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SizedBox(
                    width: 36,
                    child: Text(
                      label,
                      style: const TextStyle(
                        color: DemandColors.faintText,
                        fontSize: 10.5,
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Container(height: 1, color: DemandColors.cardBorder),
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }
}
