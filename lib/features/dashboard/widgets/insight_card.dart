import 'package:flutter/material.dart';

import '../../../theme/app_theme.dart';

/// Small glass card used for "THE ISSUE" / "THE MOVE" / "OPPORTUNITY"
/// style callouts: a dotted label, an optional bold headline, and an
/// optional body line.
class InsightCard extends StatelessWidget {
  const InsightCard({
    super.key,
    required this.dotColor,
    required this.label,
    this.headline,
    this.body,
    this.bodyColor = AppColors.white,
  });

  final Color dotColor;
  final String label;
  final String? headline;
  final String? body;
  final Color bodyColor;

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
              Container(
                width: 8,
                height: 8,
                decoration: BoxDecoration(
                  color: dotColor,
                  shape: BoxShape.circle,
                ),
              ),
              const SizedBox(width: 8),
              Text(
                label,
                style: const TextStyle(
                  color: AppColors.white,
                  fontSize: 12,
                  fontWeight: FontWeight.w700,
                  letterSpacing: 0.6,
                ),
              ),
            ],
          ),
          if (headline != null) ...[
            const SizedBox(height: 10),
            Text(
              headline!,
              style: const TextStyle(
                color: AppColors.white,
                fontSize: 14.5,
                fontWeight: FontWeight.w700,
                height: 1.35,
              ),
            ),
          ],
          if (body != null) ...[
            SizedBox(height: headline != null ? 6 : 10),
            Text(body!, style: AppTextStyles.body.copyWith(color: bodyColor)),
          ],
        ],
      ),
    );
  }
}
