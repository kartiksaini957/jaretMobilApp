import 'package:flutter/material.dart';

import '../../../../theme/app_theme.dart';

/// Custom labeled step slider: a track with N evenly spaced stops, the
/// selected one filled with a ring. Tap a dot or its label to select it.
class StepSliderInput extends StatelessWidget {
  const StepSliderInput({
    super.key,
    required this.labels,
    required this.selectedIndex,
    required this.onSelect,
  });

  final List<String> labels;
  final int? selectedIndex;
  final ValueChanged<int> onSelect;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final width = constraints.maxWidth;
        final stopCount = labels.length;
        final positions = List.generate(
          stopCount,
          (i) => stopCount == 1 ? width / 2 : width * i / (stopCount - 1),
        );

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              height: 24,
              width: width,
              child: Stack(
                alignment: Alignment.centerLeft,
                children: [
                  Positioned(
                    left: positions.first,
                    right: width - positions.last,
                    child: Container(height: 2, color: AppColors.glassBorder),
                  ),
                  for (var i = 0; i < stopCount; i++)
                    Positioned(
                      left: positions[i] - 12,
                      child: GestureDetector(
                        onTap: () => onSelect(i),
                        child: _Dot(selected: selectedIndex == i),
                      ),
                    ),
                ],
              ),
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                for (var i = 0; i < stopCount; i++)
                  Expanded(
                    child: GestureDetector(
                      onTap: () => onSelect(i),
                      child: Text(
                        labels[i],
                        textAlign: i == 0
                            ? TextAlign.left
                            : i == stopCount - 1
                            ? TextAlign.right
                            : TextAlign.center,
                        style: TextStyle(
                          color: selectedIndex == i
                              ? AppColors.white
                              : AppColors.faintText,
                          fontSize: 11.5,
                          fontWeight: selectedIndex == i
                              ? FontWeight.w700
                              : FontWeight.w500,
                        ),
                      ),
                    ),
                  ),
              ],
            ),
          ],
        );
      },
    );
  }
}

class _Dot extends StatelessWidget {
  const _Dot({required this.selected});

  final bool selected;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 24,
      height: 24,
      alignment: Alignment.center,
      child: Container(
        width: selected ? 16 : 10,
        height: selected ? 16 : 10,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: selected ? AppColors.accent : AppColors.glassDark,
          border: Border.all(
            color: selected ? AppColors.white : AppColors.glassBorder,
            width: selected ? 2 : 1.4,
          ),
        ),
      ),
    );
  }
}
