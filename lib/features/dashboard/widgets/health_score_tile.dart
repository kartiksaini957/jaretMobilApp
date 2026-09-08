import 'package:flutter/material.dart';
import '../../../theme/app_theme.dart';
class HealthScoreTile extends StatelessWidget {
  const HealthScoreTile({
    super.key,
    required this.label,
    required this.value,
    required this.rangeLabel,
    this.onTap,
  });

  final String label;
  final String value;
  final String rangeLabel;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      borderRadius: BorderRadius.circular(14),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(14),
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 16),
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              begin: Alignment.centerLeft,
              end: Alignment.centerRight,
              colors: [AppColors.baseDeep, AppColors.blobBlueA],
            ),
            borderRadius: BorderRadius.circular(14),
            border: Border.all(color: AppColors.glassBorder),
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Expanded(
                child: Text(
                  label,
                  style: AppTextStyles.small.copyWith(
                    color: AppColors.faintText,
                    fontWeight: FontWeight.w700,
                    letterSpacing: 0.4,
                  ),
                ),
              ),
              Expanded(
                child: Center(
                  child: Text(
                    value,
                    style: const TextStyle(
                      color: AppColors.accent,
                      fontSize: 30,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                ),
              ),
              Expanded(
                child: Text(
                  rangeLabel,
                  textAlign: TextAlign.right,
                  style: AppTextStyles.small.copyWith(color: AppColors.faintText),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
