import 'package:flutter/material.dart';
import 'package:flutter_application_1/theme/app_theme.dart';

import '../theme/business_health_colors.dart';
import 'health_category_card.dart';
import 'narrative_card.dart';
import 'overall_health_card.dart';

/// Dismissible "JAN 11 SNAPSHOT" panel: a past period's score, category
/// grid, and narrative, so the current numbers can be compared against it.
class PreviousSnapshotCard extends StatelessWidget {
  const PreviousSnapshotCard({
    super.key,
    required this.label,
    required this.score,
    required this.statusLabel,
    required this.statusGood,
    required this.confidenceText,
    required this.categories,
    required this.narrative,
    required this.onDismiss,
  });

  final String label;
  final int score;
  final String statusLabel;
  final bool statusGood;
  final String confidenceText;
  final List<HealthCategoryCard> categories;
  final String narrative;
  final VoidCallback onDismiss;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: BusinessHealthColors.cardBorder),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 6,
                height: 6,
                decoration: const BoxDecoration(
                  color: BusinessHealthColors.dotGood,
                  shape: BoxShape.circle,
                ),
              ),
              const SizedBox(width: 8),
              Text(
                label,
                style: AppTextStyles.body.copyWith(
                  color: BusinessHealthColors.faintText,
                  fontSize: 11,
                  fontWeight: FontWeight.w700,
                  letterSpacing: 0.8,
                ),
              ),
              const Spacer(),
              InkWell(
                onTap: onDismiss,
                borderRadius: BorderRadius.circular(20),
                child: Padding(
                  padding: EdgeInsets.all(0),
                  child: Container(
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: const Color.fromRGBO(
                          255,
                          255,
                          255,
                          0.28,
                        ), // border color
                        width: 1,
                      ),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(2.0),
                      child: Icon(
                        Icons.close,
                        size: 16,
                        color: BusinessHealthColors.faintText,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),
          OverallHealthCard(
            score: score,
            statusLabel: statusLabel,
            statusGood: statusGood,
            confidenceText: confidenceText,
          ),
          const SizedBox(height: 16),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(child: categories[0]),
              const SizedBox(width: 12),
              Expanded(child: categories[1]),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(child: categories[2]),
              const SizedBox(width: 12),
              Expanded(child: categories[3]),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(child: categories[4]),
              const SizedBox(width: 12),
              Expanded(child: categories[5]),
            ],
          ),
          const SizedBox(height: 16),
          NarrativeCard(text: narrative),
        ],
      ),
    );
  }
}
