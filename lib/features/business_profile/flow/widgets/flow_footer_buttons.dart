import 'package:flutter/material.dart';

import '../../../../theme/app_theme.dart';

/// Secondary pill (Later/Skip) + primary filled pill (Continue/Save &
/// finish later), the footer row on every flow card.
class FlowFooterButtons extends StatelessWidget {
  const FlowFooterButtons({
    super.key,
    required this.secondaryLabel,
    required this.onSecondary,
    required this.primaryLabel,
    required this.onPrimary,
  });

  final String secondaryLabel;
  final VoidCallback onSecondary;
  final String primaryLabel;
  final VoidCallback onPrimary;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        OutlinedButton(
          onPressed: onSecondary,
          style: OutlinedButton.styleFrom(
            side: const BorderSide(color: AppColors.glassBorder),
            padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 12),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(24),
            ),
          ),
          child: Text(
            secondaryLabel,
            style: AppTextStyles.buttonLabel.copyWith(fontSize: 13),
          ),
        ),
        const Spacer(),
        ElevatedButton(
          onPressed: onPrimary,
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.accent,
            foregroundColor: AppColors.ink,
            elevation: 0,
            padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 12),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(24),
            ),
          ),
          child: Text(
            primaryLabel,
            style: AppTextStyles.buttonLabel.copyWith(
              fontSize: 13,
              color: const Color(0xFF04303F),
              fontWeight: FontWeight.w700,
            ),
          ),
        ),
      ],
    );
  }
}
