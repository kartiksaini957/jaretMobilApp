import 'package:flutter/material.dart';

import '../../../../theme/app_theme.dart';
import '../../data/classification_data.dart';

/// Dot + "High/Moderate/Low confidence" label, plus a "PLEASE VERIFY"
/// pill when confidence is low.
class ConfidenceBadge extends StatelessWidget {
  const ConfidenceBadge({super.key, required this.confidence});

  final ConfidenceLevel confidence;

  String get _label => switch (confidence) {
    ConfidenceLevel.high => 'High confidence',
    ConfidenceLevel.moderate => 'Moderate confidence',
    ConfidenceLevel.low => 'Low confidence',
  };

  Color get _dotColor => switch (confidence) {
    ConfidenceLevel.high => AppColors.goodDot,
    ConfidenceLevel.moderate => AppColors.warnDot,
    ConfidenceLevel.low => AppColors.warnDot,
  };

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 6,
          height: 6,
          decoration: BoxDecoration(color: _dotColor, shape: BoxShape.circle),
        ),
        const SizedBox(width: 5),
        Text(
          _label,
          style: AppTextStyles.small.copyWith(fontWeight: FontWeight.w600),
        ),
        if (confidence == ConfidenceLevel.low) ...[
          const SizedBox(width: 8),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
            decoration: BoxDecoration(
              color: AppColors.warnDot,
              borderRadius: BorderRadius.circular(20),
            ),
            child: Text(
              'PLEASE VERIFY',
              style: TextStyle(
                color: AppColors.ink,
                fontSize: 9.5,
                fontWeight: FontWeight.w800,
                letterSpacing: 0.3,
              ),
            ),
          ),
        ],
      ],
    );
  }
}
