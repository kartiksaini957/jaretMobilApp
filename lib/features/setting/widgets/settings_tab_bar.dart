import 'package:flutter/material.dart';

import '../../../theme/app_theme.dart';
import '../../../theme/lightsignal/ls_css.dart';
import '../../../widgets/smooth_animations.dart';
import '../theme/settings_colors.dart';

class SettingsTab {
  const SettingsTab(this.label);
  final String label;
}
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
  static final Gradient _restFill = LsCss.linearGradient(
    degrees: 160,
    colors: const [Color(0x5E37515E), Color(0x4F1F3C4B)],
  );

  static final Gradient _selectedFill = LsCss.linearGradient(
    degrees: 160,
    colors: const [Color(0x822C748A), Color(0x541B5164)],
  );

  @override
  Widget build(BuildContext context) {
    return SmoothScaleTap(
      onTap: onTap,
      scaleFactor: 0.94,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        curve: Curves.easeOutCubic,
        decoration: BoxDecoration(
          gradient: selected ? _selectedFill : _restFill,
          borderRadius: BorderRadius.circular(99),
          border: Border.all(
            color: selected
                ? SettingsColors.pillBorderSelected
                : SettingsColors.pillBorder,
            width: selected ? 1.2 : 1,
          ),
          boxShadow: selected
              ? [
                  BoxShadow(
                    color: SettingsColors.accent.withValues(alpha: 0.25),
                    blurRadius: 10,
                    offset: const Offset(0, 2),
                  ),
                ]
              : null,
        ),
        child: SizedBox(
          height: 40,
          child: Center(
            widthFactor: 1,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 18),
              child: Text(
                label,
                style: AppTextStyles.body.copyWith(
                  color: selected
                      ? SettingsColors.white
                      : SettingsColors.soft,
                  fontSize: 13,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
