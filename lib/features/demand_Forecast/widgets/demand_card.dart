import 'package:flutter/material.dart';

import '../theme/demand_colors.dart';

/// Translucent rounded card shared by every section on the Demand
/// Forecast screens.
class DemandCard extends StatelessWidget {
  const DemandCard({super.key, required this.child, this.padding});

  final Widget child;
  final EdgeInsetsGeometry? padding;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: padding ?? const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: DemandColors.cardFill,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: DemandColors.cardBorder),
      ),
      child: child,
    );
  }
}
