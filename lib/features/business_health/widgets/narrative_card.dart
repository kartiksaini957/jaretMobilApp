import 'package:flutter/material.dart';

import '../theme/business_health_colors.dart';

/// Plain bordered paragraph card used for the AI narrative under a score
/// (current month or a past snapshot).
class NarrativeCard extends StatelessWidget {
  const NarrativeCard({super.key, required this.text});

  final String text;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: BusinessHealthColors.cardFill,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: BusinessHealthColors.cardBorder),
      ),
      child: Text(
        text,
        style: const TextStyle(
          color: BusinessHealthColors.mutedText,
          fontSize: 13.5,
          height: 1.5,
        ),
      ),
    );
  }
}
