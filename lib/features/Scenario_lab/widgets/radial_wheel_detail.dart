import 'dart:math';

import 'package:flutter/material.dart';

import '../../opportunity/ScenarioLab/widgets/scenario_lab_colors.dart';

/// Donut wheel divided into 3 tappable segments, with a center label and
/// a "reveal" line below for whichever segment was last tapped.
class RadialWheelDetail extends StatefulWidget {
  const RadialWheelDetail({
    super.key,
    required this.centerLabel,
    required this.segments,
  });

  final String centerLabel;
  final List<String> segments;

  @override
  State<RadialWheelDetail> createState() => _RadialWheelDetailState();
}

class _RadialWheelDetailState extends State<RadialWheelDetail> {
  String? _selected;

  static const _positions = [
    Alignment(0, -0.9), // top
    Alignment(-0.95, 0.75), // bottom-left
    Alignment(0.95, 0.75), // bottom-right
  ];

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Center(
          child: SizedBox(
            width: 260,
            height: 240,
            child: Stack(
              alignment: Alignment.center,
              clipBehavior: Clip.none,
              children: [
                SizedBox(
                  width: 170,
                  height: 170,
                  child: CustomPaint(
                    painter: _WheelPainter(
                      segmentCount: widget.segments.length,
                    ),
                  ),
                ),
                Container(
                  width: 84,
                  height: 84,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: ScenarioLabColors.cardFillStrong,
                    shape: BoxShape.circle,
                    border: Border.all(color: ScenarioLabColors.cardBorder),
                  ),
                  child: Text(
                    widget.centerLabel,
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      color: ScenarioLabColors.white,
                      fontSize: 13,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                ),
                for (var i = 0; i < widget.segments.length; i++)
                  Align(
                    alignment: _positions[i % _positions.length],
                    child: _SegmentLabel(
                      label: widget.segments[i],
                      selected: _selected == widget.segments[i],
                      onTap: () =>
                          setState(() => _selected = widget.segments[i]),
                    ),
                  ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 8),
        Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
          decoration: BoxDecoration(
            color: ScenarioLabColors.cardFill,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: ScenarioLabColors.cardBorder),
          ),
          child: Text(
            _selected == null ? 'Select a segment to reveal it.' : _selected!,
            textAlign: TextAlign.center,
            style: TextStyle(
              color: _selected == null
                  ? ScenarioLabColors.faintText
                  : ScenarioLabColors.white,
              fontSize: 12.5,
              fontWeight: _selected == null ? FontWeight.w500 : FontWeight.w700,
            ),
          ),
        ),
      ],
    );
  }
}

class _SegmentLabel extends StatelessWidget {
  const _SegmentLabel({
    required this.label,
    required this.selected,
    required this.onTap,
  });

  final String label;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(8),
      child: Padding(
        padding: const EdgeInsets.all(4),
        child: Text(
          label,
          textAlign: TextAlign.center,
          style: TextStyle(
            color: selected
                ? ScenarioLabColors.glow
                : ScenarioLabColors.mutedText,
            fontSize: 11.5,
            fontWeight: FontWeight.w700,
          ),
        ),
      ),
    );
  }
}

class _WheelPainter extends CustomPainter {
  _WheelPainter({required this.segmentCount});

  final int segmentCount;

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final outerRadius = size.width / 2;
    const innerRadius = 45.0;
    final sweep = 2 * pi / segmentCount;
    final gap = 0.05;

    for (var i = 0; i < segmentCount; i++) {
      final start = -pi / 2 + i * sweep + gap / 2;
      final path = Path()
        ..moveTo(
          center.dx + innerRadius * cos(start),
          center.dy + innerRadius * sin(start),
        )
        ..lineTo(
          center.dx + outerRadius * cos(start),
          center.dy + outerRadius * sin(start),
        )
        ..arcTo(
          Rect.fromCircle(center: center, radius: outerRadius),
          start,
          sweep - gap,
          false,
        )
        ..lineTo(
          center.dx + innerRadius * cos(start + sweep - gap),
          center.dy + innerRadius * sin(start + sweep - gap),
        )
        ..arcTo(
          Rect.fromCircle(center: center, radius: innerRadius),
          start + sweep - gap,
          -(sweep - gap),
          false,
        )
        ..close();

      canvas.drawPath(
        path,
        Paint()
          ..color = ScenarioLabColors.cardFillStrong
          ..style = PaintingStyle.fill,
      );
      canvas.drawPath(
        path,
        Paint()
          ..color = ScenarioLabColors.cardBorder
          ..style = PaintingStyle.stroke
          ..strokeWidth = 1.5,
      );
    }
  }

  @override
  bool shouldRepaint(covariant _WheelPainter oldDelegate) =>
      oldDelegate.segmentCount != segmentCount;
}
