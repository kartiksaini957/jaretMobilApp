import 'package:flutter/material.dart';

import '../theme/business_health_colors.dart';

/// Small grid tile used for each health category (Profitability, Cash,
/// Growth, Customers, Risk, Peers): title, score + delta, a status dot
/// line, and a progress bar.
class HealthCategoryCard extends StatelessWidget {
  const HealthCategoryCard({
    super.key,
    required this.title,
    required this.score,
    this.deltaText,
    this.deltaPositive = true,
    required this.statusText,
    this.statusGood,
    required this.progress,
  });

  final String title;
  final int score;
  final String? deltaText;
  final bool deltaPositive;
  final String statusText;
  final bool? statusGood;
  final double progress;

  @override
  Widget build(BuildContext context) {
    final dotColor = statusGood == null
        ? BusinessHealthColors.dotNeutral
        : statusGood!
        ? BusinessHealthColors.dotGood
        : BusinessHealthColors.dotNeutral;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: BusinessHealthColors.cardFill,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: BusinessHealthColors.cardBorder),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(
              color: BusinessHealthColors.faintText,
              fontSize: 11.5,
              fontWeight: FontWeight.w700,
              letterSpacing: 0.6,
            ),
          ),
          const SizedBox(height: 8),
          Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                '$score',
                style: const TextStyle(
                  color: BusinessHealthColors.white,
                  fontSize: 24,
                  fontWeight: FontWeight.w800,
                  height: 1,
                ),
              ),
              if (deltaText != null) ...[
                const SizedBox(width: 6),
                Padding(
                  padding: const EdgeInsets.only(bottom: 3),
                  child: Text(
                    deltaText!,
                    style: TextStyle(
                      color: deltaPositive
                          ? BusinessHealthColors.goodText
                          : BusinessHealthColors.negativeText,
                      fontSize: 12,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
              ],
            ],
          ),
          const SizedBox(height: 6),
          Row(
            children: [
              Container(
                width: 6,
                height: 6,
                decoration: BoxDecoration(color: dotColor, shape: BoxShape.circle),
              ),
              const SizedBox(width: 5),
              Expanded(
                child: Text(
                  statusText,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    color: BusinessHealthColors.faintText,
                    fontSize: 11,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          ClipRRect(
            borderRadius: BorderRadius.circular(3),
            child: LayoutBuilder(
              builder: (context, constraints) {
                return Stack(
                  children: [
                    Container(
                      height: 4,
                      width: constraints.maxWidth,
                      color: BusinessHealthColors.trackFill,
                    ),
                    Container(
                      height: 4,
                      width: constraints.maxWidth * progress.clamp(0.0, 1.0),
                      color: BusinessHealthColors.white,
                    ),
                  ],
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
