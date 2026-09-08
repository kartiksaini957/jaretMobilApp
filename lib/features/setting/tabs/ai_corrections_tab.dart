import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../widgets/customToast.dart';
import '../provider/ai_corrections_provider.dart';
import '../theme/settings_colors.dart';
import '../widgets/living_summary_sheet.dart';
import '../widgets/settings_row_controls.dart';
import '../widgets/settings_section_card.dart';

class AiCorrectionsTab extends ConsumerWidget {
  const AiCorrectionsTab({super.key});

  Future<void> _toggle(BuildContext context, WidgetRef ref, String id) async {
    await ref.read(aiCorrectionsProvider.notifier).toggleApplied(id);
    if (!context.mounted) return;
    final error = ref.read(aiCorrectionsProvider).error;
    if (error != null) {
      CustomToast.showError(context, error);
    }
  }

  Future<void> _rerun(BuildContext context, WidgetRef ref) async {
    await ref.read(aiCorrectionsProvider.notifier).rerunClassification();
    if (!context.mounted) return;
    final error = ref.read(aiCorrectionsProvider).error;
    if (error != null) {
      CustomToast.showError(context, error);
    } else {
      CustomToast.showSuccess(context, 'Classification re-run started.');
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final ai = ref.watch(aiCorrectionsProvider);
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
                label: ai.togglingCorrectionId == correction.id
                    ? '...'
                    : (correction.applied ? 'Undo' : 'Restore'),
                compact: true,
                onPressed: ai.togglingCorrectionId == correction.id
                    ? null
                    : () => _toggle(context, ref, correction.id),
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
              onPressed: () => showLivingSummarySheet(context),
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
              label: ai.isRunningClassifier ? 'Running…' : 'Re-run now',
              onPressed: ai.isRunningClassifier
                  ? null
                  : () => _rerun(context, ref),
            ),
          ],
        ),
      ],
    );
  }
}
