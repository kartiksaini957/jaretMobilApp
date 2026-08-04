import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

class MiniBarChart extends StatefulWidget {
  const MiniBarChart({super.key});

  @override
  State<MiniBarChart> createState() => _MiniBarChartState();
}

class _MiniBarChartState extends State<MiniBarChart> {
  bool animate = false;
  @override
  void initState() {
    super.initState();

    Future.delayed(const Duration(milliseconds: 100), () {
      if (mounted) {
        setState(() {
          animate = true;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 80,
      height: 55,
      child: BarChart(
        BarChartData(
          alignment: BarChartAlignment.spaceBetween,
          maxY: 50,

          // Remove everything
          borderData: FlBorderData(show: false),
          gridData: const FlGridData(show: false),
          titlesData: const FlTitlesData(show: false),
          barTouchData: BarTouchData(enabled: false),

          barGroups: [
            _bar(0, animate ? 10 : 0, const Color(0x40FFFFFF)),
            _bar(1, animate ? 18 : 0, const Color(0x40FFFFFF)),
            _bar(2, animate ? 28 : 0, const Color(0x40FFFFFF)),
            _bar(3, animate ? 36 : 0, const Color(0x40FFFFFF)),
            _bar(4, animate ? 46 : 0, const Color(0xFFFFD466)),
          ],
        ),
        swapAnimationDuration: const Duration(milliseconds: 1000),
        swapAnimationCurve: Curves.easeOutCubic,
      ),
    );
  }

  BarChartGroupData _bar(int x, double value, Color color) {
    return BarChartGroupData(
      x: x,
      barsSpace: 0,
      barRods: [
        BarChartRodData(
          toY: value,
          width: 12,
          borderRadius: BorderRadius.circular(3),
          color: color,
        ),
      ],
    );
  }
}
