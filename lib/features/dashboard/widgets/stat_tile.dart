import 'package:flutter/material.dart';

import '../../../theme/app_theme.dart';

/// Glass tile used in the "NUMBERS" grid: a label, a big value, an
/// optional delta line, and an optional status pill.
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
                        color: AppColors.faintText,
                        fontWeight: FontWeight.w700,
                        letterSpacing: 0.4,
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
                        color: (tagColor ?? AppColors.accent).withValues(
                          alpha: 0.18,
                        ),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(
                        tagLabel!,
                        style: TextStyle(
                          color: tagColor ?? AppColors.accent,
                          fontSize: 10,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                ],
              ),
              const SizedBox(height: 8),
              Text(
                value,
                style: TextStyle(
                  color: valueColor,
                  fontSize: 21,
                  fontWeight: FontWeight.w800,
                ),
              ),
              if (delta != null) ...[
                const SizedBox(height: 4),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  // mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      delta!,
                      style: AppTextStyles.small.copyWith(
                        color: AppColors.faintText,
                      ),
                    ),
                    if (showTrendArrow)
                      const Icon(
                        Icons.keyboard_arrow_down,
                        size: 20,
                        color: AppColors.faintText,
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
