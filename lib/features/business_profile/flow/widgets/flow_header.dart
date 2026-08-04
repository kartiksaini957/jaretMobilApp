import 'package:flutter/material.dart';

import '../../../../theme/app_theme.dart';

/// Circular back button + eyebrow label, shared by the intro and every
/// question screen in a [ProfileSectionFlow].
class FlowHeader extends StatelessWidget {
  const FlowHeader({super.key, required this.label, required this.onBack});

  final String label;
  final VoidCallback onBack;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Material(
          color: AppColors.glassLight,
          shape: const CircleBorder(),
          child: InkWell(
            onTap: onBack,
            customBorder: const CircleBorder(),
            child: const Padding(
              padding: EdgeInsets.all(8),
              child: Icon(Icons.arrow_back, size: 16, color: AppColors.white),
            ),
          ),
        ),
        const SizedBox(width: 10),
        Text(
          label,
          style: AppTextStyles.eyebrow.copyWith(
            color: const Color(0xFFCFEFFB),
            fontSize: 10.5,
            fontWeight: FontWeight.w700,
            letterSpacing: 0.8,
          ),
        ),
      ],
    );
  }
}
