import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../widgets/customToast.dart';
import '../provider/ai_corrections_provider.dart';
import '../theme/settings_colors.dart';
import '../widgets/settings_row_controls.dart';
import '../widgets/settings_section_card.dart';

class AiCorrectionsTab extends ConsumerWidget {
  const AiCorrectionsTab({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final ai = ref.watch(aiCorrectionsProvider);
    final controller = ref.read(aiCorrectionsProvider.notifier);

    return SettingsSectionCard(
      title: 'AI & Corrections',
      subtitle:
          'Everything you\'ve told LightSignal it got wrong — and what it\'s '
          'learned. Your corrections always win.',
      children: [
        const SettingsGroupLabel('Your corrections', topPadding: 0),
        for (final correction in ai.corrections)
          SettingsListRow(
            richText: TextSpan(
              children: [
                TextSpan(
                  text: correction.title,
                  style: const TextStyle(
                    color: SettingsColors.white,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                TextSpan(
                  text: ' — ${correction.description} · ${correction.date}',
                ),
              ],
            ),
            trailing: [
              SettingsPillButton(
                // Undo pulls a correction back; Restore re-applies one that
                // was already undone (the only path to un-dismiss).
                label: correction.applied ? 'Undo' : 'Restore',
                compact: true,
                onPressed: () => controller.toggleApplied(correction.id),
              ),
            ],
          ),
        const SettingsDivider(),
        SettingsActionRow(
          label: 'What LightSignal has learned about your business',
          subtitle: 'The living summary every agent reads before answering.',
          actions: [
            SettingsPillButton(
              label: 'View summary',
              onPressed: () =>
                  CustomToast.showInfo(context, 'Opening business summary…'),
            ),
          ],
        ),
        const SettingsDivider(),
        SettingsActionRow(
          label: 'Business classification',
          subtitle:
              'Last run ${ai.lastClassificationRun} · next scheduled run '
              'with your monthly refresh.',
          actions: [
            SettingsPillButton(
              label: 'Re-run now',
              onPressed: controller.rerunClassification,
            ),
          ],
        ),
      ],
    );
  }
}
