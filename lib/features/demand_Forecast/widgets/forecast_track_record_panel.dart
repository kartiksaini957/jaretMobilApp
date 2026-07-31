import 'package:flutter/material.dart';

import '../../../theme/app_theme.dart';

/// "Track record" content: two short paragraphs — the stat, then the
/// takeaway.
class ForecastTrackRecordPanel extends StatelessWidget {
  const ForecastTrackRecordPanel({
    super.key,
    required this.body,
    required this.footer,
  });

  final String body;
  final String footer;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(body, style: AppTextStyles.small.copyWith(height: 1.5)),
        const SizedBox(height: 8),
        Text(
          footer,
          style: AppTextStyles.small.copyWith(
            color: AppColors.white,
            fontWeight: FontWeight.w600,
            height: 1.5,
          ),
        ),
      ],
    );
  }
}
