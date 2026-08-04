import 'package:flutter/material.dart';
import '../../../theme/app_theme.dart';

class StepProgressBar extends StatelessWidget {
  const StepProgressBar({
    super.key,
    required this.step,
    required this.totalSteps,
  });

  final int step;
  final int totalSteps;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 4,
      child: Row(
        children: List.generate(totalSteps, (index) {
          final isCompleted = index < step;

          return Expanded(
            child: Padding(
              padding: EdgeInsets.only(
                right: index == totalSteps - 1 ? 0 : 6, // gap between segments
              ),
              child: Container(
                height: 4,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(4),
                  color: isCompleted
                      ? AppColors.accent
                      : AppColors.white.withOpacity(0.16), // Inactive color
                ),
              ),
            ),
          );
        }),
      ),
    );
  }
}
