import 'package:flutter/material.dart';

import '../theme/business_health_colors.dart';

/// "Snapshot · Feb 11" pill with a dropdown chevron, top-left of the
/// Business Health screen.
class SnapshotDropdownPill extends StatelessWidget {
  const SnapshotDropdownPill({super.key, required this.label, this.onTap});

  final String label;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: BusinessHealthColors.cardFill,
      borderRadius: BorderRadius.circular(20),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(20),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 9),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: BusinessHealthColors.cardBorder),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                label,
                style: const TextStyle(
                  color: BusinessHealthColors.white,
                  fontSize: 12.5,
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(width: 6),
              const Icon(
                Icons.keyboard_arrow_down,
                size: 16,
                color: BusinessHealthColors.white,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
