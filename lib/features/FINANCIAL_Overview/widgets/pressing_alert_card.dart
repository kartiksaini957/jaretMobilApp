import 'package:flutter/material.dart';
import '../theme/financial_colors.dart';

class PressingAlertCard extends StatelessWidget {
  const PressingAlertCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: FinancialColors.cardDarkFill,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: FinancialColors.cardBorder),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 7,
                height: 7,
                decoration: const BoxDecoration(
                  color: FinancialColors.alertBorder,
                  shape: BoxShape.circle,
                ),
              ),
              const SizedBox(width: 6),
              const Text(
                'PRESSING NOW',
                style: TextStyle(
                  color: FinancialColors.alertBorder,
                  fontSize: 11,
                  fontWeight: FontWeight.w700,
                  letterSpacing: 0.5,
                ),
              ),
              const Text(
                ' · SCORE 72',
                style: TextStyle(
                  color: FinancialColors.faintText,
                  fontSize: 11,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          const Text(
            'Overdue invoices are building up',
            style: TextStyle(
              color: FinancialColors.white,
              fontSize: 18.5,
              fontWeight: FontWeight.w800,
              height: 1.25,
            ),
          ),
          const SizedBox(height: 16),
          const _Label('WHAT\'S GOING ON'),
          const SizedBox(height: 4),
          const Text(
            "42% of your receivables are past 30 days, totalling ~\$8K.",
            style: TextStyle(
              color: FinancialColors.mutedText,
              fontSize: 13,
              height: 1.4,
            ),
          ),
          const SizedBox(height: 14),
          const _Label('WHY IT MATTERS NOW'),
          const SizedBox(height: 4),
          const Text(
            "If these aren't collected in the next 2 weeks, cash dips "
            'below safe operating level.',
            style: TextStyle(
              color: FinancialColors.mutedText,
              fontSize: 13,
              height: 1.4,
            ),
          ),
          const SizedBox(height: 16),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: FinancialColors.cardLightFill,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: FinancialColors.cardBorder),
            ),
            child: const Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _Label('WHAT TO DO'),
                SizedBox(height: 6),
                Text(
                  'Send follow-up emails to the 3 overdue accounts today. '
                  'Offer a 2% early-pay discount.',
                  style: TextStyle(
                    color: FinancialColors.white,
                    fontSize: 13.5,
                    fontWeight: FontWeight.w600,
                    height: 1.4,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const _Label('EXPECTED IMPACT'),
                    const SizedBox(height: 4),
                    const Text(
                      '+\$8K cash within 14 days',
                      style: TextStyle(
                        color: FinancialColors.goodText,
                        fontSize: 12.5,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      'Based on current AR aging',
                      style: TextStyle(
                        color: FinancialColors.faintText.withValues(alpha: 0.8),
                        fontSize: 10,
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: const [
                    _Label('EFFORT'),
                    SizedBox(height: 4),
                    Text(
                      'Quick win',
                      style: TextStyle(
                        color: FinancialColors.white,
                        fontSize: 12.5,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: const [
                    _Label('CONFIDENCE'),
                    SizedBox(height: 4),
                    Text(
                      'High',
                      style: TextStyle(
                        color: FinancialColors.white,
                        fontSize: 12.5,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _Label extends StatelessWidget {
  const _Label(this.text);

  final String text;

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: const TextStyle(
        color: FinancialColors.faintText,
        fontSize: 10,
        fontWeight: FontWeight.w700,
        letterSpacing: 0.5,
      ),
    );
  }
}
