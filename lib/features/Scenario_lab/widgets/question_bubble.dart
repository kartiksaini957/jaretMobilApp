import 'package:flutter/material.dart';

import '../../opportunity/ScenarioLab/widgets/scenario_lab_colors.dart';

/// The asked question, shown as a right-aligned translucent bubble.
class QuestionBubble extends StatelessWidget {
  const QuestionBubble({super.key, required this.text});

  final String text;

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.centerRight,
      child: Container(
        constraints: BoxConstraints(
          maxWidth: MediaQuery.of(context).size.width * 0.8,
        ),
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
        decoration: BoxDecoration(
          color: ScenarioLabColors.cardFillStrong,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: ScenarioLabColors.cardBorder),
        ),
        child: Text(
          text,
          style: const TextStyle(
            color: ScenarioLabColors.white,
            fontSize: 13.5,
            fontWeight: FontWeight.w600,
            height: 1.35,
          ),
        ),
      ),
    );
  }
}
