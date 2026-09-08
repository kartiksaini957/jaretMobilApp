import 'package:flutter/material.dart';
import '../../../theme/app_theme.dart';

class ProfileInsightBanner extends StatelessWidget {
  const ProfileInsightBanner({
    super.key,
    required this.eyebrow,
    required this.leadText,
    required this.highlight,
    required this.trailText,
    required this.onDismiss,
  });

  final String eyebrow;
  final String leadText;
  final String highlight;
  final String trailText;
  final VoidCallback onDismiss;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0x0DFFFFFF),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppColors.glassBorder),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  eyebrow,
                  style: AppTextStyles.body.copyWith(
                    color: AppColors.accent,
                    fontSize: 10,
                    fontWeight: FontWeight.w700,
                    letterSpacing: 0.8,
                  ),
                ),
              ),
              InkWell(
                onTap: onDismiss,
                borderRadius: BorderRadius.circular(20),
                child: const Padding(
                  padding: EdgeInsets.all(2),
                  child: Icon(
                    Icons.close,
                    size: 16,
                    color: AppColors.faintText,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          RichText(
            text: TextSpan(
              style: AppTextStyles.small.copyWith(height: 1.5),
              children: [
                TextSpan(
                  text: leadText,
                  style: AppTextStyles.body.copyWith(
                    color: AppColors.white,
                    fontWeight: FontWeight.w700,
                    fontSize: 12.5,

                    // fontSize: 14,
                    height: 1.5,
                  ),
                ),
                TextSpan(
                  text: highlight,
                  style: AppTextStyles.body.copyWith(
                    color: AppColors.goodText,
                    fontSize: 12.5,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                TextSpan(
                  text: trailText,
                  style: AppTextStyles.body.copyWith(
                    color: AppColors.white,
                    fontSize: 12.5,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
