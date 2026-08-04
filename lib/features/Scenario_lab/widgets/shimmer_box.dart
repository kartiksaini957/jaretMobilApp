import 'package:flutter/material.dart';

import '../../opportunity/ScenarioLab/widgets/scenario_lab_colors.dart';

/// Glass card-shaped skeleton with a moving highlight sweep — used for
/// the Loading state, which shows shimmer only, no real content.
class ShimmerBox extends StatefulWidget {
  const ShimmerBox({super.key, this.height = 90, this.borderRadius = 16});

  final double height;
  final double borderRadius;

  @override
  State<ShimmerBox> createState() => _ShimmerBoxState();
}

class _ShimmerBoxState extends State<ShimmerBox>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 1400),
  )..repeat();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, _) {
        final sweep = _controller.value * 3 - 1;
        return Container(
          width: double.infinity,
          height: widget.height,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(widget.borderRadius),
            border: Border.all(color: ScenarioLabColors.cardBorder),
            gradient: LinearGradient(
              begin: Alignment(sweep - 0.4, 0),
              end: Alignment(sweep + 0.4, 0),
              colors: const [
                ScenarioLabColors.cardFill,
                ScenarioLabColors.cardFillStrong,
                ScenarioLabColors.cardFill,
              ],
            ),
          ),
        );
      },
    );
  }
}
