import 'package:flutter/material.dart';

import '../../../../theme/app_theme.dart';

/// Row of small dots — filled for answered questions, outlined for the
/// rest — plus an "X of Y answered" label.
class FlowProgressDots extends StatelessWidget {
  const FlowProgressDots({
    super.key,
    required this.total,
    required this.answered,
  });

  final int total;
  final int answered;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        for (var i = 0; i < total; i++)
          Padding(
            padding: const EdgeInsets.only(right: 5),
            child: Container(
              width: 7,
              height: 7,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: i < answered ? AppColors.goodDot : Colors.transparent,
                border: i < answered
                    ? null
                    : Border.all(color: AppColors.glassBorder),
              ),
            ),
          ),
        const SizedBox(width: 6),
        Text(
          '$answered of $total answered',
          style: AppTextStyles.small.copyWith(
            fontWeight: FontWeight.w700,
            color: const Color(0xFFCFEFFB),
            fontSize: 11.5,
            letterSpacing: 0.8,
          ),
        ),
      ],
    );
  }
}
