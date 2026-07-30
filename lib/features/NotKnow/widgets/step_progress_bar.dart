import 'package:flutter/material.dart';

import '../../../theme/app_theme.dart';

/// Thin rounded progress track used under the "STEP X OF Y" eyebrow on
/// each onboarding screen.
class StepProgressBar extends StatelessWidget {
  const StepProgressBar({super.key, required this.step, required this.totalSteps});

  final int step;
  final int totalSteps;

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(4),
      child: LinearProgressIndicator(
        value: (step / totalSteps).clamp(0.0, 1.0),
        minHeight: 4,
        backgroundColor: AppColors.glassBorderSoft,
        color: AppColors.accent,
      ),
    );
  }
}
