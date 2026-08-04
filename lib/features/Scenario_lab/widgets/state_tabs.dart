import 'package:flutter/material.dart';
import 'package:flutter_application_1/theme/app_theme.dart';

import '../../opportunity/ScenarioLab/widgets/scenario_lab_colors.dart';
import '../scenario_lab_state.dart';

/// Pill segmented control for switching between Results / Empty /
/// Loading previews.
class StateTabs extends StatelessWidget {
  const StateTabs({super.key, required this.value, required this.onChanged});

  final ScenarioViewState value;
  final ValueChanged<ScenarioViewState> onChanged;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(3),
      decoration: BoxDecoration(
        color: ScenarioLabColors.cardFill,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: ScenarioLabColors.cardBorder),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          for (final state in ScenarioViewState.values)
            _TabButton(
              label: state.label,
              selected: state == value,
              onTap: () => onChanged(state),
            ),
        ],
      ),
    );
  }
}

class _TabButton extends StatelessWidget {
  const _TabButton({
    required this.label,
    required this.selected,
    required this.onTap,
  });

  final String label;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      borderRadius: BorderRadius.circular(17),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(17),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          decoration: BoxDecoration(
            color: selected ? ScenarioLabColors.white : Colors.transparent,
            borderRadius: BorderRadius.circular(17),
          ),
          child: Text(
            label,
            style: AppTextStyles.body.copyWith(
              color: selected
                  ? const Color(0xFF0A2A57)
                  : ScenarioLabColors.mutedText,
              fontSize: 12,
              fontWeight: FontWeight.w700,
            ),
          ),
        ),
      ),
    );
  }
}
