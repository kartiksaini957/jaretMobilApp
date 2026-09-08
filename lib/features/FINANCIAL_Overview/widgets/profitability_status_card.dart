import 'package:flutter/material.dart';
import '../theme/financial_colors.dart';
import 'status_pill.dart';

class ProfitabilityStatusCard extends StatelessWidget {
  const ProfitabilityStatusCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: FinancialColors.cardLightFill,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: FinancialColors.cardBorder),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Wrap(
            spacing: 10,
            runSpacing: 6,
            crossAxisAlignment: WrapCrossAlignment.center,
            children: const [
              Text(
                'PROFITABILITY STATUS',
                style: TextStyle(
                  color: FinancialColors.faintText,
                  fontSize: 11.5,
                  fontWeight: FontWeight.w700,
                  letterSpacing: 0.5,
                ),
              ),
              StatusPill(
                label: 'Above Average',
                color: FinancialColors.statusGood,
                showDot: true,
              ),
            ],
          ),
          const SizedBox(height: 10),
          const Text(
            'Margins are strong — watch cash timing',
            style: TextStyle(
              color: FinancialColors.white,
              fontSize: 21,
              fontWeight: FontWeight.w800,
              height: 1.25,
            ),
          ),
          const SizedBox(height: 10),
          const Text(
            "You're earning well above peers. The main risk right now is "
            'collections lag adding pressure on near-term cash.',
            style: TextStyle(
              color: FinancialColors.mutedText,
              fontSize: 13,
              height: 1.4,
            ),
          ),
        ],
      ),
    );
  }
}
