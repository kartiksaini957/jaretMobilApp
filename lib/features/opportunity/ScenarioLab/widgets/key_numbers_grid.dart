import 'package:flutter/material.dart';
import 'package:flutter_application_1/theme/app_theme.dart';

import 'scenario_lab_colors.dart';

class KeyNumberData {
  const KeyNumberData({
    required this.label,
    required this.value,
    required this.note,
    this.dotColor,
    this.showGlow = true,
  });

  final String label;
  final String value;
  final String note;
  final Color? dotColor;
  final bool showGlow;
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
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFF4D93A9), width: 1),
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Color.fromARGB(255, 37, 134, 161),
            Color.fromARGB(255, 31, 105, 129),
          ],
        ),
        boxShadow: [
          // Existing shadow
          const BoxShadow(
            color: Colors.black26,
            blurRadius: 18,
            offset: Offset(0, 10),
          ),

          const BoxShadow(
            color: Color(0x3324D8FF),
            blurRadius: 12,
            spreadRadius: -2,
          ),

          // Yellow glow (only first 2 cards)
          if (data.showGlow)
            BoxShadow(
              color: Color(0xFFFFD466), // rgb(255, 212, 102)
              blurRadius: 14,
              spreadRadius: -2,
              offset: Offset(0, 0),
            ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  data.label,
                  style: AppTextStyles.body.copyWith(
                    color: ScenarioLabColors.faintText,
                    fontSize: 11.5,
                    fontWeight: FontWeight.w600,
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
            style: AppTextStyles.headline.copyWith(
              color: ScenarioLabColors.white,
              fontSize: 21,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 3),
          Text(
            data.note,
            style: AppTextStyles.body.copyWith(
              color: ScenarioLabColors.faintText,
              fontSize: 10,
            ),
          ),
        ],
      ),
    );
  }
}
