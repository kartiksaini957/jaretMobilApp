import 'package:flutter/material.dart';

import '../theme/demand_colors.dart';
import 'demand_card.dart';
import 'demand_footer.dart';

/// Stub content shared by the "Tracking" and "Current" tabs, which don't
/// have a full design yet.
class PlaceholderTab extends StatelessWidget {
  const PlaceholderTab({super.key, required this.message});

  final String message;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        DemandCard(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                message,
                style: const TextStyle(
                  color: DemandColors.mutedText,
                  fontSize: 13,
                ),
              ),
              const SizedBox(height: 16),
              const DemandFooter(),
            ],
          ),
        ),
      ],
    );
  }
}
