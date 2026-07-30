import 'package:flutter/material.dart';

import '../theme/demand_colors.dart';

/// Hamburger button + the three underline tabs (Demand Forecasting /
/// Tracking / Current) shared by every Demand Forecast screen.
class DemandTabBar extends StatelessWidget {
  const DemandTabBar({
    super.key,
    required this.tabs,
    required this.selectedIndex,
    required this.onTap,
    this.onMenuTap,
  });

  final List<String> tabs;
  final int selectedIndex;
  final ValueChanged<int> onTap;
  final VoidCallback? onMenuTap;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        IconButton(
          onPressed: onMenuTap,
          icon: const Icon(Icons.menu, color: DemandColors.white),
        ),
        Row(
          children: [
            for (var i = 0; i < tabs.length; i++)
              Padding(
                padding: const EdgeInsets.only(right: 22),
                child: _TabLabel(
                  label: tabs[i],
                  selected: i == selectedIndex,
                  onTap: () => onTap(i),
                ),
              ),
          ],
        ),
        const SizedBox(height: 8),
        Container(height: 1, color: DemandColors.cardBorder),
      ],
    );
  }
}

class _TabLabel extends StatelessWidget {
  const _TabLabel({
    required this.label,
    required this.selected,
    required this.onTap,
  });

  final String label;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.only(bottom: 10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              label,
              style: TextStyle(
                color: selected ? DemandColors.white : DemandColors.faintText,
                fontSize: 13.5,
                fontWeight: selected ? FontWeight.w700 : FontWeight.w500,
              ),
            ),
            const SizedBox(height: 6),
            AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              height: 2,
              width: selected ? _textWidth(label) : 0,
              color: DemandColors.white,
            ),
          ],
        ),
      ),
    );
  }

  double _textWidth(String label) => label.length * 7.2;
}
