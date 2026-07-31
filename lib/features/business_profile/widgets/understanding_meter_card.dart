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
        color: AppColors.glassDark,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.glassBorder),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  'How well we understand your business',
                  style: AppTextStyles.buttonLabel.copyWith(fontSize: 14.5),
                ),
              ),
              const SizedBox(width: 8),
              Text(
                statusLabel,
                style: const TextStyle(
                  color: AppColors.accent,
                  fontSize: 13.5,
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
                      height: 6,
                      width: constraints.maxWidth,
                      color: AppColors.glassLight,
                    ),
                    Container(
                      height: 6,
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
          Text(caption, style: AppTextStyles.small),
        ],
      ),
    );
  }
}
