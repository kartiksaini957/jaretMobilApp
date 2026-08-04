import 'package:flutter/material.dart';

import '../../../theme/app_theme.dart';

/// "How well we understand your business" card: a status word (Building /
/// Strong / etc.), a gradient progress meter, and a one-line caption.
class UnderstandingMeterCard extends StatelessWidget {
  const UnderstandingMeterCard({
    super.key,
    required this.statusLabel,
    required this.progress,
    required this.caption,
  });

  final String statusLabel;
  final double progress;
  final String caption;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0x0DFFFFFF),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppColors.glassLight),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  'How well we understand your business',
                  style: AppTextStyles.buttonLabel.copyWith(
                    fontSize: 12.5,
                    color: AppColors.mutedText,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
              const SizedBox(width: 8),
              Text(
                statusLabel,
                style: AppTextStyles.headline.copyWith(
                  color: AppColors.accent,
                  fontSize: 14,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          ClipRRect(
            borderRadius: BorderRadius.circular(4),
            child: LayoutBuilder(
              builder: (context, constraints) {
                return Stack(
                  children: [
                    Container(
                      height: 8,
                      width: constraints.maxWidth,
                      color: AppColors.glassLight,
                    ),
                    Container(
                      height: 8,
                      width: constraints.maxWidth * progress.clamp(0.0, 1.0),
                      decoration: const BoxDecoration(
                        gradient: LinearGradient(
                          colors: [AppColors.goodDot, AppColors.accent],
                        ),
                      ),
                    ),
                  ],
                );
              },
            ),
          ),
          const SizedBox(height: 10),
          Text(
            caption,
            style: AppTextStyles.small.copyWith(
              color: AppColors.mutedText,
              fontSize: 11.5,
            ),
          ),
        ],
      ),
    );
  }
}
