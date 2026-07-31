import 'package:flutter/material.dart';

import '../../../theme/app_theme.dart';

/// Dismissible "BUSINESSES LIKE YOURS" insight banner: an eyebrow label
/// with a close button, then a paragraph with a highlighted phrase.
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
                  eyebrow,
                  style: const TextStyle(
                    color: AppColors.accent,
                    fontSize: 11,
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
                  child: Icon(Icons.close, size: 16, color: AppColors.faintText),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          RichText(
            text: TextSpan(
              style: AppTextStyles.small.copyWith(height: 1.5),
              children: [
                TextSpan(text: leadText),
                TextSpan(
                  text: highlight,
                  style: const TextStyle(
                    color: AppColors.goodText,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                TextSpan(text: trailText),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
