import 'package:flutter/material.dart';
import '../theme/financial_colors.dart';

class AiAnalysisCard extends StatelessWidget {
  const AiAnalysisCard({super.key, required this.title});

  final String title;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: FinancialColors.cardDarkFill,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: FinancialColors.cardBorder),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(
                Icons.auto_awesome,
                size: 15,
                color: FinancialColors.white,
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  '$title — AI Analysis',
                  style: const TextStyle(
                    color: FinancialColors.white,
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          const Text(
            'Unable to load analysis — please try again.',
            style: TextStyle(color: FinancialColors.faintText, fontSize: 12.5),
          ),
        ],
      ),
    );
  }
}
