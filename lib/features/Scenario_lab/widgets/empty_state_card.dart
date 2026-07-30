import 'package:flutter/material.dart';

import '../theme/scenario_lab_colors.dart';

/// "Ask your first what-if question" empty state with quick-start
/// suggestion pills.
class EmptyStateCard extends StatelessWidget {
  const EmptyStateCard({super.key, required this.onSuggestionTap});

  final ValueChanged<String> onSuggestionTap;

  static const _suggestions = [
    'What if I hired one more person',
    'What if a competitor opened nearby',
    'What if I raised my prices 10%',
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 32, horizontal: 24),
      decoration: BoxDecoration(
        color: ScenarioLabColors.cardFill,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: ScenarioLabColors.cardBorder),
      ),
      child: Column(
        children: [
          const Icon(
            Icons.auto_awesome,
            size: 22,
            color: ScenarioLabColors.white,
          ),
          const SizedBox(height: 16),
          const Text(
            'Ask your first what-if question',
            textAlign: TextAlign.center,
            style: TextStyle(
              color: ScenarioLabColors.white,
              fontSize: 19,
              fontWeight: FontWeight.w800,
            ),
          ),
          const SizedBox(height: 10),
          const Text(
            'Type any business scenario above — what if I hired someone, '
            'what if a competitor opened nearby, what if I raised my prices.',
            textAlign: TextAlign.center,
            style: TextStyle(
              color: ScenarioLabColors.mutedText,
              fontSize: 13,
              height: 1.4,
            ),
          ),
          const SizedBox(height: 22),
          for (final suggestion in _suggestions) ...[
            _SuggestionPill(
              label: suggestion,
              onTap: () => onSuggestionTap(suggestion),
            ),
            const SizedBox(height: 10),
          ],
        ],
      ),
    );
  }
}

class _SuggestionPill extends StatelessWidget {
  const _SuggestionPill({required this.label, required this.onTap});

  final String label;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: ScenarioLabColors.cardFillStrong,
      borderRadius: BorderRadius.circular(24),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(24),
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(vertical: 12),
          alignment: Alignment.center,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(24),
            border: Border.all(color: ScenarioLabColors.cardBorder),
          ),
          child: Text(
            label,
            style: const TextStyle(
              color: ScenarioLabColors.white,
              fontSize: 13,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ),
    );
  }
}
