import 'package:flutter/material.dart';

import '../theme/scenario_lab_colors.dart';

/// "Cash position over time" card: projected / worst-case / reserve
/// floor lines, a low-point marker, a break-even marker, and an
/// optional "Stress test:" note.
class CashChartCard extends StatelessWidget {
  const CashChartCard({
    super.key,
    required this.xLabels,
    required this.projected,
    required this.worstCase,
    required this.reserveFloor,
    required this.maxValue,
    required this.breakEvenIndex,
    required this.breakEvenLabel,
    required this.lowPointIndex,
    required this.lowPointLabel,
    required this.reserveFloorLabel,
    required this.yAxisLabels,
    required this.yAxisValues,
    this.stressTestBody,
  });

  final List<String> xLabels;
  final List<double> projected;
  final List<double> worstCase;
  final double reserveFloor;
  final double maxValue;
  final int breakEvenIndex;
  final String breakEvenLabel;
  final List<String> yAxisLabels;
  final List<double> yAxisValues;
  final int lowPointIndex;
  final String lowPointLabel;
  final String reserveFloorLabel;
  final String? stressTestBody;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: ScenarioLabColors.cardFill,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: ScenarioLabColors.cardBorder),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Cash position over time',
            style: TextStyle(
              color: ScenarioLabColors.white,
              fontSize: 14,
              fontWeight: FontWeight.w800,
            ),
          ),
          const SizedBox(height: 10),
          const Wrap(
            spacing: 14,
            runSpacing: 6,
            children: [
              _LegendItem(color: ScenarioLabColors.glow, label: 'Projected'),
              _LegendItem(
                color: ScenarioLabColors.statusBad,
                label: 'Worst case',
                dashed: true,
              ),
              _LegendItem(
                color: ScenarioLabColors.statusWarn,
                label: 'Reserve floor',
                dashed: true,
              ),
              _LegendItem(
                color: ScenarioLabColors.statusGood,
                label: 'Break-even',
                isDot: true,
              ),
            ],
          ),
          const SizedBox(height: 14),
          SizedBox(
            height: 170,
            child: CustomPaint(
              painter: _CashChartPainter(
                xLabels: xLabels,
                projected: projected,
                worstCase: worstCase,
                reserveFloor: reserveFloor,
                maxValue: maxValue,
                breakEvenIndex: breakEvenIndex,
                breakEvenLabel: breakEvenLabel,
                lowPointIndex: lowPointIndex,
                lowPointLabel: lowPointLabel,
                reserveFloorLabel: reserveFloorLabel,
                yAxisLabels: yAxisLabels,
                yAxisValues: yAxisValues,
              ),
            ),
          ),
          if (stressTestBody != null) ...[
            const SizedBox(height: 14),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: ScenarioLabColors.cardFillStrong,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: ScenarioLabColors.cardBorder),
              ),
              child: RichText(
                text: TextSpan(
                  style: const TextStyle(
                    color: ScenarioLabColors.mutedText,
                    fontSize: 12,
                    height: 1.5,
                  ),
                  children: [
                    const TextSpan(
                      text: 'Stress test: ',
                      style: TextStyle(
                        color: ScenarioLabColors.white,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    TextSpan(text: stressTestBody),
                  ],
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }
}

class _LegendItem extends StatelessWidget {
  const _LegendItem({
    required this.color,
    required this.label,
    this.dashed = false,
    this.isDot = false,
  });

  final Color color;
  final String label;
  final bool dashed;
  final bool isDot;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        if (isDot)
          Container(
            width: 7,
            height: 7,
            decoration: BoxDecoration(color: color, shape: BoxShape.circle),
          )
        else
          SizedBox(
            width: 14,
            height: 2,
            child: dashed
                ? Row(
                    children: List.generate(
                      3,
                      (_) => Expanded(
                        child: Container(
                          margin: const EdgeInsets.symmetric(horizontal: 0.5),
                          color: color,
                        ),
                      ),
                    ),
                  )
                : Container(color: color),
          ),
        const SizedBox(width: 5),
        Text(
          label,
          style: const TextStyle(
            color: ScenarioLabColors.faintText,
            fontSize: 10.5,
          ),
        ),
      ],
    );
  }
}

class _CashChartPainter extends CustomPainter {
  _CashChartPainter({
    required this.xLabels,
    required this.projected,
    required this.worstCase,
    required this.reserveFloor,
    required this.maxValue,
    required this.breakEvenIndex,
    required this.breakEvenLabel,
    required this.lowPointIndex,
    required this.lowPointLabel,
    required this.reserveFloorLabel,
    required this.yAxisLabels,
    required this.yAxisValues,
  });

  final List<String> xLabels;
  final List<double> projected;
  final List<double> worstCase;
  final double reserveFloor;
  final double maxValue;
  final int breakEvenIndex;
  final String breakEvenLabel;
  final int lowPointIndex;
  final String lowPointLabel;
  final String reserveFloorLabel;
  final List<String> yAxisLabels;
  final List<double> yAxisValues;

