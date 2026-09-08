import 'package:flutter/material.dart';

import '../theme/app_theme.dart';

/// Glass-shaped skeleton with a moving highlight sweep — the app-wide
/// loading placeholder for any card/row still waiting on data.
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
            border: Border.all(color: AppColors.glassBorderSoft),
            gradient: LinearGradient(
              begin: Alignment(sweep - 0.4, 0),
              end: Alignment(sweep + 0.4, 0),
              colors: const [
                AppColors.glassLight,
                Color(
                  0x66FFFFFF,
                ), // [TEMPORARY CHANGE] Replaced AppColors.glassDark (Color(0x33062230)) with white
                AppColors.glassLight,
              ],
            ),
          ),
        );
      },
    );
  }
}
