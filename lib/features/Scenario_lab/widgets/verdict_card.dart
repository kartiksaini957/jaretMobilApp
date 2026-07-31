import 'package:flutter/material.dart';

import '../theme/scenario_lab_colors.dart';

class VerdictPill {
  const VerdictPill({
    required this.label,
    required this.color,
    this.hasInfo = false,
  });

  final String label;
  final Color color;
  final bool hasInfo;
}

/// Glowing headline verdict card: decision pills, summary, and a
/// worst-case warning box.
class VerdictCard extends StatelessWidget {
  const VerdictCard({
    super.key,
    required this.headline,
    required this.pills,
    required this.body,
    required this.warning,
    this.warningLabel,
  });

  final String headline;
  final List<VerdictPill> pills;
  final String body;
  final String warning;

  /// Bold lead-in before [warning], e.g. "Timing note:".
  final String? warningLabel;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: ScenarioLabColors.cardFillStrong,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: ScenarioLabColors.glow, width: 1.4),
        boxShadow: [
          BoxShadow(
            color: ScenarioLabColors.glow.withValues(alpha: 0.35),
            blurRadius: 30,
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            headline,
            style: const TextStyle(
              color: ScenarioLabColors.white,
              fontSize: 24,
              fontWeight: FontWeight.w800,
            ),
          ),
          const SizedBox(height: 14),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [for (final pill in pills) _Pill(pill: pill)],
          ),
          const SizedBox(height: 16),
          Text(
            body,
            style: const TextStyle(
              color: ScenarioLabColors.mutedText,
              fontSize: 13.5,
              height: 1.5,
            ),
          ),
          const SizedBox(height: 16),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: ScenarioLabColors.statusWarn.withValues(alpha: 0.12),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: ScenarioLabColors.statusWarn.withValues(alpha: 0.5),
              ),
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Icon(
                  Icons.warning_amber_rounded,
                  size: 16,
                  color: ScenarioLabColors.statusWarn,
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: RichText(
                    text: TextSpan(
                      style: const TextStyle(
                        color: ScenarioLabColors.white,
                        fontSize: 12.5,
                        height: 1.4,
                      ),
                      children: [
                        if (warningLabel != null)
                          TextSpan(
                            text: '$warningLabel ',
                            style: const TextStyle(fontWeight: FontWeight.w800),
                          ),
                        TextSpan(text: warning),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _Pill extends StatelessWidget {
  const _Pill({required this.pill});

  final VerdictPill pill;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        color: pill.color.withValues(alpha: 0.18),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 6,
            height: 6,
            decoration: BoxDecoration(
              color: pill.color,
              shape: BoxShape.circle,
            ),
          ),
          const SizedBox(width: 6),
          Text(
            pill.label,
            style: TextStyle(
              color: pill.color,
              fontSize: 11.5,
              fontWeight: FontWeight.w700,
            ),
          ),
          if (pill.hasInfo) ...[
            const SizedBox(width: 4),
            Icon(Icons.info_outline, size: 12, color: pill.color),
          ],
        ],
      ),
    );
  }
}
