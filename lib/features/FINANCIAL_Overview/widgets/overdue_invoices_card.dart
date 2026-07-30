import 'package:flutter/material.dart';

import '../theme/financial_colors.dart';

/// "Overdue invoices" card: three fanned invoice mockups over a glowing
/// red total box. Layout/colors mirror the papers_piling reference asset.
class OverdueInvoicesCard extends StatelessWidget {
  const OverdueInvoicesCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 22, horizontal: 16),
      decoration: BoxDecoration(
        color: FinancialColors.cardDarkFill,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: FinancialColors.cardBorder),
      ),
      child: Column(
        children: [
          const Text(
            'OVERDUE INVOICES',
            style: TextStyle(
              color: FinancialColors.faintText,
              fontSize: 11.5,
              fontWeight: FontWeight.w700,
              letterSpacing: 0.6,
            ),
          ),
          const SizedBox(height: 18),
          const SizedBox(
            width: 338,
            height: 145,
            child: Stack(
              children: [
                Positioned(
                  top: 30,
                  left: 0,
                  child: _InvoiceMiniCard(
                    name: 'Henderson Wedding',
                    amount: '\$3,200',
                    daysOverdue: '45 days overdue',
                    rotation: -7,
                  ),
                ),
                Positioned(
                  top: 8,
                  left: 84,
                  child: _InvoiceMiniCard(
                    name: 'Acme Corp',
                    amount: '\$2,100',
                    daysOverdue: '38 days overdue',
                    rotation: 2,
                  ),
                ),
                Positioned(
                  top: 24,
                  left: 168,
                  child: _InvoiceMiniCard(
                    name: 'Westfield Plaza',
                    amount: '\$2,700',
                    daysOverdue: '52 days overdue',
                    rotation: -3,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 18),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 22, vertical: 12),
            decoration: BoxDecoration(
              color: FinancialColors.alertBorder.withValues(alpha: 0.06),
              borderRadius: BorderRadius.circular(10),
              border: Border.all(
                color: FinancialColors.alertBorder,
                width: 2.5,
              ),
              boxShadow: [
                BoxShadow(
                  color: FinancialColors.alertBorder.withValues(alpha: 0.35),
                  blurRadius: 24,
                ),
              ],
            ),
            child: const Column(
              children: [
                Text(
                  'OVERDUE TOTAL',
                  style: TextStyle(
                    color: Color(0x73FFFFFF),
                    fontSize: 9.5,
                    fontWeight: FontWeight.w700,
                    letterSpacing: 1,
                  ),
                ),
                SizedBox(height: 4),
                Text(
                  '\$8,000',
                  style: TextStyle(
                    color: FinancialColors.white,
                    fontSize: 32,
                    fontWeight: FontWeight.w800,
                    height: 1,
                  ),
                ),
                SizedBox(height: 4),
                Text(
                  '3 invoices',
                  style: TextStyle(color: Color(0x73FFFFFF), fontSize: 11),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _InvoiceMiniCard extends StatelessWidget {
  const _InvoiceMiniCard({
    required this.name,
    required this.amount,
    required this.daysOverdue,
    required this.rotation,
  });

  final String name;
  final String amount;
  final String daysOverdue;
  final double rotation;

  @override
  Widget build(BuildContext context) {
    return Transform.rotate(
      angle: rotation * 3.1415926535 / 180,
      child: Container(
        width: 150,
        height: 100,
        padding: const EdgeInsets.fromLTRB(12, 10, 12, 8),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(7),
          boxShadow: const [
            BoxShadow(
              color: Color(0x66000000),
              blurRadius: 18,
              offset: Offset(0, 6),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Text(
                    name,
                    style: const TextStyle(
                      color: Color(0xFF374151),
                      fontSize: 9,
                      fontWeight: FontWeight.w700,
                      height: 1.2,
                    ),
                  ),
                ),
                const SizedBox(width: 4),
                Transform.rotate(
                  angle: 10 * 3.1415926535 / 180,
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 4,
                      vertical: 1,
                    ),
                    decoration: BoxDecoration(
                      border: Border.all(
                        color: const Color(0xFFEF4444),
                        width: 1.5,
                      ),
                      borderRadius: BorderRadius.circular(3),
                    ),
                    child: const Text(
                      'PAST DUE',
                      style: TextStyle(
                        color: Color(0xFFEF4444),
                        fontSize: 7,
                        fontWeight: FontWeight.w800,
                        letterSpacing: 0.4,
                      ),
                    ),
                  ),
                ),
              ],
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  amount,
                  style: const TextStyle(
                    color: Color(0xFF111827),
                    fontSize: 18,
                    fontWeight: FontWeight.w800,
                    height: 1,
                  ),
                ),
                Text(
                  daysOverdue,
                  style: const TextStyle(color: Color(0xFF9CA3AF), fontSize: 8),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
