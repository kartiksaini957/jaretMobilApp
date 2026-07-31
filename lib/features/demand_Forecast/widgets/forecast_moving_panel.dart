import 'package:flutter/material.dart';

import '../../../theme/app_theme.dart';
import '../data/demand_forecast_data.dart';

/// "What's moving demand" content: one force per driver, with its dollar
/// swing, explanation, and confidence line.
class ForecastMovingPanel extends StatelessWidget {
  const ForecastMovingPanel({super.key, required this.items});

  final List<ForceItem> items;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        for (var i = 0; i < items.length; i++)
          Padding(
            padding: EdgeInsets.only(bottom: i == items.length - 1 ? 0 : 16),
            child: _ForceRow(item: items[i]),
          ),
      ],
    );
  }
}

class _ForceRow extends StatelessWidget {
  const _ForceRow({required this.item});

  final ForceItem item;

  @override
  Widget build(BuildContext context) {
    final color = item.positive ? AppColors.goodDot : AppColors.critDot;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Container(
              width: 6,
              height: 6,
              decoration: BoxDecoration(color: color, shape: BoxShape.circle),
            ),
            const SizedBox(width: 6),
            Expanded(
              child: Text(
                item.title,
                style: AppTextStyles.buttonLabel.copyWith(fontSize: 13.5),
              ),
            ),
            Text(
              item.deltaLabel,
              style: TextStyle(
                color: item.positive ? AppColors.goodText : AppColors.crit,
                fontSize: 13,
                fontWeight: FontWeight.w800,
              ),
            ),
          ],
        ),
        const SizedBox(height: 2),
        Padding(
          padding: const EdgeInsets.only(left: 12),
          child: Text(
            item.dateLabel,
            style: AppTextStyles.small.copyWith(fontSize: 11),
          ),
        ),
        const SizedBox(height: 6),
        Padding(
          padding: const EdgeInsets.only(left: 12),
          child: Text(
            item.body,
            style: AppTextStyles.small.copyWith(height: 1.5),
          ),
        ),
        const SizedBox(height: 6),
        Padding(
          padding: const EdgeInsets.only(left: 12),
          child: Text.rich(
            TextSpan(
              children: [
                TextSpan(
                  text: '${item.confidencePercent}% confidence',
                  style: const TextStyle(
                    color: AppColors.white,
                    fontSize: 11,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                TextSpan(
                  text: '  ·  ${item.sourceLabel}',
                  style: AppTextStyles.small.copyWith(fontSize: 11),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
