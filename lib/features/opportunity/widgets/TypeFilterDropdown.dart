// opportunity_filters.dart

import 'package:flutter/material.dart';
import 'package:flutter_application_1/features/opportunity/opportunities_provider.dart';
import 'package:flutter_application_1/features/opportunity/widgets/FilterDropdownChip.dart';
import 'package:flutter_application_1/theme/app_theme.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';

// ---------------------------------------------------------------------
// TYPE
// ---------------------------------------------------------------------
class TypeFilterDropdown extends ConsumerWidget {
  const TypeFilterDropdown({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final data = ref.watch(opportunitiesControllerProvider).value;
    if (data == null) return const SizedBox.shrink();

    final selected = data.selectedTypes;

    return FilterDropdownChip(
      label: 'Type',
      badgeCount: selected.length,
      panelBuilder: (ctx, close) => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            'FILTER BY TYPE',
            style: AppTextStyles.eyebrow.copyWith(
              color: Colors.white70,
              fontSize: 10.5,
            ),
          ),
          const SizedBox(height: 8),
          ...data.availableTypes.map((type) {
            final checked = selected.contains(type);
            return CheckboxListTile(
              value: checked,
              onChanged: (_) => ref
                  .read(opportunitiesControllerProvider.notifier)
                  .toggleType(type),
              title: Text(
                type,
                style: GoogleFonts.dmSans(fontSize: 13, color: Colors.white),
              ),
              controlAffinity: ListTileControlAffinity.leading,
              activeColor: AppColors.accent,
              checkColor: Colors.black,
              contentPadding: EdgeInsets.zero,
              dense: true,
            );
          }),
        ],
      ),
    );
  }
}

// ---------------------------------------------------------------------
// DISTANCE
// ---------------------------------------------------------------------
class DistanceFilterDropdown extends ConsumerWidget {
  const DistanceFilterDropdown({super.key});

  static const List<int> _options = [15, 30, 45, 60];

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final data = ref.watch(opportunitiesControllerProvider).value;
    if (data == null) return const SizedBox.shrink();

    final current = data.maxDriveTimeMinutes; // null = "Any distance"

    return FilterDropdownChip(
      label: 'Distance',
      badgeCount: current != null ? 1 : 0,
      panelBuilder: (ctx, close) => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            'WITHIN DRIVE TIME',
            style: AppTextStyles.eyebrow.copyWith(
              color: Colors.white70,
              fontSize: 10.5,
            ),
          ),
          const SizedBox(height: 8),
          ..._options.map(
            (mins) => RadioListTile<int?>(
              value: mins,
              groupValue: current,
              onChanged: (v) {
                ref
                    .read(opportunitiesControllerProvider.notifier)
                    .setMaxDriveTime(v);
                close(); // auto-close on selection, like your screenshot
              },
              title: Text(
                '≤ $mins min',
                style: GoogleFonts.dmSans(fontSize: 13, color: Colors.white),
              ),
              activeColor: AppColors.accent,
              contentPadding: EdgeInsets.zero,
              dense: true,
            ),
          ),
          RadioListTile<int?>(
            value: null,
            groupValue: current,
            onChanged: (v) {
              ref
                  .read(opportunitiesControllerProvider.notifier)
                  .setMaxDriveTime(null);
              close();
            },
            title: Text(
              'Any distance',
              style: GoogleFonts.dmSans(fontSize: 13, color: Colors.white),
            ),
            activeColor: AppColors.accent,
            contentPadding: EdgeInsets.zero,
            dense: true,
          ),
        ],
      ),
    );
  }
}

// ---------------------------------------------------------------------
// RISK
// ---------------------------------------------------------------------
class RiskFilterDropdown extends ConsumerWidget {
  const RiskFilterDropdown({super.key});

  // CHANGED — Risk is a fixed set of categories (Low/Medium/High), just
  // like Distance's 15/30/45/60. It should NOT depend on which cards
  // happen to be loaded right now — the user must always be able to
  // pick any of the 3, even if none of the current cards match it yet
  // (e.g. filtering by "High" should correctly show "no matches" rather
  // than the option never appearing at all).
  static const List<String> _levels = ['Low', 'Medium', 'High'];

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final data = ref.watch(opportunitiesControllerProvider).value;
    if (data == null) return const SizedBox.shrink();

    final selected = data.selectedRiskLevels;

    return FilterDropdownChip(
      label: 'Risk',
      badgeCount: selected.length,
      panelBuilder: (ctx, close) => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            'FILTER BY RISK',
            style: AppTextStyles.eyebrow.copyWith(
              color: Colors.white70,
              fontSize: 10.5,
            ),
          ),
          const SizedBox(height: 8),
          ..._levels.map((level) {
            final checked = selected.contains(level);
            return CheckboxListTile(
              value: checked,
              onChanged: (_) => ref
                  .read(opportunitiesControllerProvider.notifier)
                  .toggleRiskLevel(level),
              title: Text(
                level,
                style: GoogleFonts.dmSans(fontSize: 13, color: Colors.white),
              ),
              controlAffinity: ListTileControlAffinity.leading,
              activeColor: AppColors.accent,
              checkColor: Colors.black,
              contentPadding: EdgeInsets.zero,
              dense: true,
            );
          }),
        ],
      ),
    );
  }
}
