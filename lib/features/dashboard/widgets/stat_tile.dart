import 'package:flutter/material.dart';
import '../../../theme/app_theme.dart';
class StatTile extends StatelessWidget {
  const StatTile({
    super.key,
    required this.label,
    required this.value,
    this.delta,
    this.tagLabel,
    this.tagColor,
    this.valueColor = AppColors.white,
    this.showTrendArrow = true,
    this.onTap,
  });

  final String label;
  final String value;
  final String? delta;
  final String? tagLabel;
  final Color? tagColor;
  final Color valueColor;
  final bool showTrendArrow;
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
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            color: AppColors.glassDark,
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
                      label,
                      style: AppTextStyles.small.copyWith(
                        color: Colors.white,
                        fontWeight: FontWeight.w700,
                        letterSpacing: 0.4,
                        fontSize: 11.0,
                      ),
                    ),
                  ),
                  if (tagLabel != null)
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 3,
                      ),
                      decoration: BoxDecoration(
                        color: (tagColor ?? Color(0xFFA6F5DC)).withValues(
                          alpha: 0.18,
                        ),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(
                        tagLabel!,
                        style: AppTextStyles.small.copyWith(
                          color: tagColor ?? Color(0xFFA6F5DC),
                          fontWeight: FontWeight.w700,
                          letterSpacing: 0.4,
                          fontSize: 9.0,
                        ),
                      ),
                    ),
                ],
              ),
              const SizedBox(height: 8),
              Text(
                value,
                style: AppTextStyles.logo.copyWith(
                  fontSize: 29,
                  color: Colors.white,
                  fontWeight: FontWeight.w700,
                ),
              ),
              if (delta != null) ...[
                const SizedBox(height: 4),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      delta!,
                      style: AppTextStyles.small.copyWith(
                        color: AppColors.white,
                        fontSize: 12.0,
                      ),
                    ),
                    if (showTrendArrow)
                      const Icon(
                        Icons.keyboard_arrow_down,
                        size: 20,
                        color: AppColors.white,
                      ),
                  ],
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
