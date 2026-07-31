import 'package:flutter/material.dart';

import '../../../theme/app_theme.dart';

/// Generic title + pill-button + caption card used for "How LightSignal
/// sees your business" and "Tell LightSignal something".
class ProfileInfoCard extends StatelessWidget {
  const ProfileInfoCard({
    super.key,
    required this.title,
    required this.caption,
    required this.pillLabel,
    this.pillColor = AppColors.white,
    required this.onPillTap,
  });

  final String title;
  final String caption;
  final String pillLabel;
  final Color pillColor;
  final VoidCallback onPillTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: AppColors.glassDark,
      borderRadius: BorderRadius.circular(16),
      child: InkWell(
        onTap: onPillTap,
        borderRadius: BorderRadius.circular(16),
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: AppColors.glassBorder),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: Text(
                      title,
                      style: AppTextStyles.buttonLabel.copyWith(
                        fontSize: 14.5,
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 6,
                    ),
                    decoration: BoxDecoration(
                      border: Border.all(color: pillColor),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      pillLabel,
                      style: TextStyle(
                        color: pillColor,
                        fontSize: 11,
                        fontWeight: FontWeight.w800,
                        letterSpacing: 0.3,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Text(caption, style: AppTextStyles.small),
            ],
          ),
        ),
      ),
    );
  }
}
