import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../widgets/customToast.dart';
import '../../../widgets/tag_chip.dart';
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
        if (privacy.photoPermissions) ...[
          const SizedBox(height: 10),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              _SourceChip(
                label: 'Google Business Profile',
                enabled: privacy.googleBusinessProfile,
                onTap: () => controller.setGoogleBusinessProfile(
                  !privacy.googleBusinessProfile,
                ),
              ),
              _SourceChip(
                label: 'Website',
                enabled: privacy.website,
                onTap: () => controller.setWebsite(!privacy.website),
              ),
              _SourceChip(
                label: 'Facebook page',
                enabled: privacy.facebookPage,
                onTap: () => controller.setFacebookPage(!privacy.facebookPage),
              ),
            ],
          ),
        ],
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
              danger: true,
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

class _SourceChip extends StatelessWidget {
  const _SourceChip({
    required this.label,
    required this.enabled,
    required this.onTap,
  });

  final String label;
  final bool enabled;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(20),
      child: Opacity(
        opacity: enabled ? 1 : 0.45,
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              enabled ? Icons.check_circle : Icons.radio_button_unchecked,
              size: 14,
              color: enabled
                  ? SettingsColors.statusConnected
                  : SettingsColors.faintText,
            ),
            const SizedBox(width: 6),
            TagChip(label: label),
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
