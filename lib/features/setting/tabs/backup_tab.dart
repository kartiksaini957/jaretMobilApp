import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

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
              onPressed: controller.createBackup,
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
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 6),
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    '${snapshot.timestamp} · ${snapshot.label}',
                    style: const TextStyle(
                      color: SettingsColors.white,
                      fontSize: 12.5,
                    ),
                  ),
                ),
                SettingsPillButton(
                  label: 'Restore',
                  onPressed: () =>
                      CustomToast.showInfo(context, 'Restoring snapshot…'),
                ),
                const SizedBox(width: 8),
                SettingsPillButton(
                  label: 'Delete',
                  danger: true,
                  onPressed: () => controller.deleteSnapshot(snapshot.id),
                ),
              ],
            ),
          ),
        const SizedBox(height: 10),
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            SettingsStatusDot(
              color: backup.cloudSyncOk
                  ? SettingsColors.statusConnected
                  : SettingsColors.danger,
            ),
            const SizedBox(width: 6),
            Text(
              'Cloud sync: S3 · ${backup.cloudSyncOk ? 'ok' : 'error'}',
              style: const TextStyle(
                color: SettingsColors.faintText,
                fontSize: 12,
              ),
            ),
          ],
        ),
      ],
    );
  }
}
