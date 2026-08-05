import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../theme/app_theme.dart';
import '../../../widgets/customToast.dart';
import '../provider/backup_provider.dart';
import '../theme/settings_colors.dart';
import '../widgets/settings_row_controls.dart';
import '../widgets/settings_section_card.dart';

class BackupTab extends ConsumerWidget {
  const BackupTab({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final backup = ref.watch(backupProvider);
    final controller = ref.read(backupProvider.notifier);

    return SettingsSectionCard(
      title: 'Backup & Export',
      subtitle: 'Your data, portable.',
      children: [
        SettingsActionRow(
          label: 'Export everything (JSON)',
          actions: [
            SettingsPillButton(
              label: 'Create backup',
              tone: SettingsButtonTone.primary,
              onPressed: () {
                controller.createBackup();
                CustomToast.showSuccess(context, 'Backup created.');
              },
            ),
          ],
        ),
        const SettingsDivider(),
        SettingsActionRow(
          label: 'Export tables (CSV)',
          actions: [
            SettingsPillButton(
              label: 'Export CSV',
              onPressed: () =>
                  CustomToast.showInfo(context, 'Exporting tables as CSV…'),
            ),
          ],
        ),
        const SettingsGroupLabel('Snapshots'),
        for (final snapshot in backup.snapshots)
          SettingsListRow(
            text: '${snapshot.timestamp} · ${snapshot.label}',
            trailing: [
              SettingsPillButton(
                label: 'Restore',
                compact: true,
                onPressed: () =>
                    CustomToast.showInfo(context, 'Restoring snapshot…'),
              ),
              SettingsPillButton(
                label: 'Delete',
                tone: SettingsButtonTone.danger,
                compact: true,
                onPressed: () => controller.deleteSnapshot(snapshot.id),
              ),
            ],
          ),
        const SizedBox(height: 14),
        Row(
          children: [
            SettingsStatusDot(
              color: backup.cloudSyncOk
                  ? SettingsColors.statusConnected
                  : SettingsColors.danger,
            ),
            const SizedBox(width: 6),
            Expanded(
              child: Text(
                backup.cloudSyncLabel,
                style: AppTextStyles.body.copyWith(
                  color: SettingsColors.soft,
                  fontSize: 11.5,
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
