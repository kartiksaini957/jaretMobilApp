import 'package:flutter/material.dart';

import '../theme/scenario_lab_colors.dart';

/// "Cash position over time" card: projected / worst-case / reserve
/// floor lines plus a break-even marker.
class CashChartCard extends StatelessWidget {
  const CashChartCard({super.key});

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
            child: CustomPaint(painter: _CashChartPainter()),
          ),
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
  static const _projected = [38.0, 8.0, 20.0, 35.0, 45.0, 55.0];
  static const _worstCase = [30.0, 2.0, 10.0, 22.0, 30.0, 40.0];
  static const _reserveFloor = 18.0;
  static const _maxValue = 55.0;
  static const _breakEvenIndex = 4;

  @override
  void paint(Canvas canvas, Size size) {
    const leftPad = 34.0;
    const bottomPad = 18.0;
    final chartWidth = size.width - leftPad;
    final chartHeight = size.height - bottomPad;

    Offset pointFor(int index, double value) {
      final x = leftPad + chartWidth * (index / (_projected.length - 1));
      final y = chartHeight * (1 - (value / _maxValue));
      return Offset(x, y);
    }

    // Y-axis labels.
    const labels = ['\$0', '\$20K', '\$38K', '\$55K'];
    const labelValues = [0.0, 20.0, 38.0, 55.0];
    for (var i = 0; i < labels.length; i++) {
      final y = chartHeight * (1 - (labelValues[i] / _maxValue));
      final painter = TextPainter(
        text: TextSpan(
          text: labels[i],
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
    for (var i = 0; i < _projected.length; i++) {
      final x = pointFor(i, 0).dx;
      final painter = TextPainter(
        text: TextSpan(
          text: 'Mo${i + 1}',
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
    final reserveY = chartHeight * (1 - (_reserveFloor / _maxValue));
    _drawDashedLine(
      canvas,
      Offset(leftPad, reserveY),
      Offset(size.width, reserveY),
      ScenarioLabColors.statusWarn,
    );
    final reserveLabel = TextPainter(
      text: const TextSpan(
        text: 'Reserve \$18K',
        style: TextStyle(color: ScenarioLabColors.faintText, fontSize: 9),
      ),
      textDirection: TextDirection.ltr,
    )..layout();
    reserveLabel.paint(
      canvas,
      Offset(size.width - reserveLabel.width, reserveY - 12),
    );

    // Worst case dashed line.
    final worstPath = Path();
    for (var i = 0; i < _worstCase.length; i++) {
      final point = pointFor(i, _worstCase[i]);
      if (i == 0) {
        worstPath.moveTo(point.dx, point.dy);
      } else {
        worstPath.lineTo(point.dx, point.dy);
      }
    }
    _drawDashedPath(canvas, worstPath, ScenarioLabColors.statusBad);

    // Projected solid line.
    final projectedPath = Path();
    for (var i = 0; i < _projected.length; i++) {
      final point = pointFor(i, _projected[i]);
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

    // Break-even marker.
    final breakEvenPoint = pointFor(
      _breakEvenIndex,
      _projected[_breakEvenIndex],
    );
    canvas.drawCircle(
      breakEvenPoint,
      4,
      Paint()..color = ScenarioLabColors.statusGood,
    );
    final breakEvenLabel = TextPainter(
      text: const TextSpan(
        text: 'Break-even',
        style: TextStyle(
          color: ScenarioLabColors.statusGood,
          fontSize: 9,
          fontWeight: FontWeight.w700,
        ),
      ),
      textDirection: TextDirection.ltr,
    )..layout();
    breakEvenLabel.paint(
      canvas,
      Offset(
        breakEvenPoint.dx - breakEvenLabel.width / 2,
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
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
