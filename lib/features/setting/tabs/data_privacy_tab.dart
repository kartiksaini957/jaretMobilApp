import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../theme/app_theme.dart';
import '../../../widgets/customToast.dart';
import '../provider/data_privacy_provider.dart';
import '../theme/settings_colors.dart';
import '../widgets/settings_row_controls.dart';
import '../widgets/settings_section_card.dart';

class DataPrivacyTab extends ConsumerWidget {
  const DataPrivacyTab({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final privacy = ref.watch(dataPrivacyProvider);
    final controller = ref.read(dataPrivacyProvider.notifier);

    return SettingsSectionCard(
      title: 'Data & Privacy',
      subtitle: 'What LightSignal may use, and for how long.',
      children: [
        SettingsToggleRow(
          label: 'Peer benchmarking',
          subtitle:
              'Compare your numbers against anonymized businesses like yours. Your data stays anonymous in others\' comparisons too.',
          value: privacy.peerBenchmarking,
          onChanged: controller.setPeerBenchmarking,
        ),
        const SettingsDivider(),
        SettingsToggleRow(
          label: 'Anonymized data for AI improvement',
          subtitle: 'Never your name, never your customers.',
          value: privacy.aiImprovement,
          onChanged: controller.setAiImprovement,
        ),
        const SettingsDivider(),
        SettingsToggleRow(
          label: 'Business photo permissions',
          subtitle:
              'Let LightSignal read photos of your business — from your Google Business Profile, your website, and your Facebook page — to assess storefront presentation and flag mismatches. Only your business is ever assessed, never people or the neighborhood. (Final consent wording pending legal review.)',
          value: privacy.photoPermissions,
          onChanged: controller.setPhotoPermissions,
        ),
        // The per-source consent gate. It stays visible when the master
        // toggle is off — greyed out — so the owner can always see exactly
        // which sources the agent would be allowed to read.
        _PhotoSourcesRow(
          enabled: privacy.photoPermissions,
          sources: [
            (
              'Google Business Profile',
              privacy.googleBusinessProfile,
              controller.setGoogleBusinessProfile,
            ),
            ('Website', privacy.website, controller.setWebsite),
            (
              'Facebook page',
              privacy.facebookPage,
              controller.setFacebookPage,
            ),
          ],
        ),
        const SettingsDivider(),
        SettingsDropdownRow<int>(
          label: 'Data retention',
          value: privacy.retentionDays,
          options: DataPrivacyState.retentionOptions,
          labelBuilder: (v) => '$v days',
          onChanged: controller.setRetentionDays,
        ),
        const SettingsDivider(),
        SettingsActionRow(
          label: 'Consent history',
          subtitle: 'A dated log of everything you\'ve agreed to.',
          actions: [
            SettingsPillButton(
              label: 'View',
              onPressed: () =>
                  CustomToast.showInfo(context, 'Opening consent history…'),
            ),
          ],
        ),
        const SettingsDivider(),
        SettingsActionRow(
          label: 'Export & delete my account',
          subtitle:
              'Download everything, then permanently erase your data. Irreversible after the 14-day grace window.',
          actions: [
            SettingsPillButton(
              label: 'Start deletion',
              tone: SettingsButtonTone.danger,
              onPressed: () => _confirmDeletion(context),
            ),
          ],
        ),
        const SizedBox(height: 16),
        const Text(
          'SOC 2 · GDPR · CCPA — LightSignal\'s compliance posture applies to all stored data.',
          style: TextStyle(color: SettingsColors.faintText, fontSize: 11.5),
        ),
      ],
    );
  }
}

/// The indented "Sources:" row of per-source checkboxes under the photo
/// permissions toggle.
class _PhotoSourcesRow extends StatelessWidget {
  const _PhotoSourcesRow({required this.enabled, required this.sources});

  final bool enabled;
  final List<(String, bool, ValueChanged<bool>)> sources;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 22, top: 4, bottom: 8),
      child: Opacity(
        opacity: enabled ? 1 : 0.45,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Sources:',
              style: AppTextStyles.body.copyWith(
                color: SettingsColors.soft,
                fontSize: 11.5,
              ),
            ),
            const SizedBox(height: 4),
            // Stacked rather than inline: these labels are long enough that
            // a single narrow column is the only layout that survives both
            // a 320pt phone and a large text scale.
            for (final (label, checked, onChanged) in sources)
              _SourceCheckbox(
                label: label,
                checked: checked,
                onChanged: enabled ? onChanged : null,
              ),
          ],
        ),
      ),
    );
  }
}

class _SourceCheckbox extends StatelessWidget {
  const _SourceCheckbox({
    required this.label,
    required this.checked,
    required this.onChanged,
  });

  final String label;
  final bool checked;
  final ValueChanged<bool>? onChanged;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onChanged == null ? null : () => onChanged!(!checked),
      borderRadius: BorderRadius.circular(8),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 6),
        child: Row(
          children: [
            Icon(
              checked ? Icons.check_box : Icons.check_box_outline_blank,
              size: 18,
              color: checked
                  ? SettingsColors.accent
                  : SettingsColors.soft.withValues(alpha: 0.6),
            ),
            const SizedBox(width: 6),
            Expanded(
              child: Text(
                label,
                style: AppTextStyles.body.copyWith(
                  color: SettingsColors.soft,
                  fontSize: 12,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

void _confirmDeletion(BuildContext context) {
  showDialog<void>(
    context: context,
    builder: (dialogContext) => AlertDialog(
      backgroundColor: const Color(0xFF0A4A63),
      title: const Text(
        'Start account deletion?',
        style: TextStyle(color: SettingsColors.white),
      ),
      content: const Text(
        'This begins the 14-day grace window. After that, your data is permanently erased.',
        style: TextStyle(color: SettingsColors.faintText),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(dialogContext).pop(),
          child: const Text('Cancel'),
        ),
        TextButton(
          onPressed: () {
            Navigator.of(dialogContext).pop();
            CustomToast.showSuccess(
              context,
              'Deletion started — 14-day grace window began.',
            );
          },
          child: const Text(
            'Start deletion',
            style: TextStyle(color: SettingsColors.danger),
          ),
        ),
      ],
    ),
  );
}
