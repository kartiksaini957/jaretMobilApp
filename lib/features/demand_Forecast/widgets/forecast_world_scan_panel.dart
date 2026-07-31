import 'package:flutter/material.dart';

import '../../../theme/app_theme.dart';
import '../data/demand_forecast_data.dart';

/// "World scan" content: an external/calendar signal, what it means, an
/// optional "Do now" line, and its source.
class ForecastWorldScanPanel extends StatelessWidget {
  const ForecastWorldScanPanel({super.key, required this.data});

  final WorldScanData data;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Expanded(
              child: Text(
                data.title,
                style: AppTextStyles.buttonLabel.copyWith(fontSize: 14),
              ),
            ),
            Text(
              data.dateLabel,
              style: AppTextStyles.small.copyWith(fontSize: 11),
            ),
          ],
        ),
        const SizedBox(height: 8),
        Text(data.body, style: AppTextStyles.small.copyWith(height: 1.5)),
        if (data.doNow != null) ...[
          const SizedBox(height: 8),
          Text(
            data.doNow!,
            style: AppTextStyles.small.copyWith(
              color: AppColors.white,
              fontWeight: FontWeight.w600,
              height: 1.5,
            ),
          ),
        ],
        const SizedBox(height: 8),
        Text(
          data.sourceLabel,
          style: AppTextStyles.small.copyWith(
            fontSize: 11,
            decoration: TextDecoration.underline,
          ),
        ),
      ],
    );
  }
}
