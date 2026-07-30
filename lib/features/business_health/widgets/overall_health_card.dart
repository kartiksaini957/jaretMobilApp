import 'package:flutter/material.dart';

import '../theme/business_health_colors.dart';

/// Big "74/100" score card at the top of Business Health: the score, a
/// status pill with the change-since line, and the AI confidence summary.
class OverallHealthCard extends StatelessWidget {
  const OverallHealthCard({
    super.key,
    required this.score,
    this.outOf = 100,
    required this.statusLabel,
    this.statusGood = true,
    this.deltaText,
    required this.confidenceText,
  });

  final int score;
  final int outOf;
  final String statusLabel;
  final bool statusGood;
  final String? deltaText;
  final String confidenceText;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 22, horizontal: 20),
      decoration: BoxDecoration(
        color: BusinessHealthColors.cardFill,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: BusinessHealthColors.cardBorder),
      ),
      child: Column(
        children: [
          RichText(
            text: TextSpan(
              children: [
                TextSpan(
                  text: '$score',
                  style: const TextStyle(
                    color: BusinessHealthColors.white,
                    fontSize: 44,
                    fontWeight: FontWeight.w800,
                    height: 1,
                  ),
                ),
                TextSpan(
                  text: '/$outOf',
                  style: const TextStyle(
                    color: BusinessHealthColors.faintText,
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 12),
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 5,
                ),
                decoration: BoxDecoration(
                  color: statusGood
                      ? BusinessHealthColors.pillGoodBg
                      : BusinessHealthColors.trackFill,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      width: 7,
                      height: 7,
                      decoration: BoxDecoration(
                        color: statusGood
                            ? BusinessHealthColors.dotGood
                            : BusinessHealthColors.dotNeutral,
                        shape: BoxShape.circle,
                      ),
                    ),
                    const SizedBox(width: 6),
                    Text(
                      statusLabel,
                      style: const TextStyle(
                        color: BusinessHealthColors.white,
                        fontSize: 12.5,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ],
                ),
              ),
              if (deltaText != null) ...[
                const SizedBox(width: 10),
                Text(
                  deltaText!,
                  style: const TextStyle(
                    color: BusinessHealthColors.faintText,
                    fontSize: 12.5,
                  ),
                ),
              ],
            ],
          ),
          const SizedBox(height: 14),
          Text(
            confidenceText,
            textAlign: TextAlign.center,
            style: const TextStyle(
              color: BusinessHealthColors.faintText,
              fontSize: 12.5,
              height: 1.4,
            ),
          ),
        ],
      ),
    );
  }
}
