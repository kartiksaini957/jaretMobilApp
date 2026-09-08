import 'package:flutter/material.dart';
import '../../../theme/app_theme.dart';
class FeatureBullet extends StatelessWidget {
  const FeatureBullet({
    super.key,
    required this.icon,
    required this.title,
    required this.subtitle,
  });

  final IconData icon;
  final String title;
  final String subtitle;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: 30,
          height: 30,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              begin: Alignment(-0.25, -1.0), // ~140deg
              end: Alignment(0.25, 1.0),
              colors: [
                Color(0xFF5FE0FF), 
                Color(0xFF0E9ED0),
              ],
            ),
            borderRadius: BorderRadius.circular(9),
          ),
          child: Icon(icon, size: 16, color: Colors.black),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: AppTextStyles.body.copyWith(
                  color: AppColors.white,
                  fontSize: 13.5,
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(height: 3),
              Text(
                subtitle,
                style: AppTextStyles.small.copyWith(color: AppColors.mutedText),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
