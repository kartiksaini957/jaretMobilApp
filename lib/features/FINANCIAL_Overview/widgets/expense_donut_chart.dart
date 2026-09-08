import 'dart:math' as math;
import 'package:flutter/material.dart';
import '../data/expense_breakdown_data.dart';

class ExpenseDonutChart extends StatelessWidget {
  const ExpenseDonutChart({
    super.key,
    required this.categories,
    required this.selectedIndex,
    required this.onSelect,
    required this.centerLabel,
  });

  final List<ExpenseCategory> categories;
  final int? selectedIndex;
  final ValueChanged<int> onSelect;
  final Widget centerLabel;

  void _handleTap(Offset localPosition, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final vector = localPosition - center;
    final radius = math.min(size.width, size.height) / 2;
    final distance = vector.distance;
    if (distance < radius * 0.55 || distance > radius) return;

    var angle = math.atan2(vector.dy, vector.dx) - (-math.pi / 2);
    if (angle < 0) angle += 2 * math.pi;

    var sweepStart = 0.0;
    for (var i = 0; i < categories.length; i++) {
      final sweep = categories[i].percent / 100 * 2 * math.pi;
      if (angle >= sweepStart && angle < sweepStart + sweep) {
        onSelect(i);
        return;
      }
      sweepStart += sweep;
    }
  }

  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: 1,
      child: LayoutBuilder(
        builder: (context, constraints) {
          final size = Size(constraints.maxWidth, constraints.maxHeight);
          return GestureDetector(
            onTapUp: (details) => _handleTap(details.localPosition, size),
            child: Stack(
              alignment: Alignment.center,
              children: [
                CustomPaint(
                  size: size,
                  painter: _DonutPainter(
                    categories: categories,
                    selectedIndex: selectedIndex,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(32),
                  child: centerLabel,
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}

class _DonutPainter extends CustomPainter {
  _DonutPainter({required this.categories, required this.selectedIndex});

  final List<ExpenseCategory> categories;
  final int? selectedIndex;

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = math.min(size.width, size.height) / 2;
    const strokeWidth = 26.0;
    const gapRadians = 0.03;

    var startAngle = -math.pi / 2;
    for (var i = 0; i < categories.length; i++) {
      final category = categories[i];
      final sweep = category.percent / 100 * 2 * math.pi;
      final isSelected = selectedIndex == i;
      final paint = Paint()
        ..style = PaintingStyle.stroke
        ..strokeWidth = isSelected ? strokeWidth + 6 : strokeWidth
        ..strokeCap = StrokeCap.butt
        ..color = isSelected ? category.color : category.color.withValues(alpha: 0.85);

      canvas.drawArc(
        Rect.fromCircle(center: center, radius: radius - strokeWidth / 2),
        startAngle + gapRadians / 2,
        sweep - gapRadians,
        false,
        paint,
      );
      startAngle += sweep;
    }
  }

  @override
  bool shouldRepaint(covariant _DonutPainter oldDelegate) =>
      oldDelegate.categories != categories ||
      oldDelegate.selectedIndex != selectedIndex;
}
