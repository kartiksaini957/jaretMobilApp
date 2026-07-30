import 'package:flutter/material.dart';

import '../theme/settings_colors.dart';

class SettingsTab {
  const SettingsTab(this.label);

  final String label;
}

/// Wrapping row of pill buttons — one per settings tab — matching the
/// "General / Integrations / Data & Privacy / ..." selector in the mock.
class SettingsTabBar extends StatelessWidget {
  const SettingsTabBar({
    super.key,
    required this.tabs,
    required this.selectedIndex,
    required this.onChanged,
  });

  final List<SettingsTab> tabs;
  final int selectedIndex;
  final ValueChanged<int> onChanged;

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: [
        for (var i = 0; i < tabs.length; i++)
          _TabPill(
            label: tabs[i].label,
            selected: i == selectedIndex,
            onTap: () => onChanged(i),
          ),
      ],
    );
  }
}

class _TabPill extends StatelessWidget {
  const _TabPill({
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
      borderRadius: BorderRadius.circular(20),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        decoration: BoxDecoration(
          color: selected
              ? SettingsColors.pillFillSelected
              : SettingsColors.pillFill,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: selected
                ? SettingsColors.pillBorderSelected
                : SettingsColors.pillBorder,
            width: selected ? 1.4 : 1,
          ),
        ),
        child: Text(
          label,
          style: TextStyle(
            color: SettingsColors.white,
            fontSize: 12.5,
            fontWeight: selected ? FontWeight.w800 : FontWeight.w600,
          ),
        ),
      ),
    );
  }
}
