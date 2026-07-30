import 'package:flutter/material.dart';

import '../theme/scenario_lab_colors.dart';

class KeyNumberData {
  const KeyNumberData({
    required this.label,
    required this.value,
    required this.note,
    this.dotColor,
  });

  final String label;
  final String value;
  final String note;
  final Color? dotColor;
}

/// "Key numbers" 2-column grid of stat tiles, each with an optional
/// colored status dot in the top-right corner.
class KeyNumbersGrid extends StatelessWidget {
  const KeyNumbersGrid({super.key, required this.numbers});

  final List<KeyNumberData> numbers;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Key numbers',
          style: TextStyle(
            color: ScenarioLabColors.white,
            fontSize: 15,
            fontWeight: FontWeight.w800,
          ),
        ),
        const SizedBox(height: 12),
        LayoutBuilder(
          builder: (context, constraints) {
            const spacing = 12.0;
            final itemWidth = (constraints.maxWidth - spacing) / 2;
            return Wrap(
              spacing: spacing,
              runSpacing: spacing,
              children: [
                for (final number in numbers)
                  SizedBox(
                    width: itemWidth,
                    child: _NumberTile(data: number),
                  ),
              ],
            );
          },
        ),
      ],
    );
  }
}

class _NumberTile extends StatelessWidget {
  const _NumberTile({required this.data});

  final KeyNumberData data;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: ScenarioLabColors.cardFill,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: ScenarioLabColors.cardBorder),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  data.label,
                  style: const TextStyle(
                    color: ScenarioLabColors.faintText,
                    fontSize: 10.5,
                    fontWeight: FontWeight.w700,
                    letterSpacing: 0.4,
                  ),
                ),
              ),
              if (data.dotColor != null)
                Container(
                  width: 8,
                  height: 8,
                  decoration: BoxDecoration(
                    color: data.dotColor,
                    shape: BoxShape.circle,
                  ),
                ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            data.value,
            style: const TextStyle(
              color: ScenarioLabColors.white,
              fontSize: 20,
              fontWeight: FontWeight.w800,
            ),
          ),
          const SizedBox(height: 3),
          Text(
            data.note,
            style: const TextStyle(
              color: ScenarioLabColors.faintText,
              fontSize: 11,
            ),
          ),
        ],
      ),
    );
  }
}