  @override
  void paint(Canvas canvas, Size size) {
    const leftPad = 34.0;
    const bottomPad = 18.0;
    final chartWidth = size.width - leftPad;
    final chartHeight = size.height - bottomPad;

    Offset pointFor(int index, double value) {
      final x = leftPad + chartWidth * (index / (projected.length - 1));
      final y = chartHeight * (1 - (value / maxValue));
      return Offset(x, y);
    }

    // Y-axis labels.
    for (var i = 0; i < yAxisLabels.length; i++) {
      final y = chartHeight * (1 - (yAxisValues[i] / maxValue));
      final painter = TextPainter(
        text: TextSpan(
          text: yAxisLabels[i],
          style: const TextStyle(
            color: ScenarioLabColors.faintText,
            fontSize: 9,
          ),
        ),
        textDirection: TextDirection.ltr,
      )..layout();
      painter.paint(canvas, Offset(0, y - painter.height / 2));
    }

    // X-axis labels.
    for (var i = 0; i < xLabels.length; i++) {
      final x = pointFor(i, 0).dx;
      final painter = TextPainter(
        text: TextSpan(
          text: xLabels[i],
          style: const TextStyle(
            color: ScenarioLabColors.faintText,
            fontSize: 9,
          ),
        ),
        textDirection: TextDirection.ltr,
      )..layout();
      painter.paint(canvas, Offset(x - painter.width / 2, chartHeight + 4));
    }

    // Reserve floor dashed horizontal line.
    final reserveY = chartHeight * (1 - (reserveFloor / maxValue));
    _drawDashedLine(
      canvas,
      Offset(leftPad, reserveY),
      Offset(size.width, reserveY),
      ScenarioLabColors.statusWarn,
    );
    final reserveLabel = TextPainter(
      text: TextSpan(
        text: reserveFloorLabel,
        style: const TextStyle(color: ScenarioLabColors.faintText, fontSize: 9),
      ),
      textDirection: TextDirection.ltr,
    )..layout();
    reserveLabel.paint(
      canvas,
      Offset(size.width - reserveLabel.width, reserveY - 12),
    );

    // Worst case dashed line.
    final worstPath = Path();
    for (var i = 0; i < worstCase.length; i++) {
      final point = pointFor(i, worstCase[i]);
      if (i == 0) {
        worstPath.moveTo(point.dx, point.dy);
      } else {
        worstPath.lineTo(point.dx, point.dy);
      }
    }
    _drawDashedPath(canvas, worstPath, ScenarioLabColors.statusBad);

    // Projected solid line.
    final projectedPath = Path();
    for (var i = 0; i < projected.length; i++) {
      final point = pointFor(i, projected[i]);
      if (i == 0) {
        projectedPath.moveTo(point.dx, point.dy);
      } else {
        projectedPath.lineTo(point.dx, point.dy);
      }
    }
    canvas.drawPath(
      projectedPath,
      Paint()
        ..color = ScenarioLabColors.glow
        ..style = PaintingStyle.stroke
        ..strokeWidth = 2.2
        ..strokeCap = StrokeCap.round,
    );

    // Low-point marker.
    final lowPoint = pointFor(lowPointIndex, projected[lowPointIndex]);
    canvas.drawCircle(
      lowPoint,
      4,
      Paint()..color = ScenarioLabColors.statusWarn,
    );
    final lowLabel = TextPainter(
      text: TextSpan(
        text: lowPointLabel,
        style: const TextStyle(
          color: ScenarioLabColors.statusWarn,
          fontSize: 9,
          fontWeight: FontWeight.w700,
        ),
      ),
      textDirection: TextDirection.ltr,
    )..layout();
    lowLabel.paint(
      canvas,
      Offset(lowPoint.dx - lowLabel.width / 2, lowPoint.dy + 8),
    );

    // Break-even marker.
    final breakEvenPoint = pointFor(breakEvenIndex, projected[breakEvenIndex]);
    canvas.drawCircle(
      breakEvenPoint,
      4,
      Paint()..color = ScenarioLabColors.statusGood,
    );
    final breakEvenText = TextPainter(
      text: TextSpan(
        text: breakEvenLabel,
        style: const TextStyle(
          color: ScenarioLabColors.statusGood,
          fontSize: 9,
          fontWeight: FontWeight.w700,
        ),
      ),
      textDirection: TextDirection.ltr,
    )..layout();
    breakEvenText.paint(
      canvas,
      Offset(
        breakEvenPoint.dx - breakEvenText.width / 2,
        breakEvenPoint.dy - 16,
      ),
    );
  }

  void _drawDashedLine(Canvas canvas, Offset start, Offset end, Color color) {
    _drawDashedPath(
      canvas,
      Path()
        ..moveTo(start.dx, start.dy)
        ..lineTo(end.dx, end.dy),
      color,
    );
  }

  void _drawDashedPath(Canvas canvas, Path path, Color color) {
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.6;
    const dashLength = 5.0;
    const gapLength = 4.0;
    for (final metric in path.computeMetrics()) {
      var distance = 0.0;
      while (distance < metric.length) {
        final next = distance + dashLength;
        canvas.drawPath(
          metric.extractPath(distance, next.clamp(0, metric.length)),
          paint,
        );
        distance = next + gapLength;
      }
    }
  }

  @override
  bool shouldRepaint(covariant _CashChartPainter oldDelegate) => true;
}
