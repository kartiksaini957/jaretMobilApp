import 'package:flutter/material.dart';
import '../../../theme/app_theme.dart';
import '../data/home_overview_data.dart';

class HomeSummaryCard extends StatelessWidget {
  const HomeSummaryCard({
    super.key,
    required this.topCard,
    required this.onTopCardTap,
  });

  final HomeStoryCard topCard;
  final VoidCallback onTopCardTap;

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
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
            decoration: BoxDecoration(
              color: AppColors.white.withValues(alpha: 0.15),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(Icons.circle, size: 8, color: AppColors.warnDot),
                const SizedBox(width: 8),
                Text(homeSummaryEyebrow, style: AppTextStyles.eyebrow),
              ],
            ),
          ),
          const SizedBox(height: 14),
          RichText(
            textAlign: TextAlign.center,
            text: TextSpan(
              style: AppTextStyles.headline.copyWith(fontSize: 40),
              children: [
                TextSpan(
                  text: homeSummaryHeadlineLead,
                  style: AppTextStyles.headline.copyWith(fontSize: 40),
                ),
                TextSpan(
                  text: homeSummaryHeadlineAccent,
                  style: const TextStyle(color: AppColors.accent, fontSize: 40),
                ),
              ],
            ),
          ),
          const SizedBox(height: 12),
          Container(width: 32, height: 2, color: AppColors.glassBorder),
          const SizedBox(height: 12),
          Text(
            homeSummaryBody,
            textAlign: TextAlign.center,
            style: AppTextStyles.small.copyWith(height: 1.5, fontSize: 14.5),
          ),
          const SizedBox(height: 16),
          Material(
            color: AppColors.glassLight,
            borderRadius: BorderRadius.circular(12),
            child: InkWell(
              onTap: onTopCardTap,
              borderRadius: BorderRadius.circular(12),
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 12,
                ),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: topCard.status.color.withValues(alpha: 0.4),
                  ),
                ),
                child: Row(
                  children: [
                    Container(
                      width: 7,
                      height: 7,
                      decoration: BoxDecoration(
                        color: topCard.status.color,
                        shape: BoxShape.circle,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            topCard.headline,
                            style: AppTextStyles.headline.copyWith(
                              fontSize: 14.5,
                              color: Colors.white,
                            ),
                          ),
                          const SizedBox(height: 3),
                          Text(
                            topCard.statLabel,
                            style: AppTextStyles.small.copyWith(fontSize: 12),
                          ),
                        ],
                      ),
                    ),
                    const Icon(
                      Icons.arrow_forward,
                      size: 16,
                      color: AppColors.white,
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
