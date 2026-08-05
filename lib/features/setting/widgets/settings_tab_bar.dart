import 'package:flutter/material.dart';

import '../../../theme/app_theme.dart';
import '../../../theme/lightsignal/ls_css.dart';
import '../theme/settings_colors.dart';

class SettingsTab {
  const SettingsTab(this.label);

  final String label;
}

/// `.stabs` — the wrapping row of `.stab` pills that selects the visible
/// settings panel.
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

  /// `.stab` — `rgba(8,40,56,.30→.28)` over `rgba(255,255,255,.10→.04)`,
  /// pre-composited into the single gradient Flutter paints.
  static final Gradient _restFill = LsCss.linearGradient(
    degrees: 160,
    colors: const [Color(0x5E37515E), Color(0x4F1F3C4B)],
  );

  /// `.stab.on` — the same dark layer over the accent sheen.
  static final Gradient _selectedFill = LsCss.linearGradient(
    degrees: 160,
    colors: const [Color(0x822C748A), Color(0x541B5164)],
  );

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      borderRadius: BorderRadius.circular(99),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(99),
        splashColor: SettingsColors.white.withValues(alpha: 0.10),
        child: Ink(
          decoration: BoxDecoration(
            gradient: selected ? _selectedFill : _restFill,
            borderRadius: BorderRadius.circular(99),
            border: Border.all(
              color: selected
                  ? SettingsColors.pillBorderSelected
                  : SettingsColors.pillBorder,
            ),
          ),
          // `Center(widthFactor: 1)` rather than `Container(alignment:)` —
          // an aligned Container expands to the full width the Wrap offers,
          // which would put every pill on its own line.
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
      ),
    );
  }
}
