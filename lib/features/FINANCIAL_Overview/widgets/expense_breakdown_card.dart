import 'dart:math';
import 'package:flutter/material.dart';
import '../theme/financial_colors.dart';

class ExpenseSlice {
  const ExpenseSlice({
    required this.label,
    required this.percent,
    required this.amount,
  });

  final String label;
  final double percent;
  final String amount;
}

class ExpenseBreakdownCard extends StatelessWidget {
  const ExpenseBreakdownCard({super.key, required this.slices});

  final List<ExpenseSlice> slices;

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
        children: [
          SizedBox(
            width: 180,
            height: 180,
            child: CustomPaint(painter: _DonutPainter(slices)),
          ),
          const SizedBox(height: 20),
          for (var i = 0; i < slices.length; i++) ...[
            if (i > 0) const SizedBox(height: 10),
            Row(
              children: [
                Container(
                  width: 9,
                  height: 9,
                  decoration: BoxDecoration(
                    color: FinancialColors
                        .donutColors[i % FinancialColors.donutColors.length],
                    shape: BoxShape.circle,
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Text(
                    slices[i].label,
                    style: const TextStyle(
                      color: FinancialColors.white,
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                Text(
                  '${slices[i].percent.toStringAsFixed(0)}%',
                  style: const TextStyle(
                    color: FinancialColors.mutedText,
                    fontSize: 13,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(width: 10),
                Text(
                  slices[i].amount,
                  style: const TextStyle(
                    color: FinancialColors.faintText,
                    fontSize: 12.5,
                  ),
                ),
              ],
            ),
          ],
        ],
      ),
    );
  }
}

class _DonutPainter extends CustomPainter {
  _DonutPainter(this.slices);

  final List<ExpenseSlice> slices;

  @override
  void paint(Canvas canvas, Size size) {
    final total = slices.fold<double>(0, (sum, s) => sum + s.percent);
    if (total <= 0) return;

    final strokeWidth = size.width * 0.22;
    final rect = Rect.fromLTWH(
      strokeWidth / 2,
      strokeWidth / 2,
      size.width - strokeWidth,
      size.height - strokeWidth,
    );

    var startAngle = -pi / 2;
    for (var i = 0; i < slices.length; i++) {
      final sweep = (slices[i].percent / total) * 2 * pi;
      final paint = Paint()
        ..color =
            FinancialColors.donutColors[i % FinancialColors.donutColors.length]
        ..style = PaintingStyle.stroke
        ..strokeWidth = strokeWidth
        ..strokeCap = StrokeCap.butt;
      canvas.drawArc(rect, startAngle, sweep - 0.02, false, paint);
      startAngle += sweep;
    }
  }

  @override
  bool shouldRepaint(covariant _DonutPainter oldDelegate) =>
      oldDelegate.slices != slices;
}
