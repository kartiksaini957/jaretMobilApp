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
      color: Colors.transparent,
      borderRadius: BorderRadius.circular(16),
      child: InkWell(
        onTap: onPillTap,
        borderRadius: BorderRadius.circular(16),
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: const Color(0x33FFFFFF)),
            gradient: const LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                Color.fromRGBO(95, 224, 255, 0.16),
                Color.fromRGBO(95, 224, 255, 0.05),
              ],
            ),
            boxShadow: const [
              BoxShadow(
                color: Color.fromRGBO(0, 20, 40, 0.20),
                blurRadius: 24,
                offset: Offset(0, 8),
              ),
            ],
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
                      style: AppTextStyles.buttonLabel.copyWith(fontSize: 14),
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
                      style: AppTextStyles.buttonLabel.copyWith(
                        color: pillColor,
                        fontSize: 9.5,
                        fontWeight: FontWeight.w700,
                        letterSpacing: 0.3,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Text(
                caption,
                style: AppTextStyles.small.copyWith(
                  height: 1.5,
                  fontSize: 11.5,
                  fontWeight: FontWeight.w400,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
