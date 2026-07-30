import 'package:flutter/material.dart';

import '../theme/app_theme.dart';

/// Shared aurora-glass backdrop used by every screen: a diagonal base
/// gradient with five soft cyan/blue glow blobs layered on top, so all
/// screens read as one consistent system.
class GradientBackground extends StatelessWidget {
  const GradientBackground({super.key, required this.child});

  final Widget child;

  static const _blobs = [
    _Blob(alignment: Alignment(-0.64, -0.76), color: AppColors.blobCyan, sizeFactor: 0.95),
    _Blob(alignment: Alignment(0.84, -0.4), color: AppColors.blobBlueA, sizeFactor: 0.8),
    _Blob(alignment: Alignment(0.5, 0.76), color: AppColors.blobBlueB, sizeFactor: 0.9),
    _Blob(alignment: Alignment(-0.3, 0.4), color: AppColors.blobBlueC, sizeFactor: 0.75),
    _Blob(alignment: Alignment(0.2, -0.2), color: AppColors.blobAqua, sizeFactor: 0.65),
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [AppColors.baseDeep, AppColors.baseMid, AppColors.baseLight],
          stops: [0.0, 0.52, 1.0],
        ),
      ),
      child: Stack(
        fit: StackFit.expand,
        children: [..._blobs, child],
      ),
    );
  }
}

class _Blob extends StatelessWidget {
  const _Blob({
    required this.alignment,
    required this.color,
    required this.sizeFactor,
  });

  final Alignment alignment;
  final Color color;
  final double sizeFactor;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final size = constraints.maxWidth * sizeFactor * 1.6;
        return Align(
          alignment: alignment,
          child: Container(
            width: size,
            height: size,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: RadialGradient(
                colors: [
                  color.withValues(alpha: 0.85),
                  color.withValues(alpha: 0.0),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
