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
              label: backup.isLoading ? 'Creating…' : 'Create backup',
              tone: SettingsButtonTone.primary,
              onPressed: backup.isLoading
                  ? null
                  : () async {
                      CustomToast.showInfo(context, 'Creating backup…');
                      final success =
                          await controller.createBackup(format: 'json');
                      if (context.mounted) {
                        if (success) {
                          CustomToast.showSuccess(
                              context, 'Backup created successfully.');
                        } else {
                          CustomToast.showError(
                              context, 'Failed to create backup.');
                        }
                      }
                    },
            ),
          ],
        ),
        const SettingsDivider(),
        SettingsActionRow(
          label: 'Export tables (CSV)',
          actions: [
            SettingsPillButton(
              label: backup.isLoading ? 'Exporting…' : 'Export CSV',
              onPressed: backup.isLoading
                  ? null
                  : () async {
                      CustomToast.showInfo(context, 'Exporting tables as CSV…');
                      final success =
                          await controller.createBackup(format: 'csv');
                      if (context.mounted) {
                        if (success) {
                          CustomToast.showSuccess(
                              context, 'CSV exported successfully.');
                        } else {
                          CustomToast.showError(
                              context, 'Failed to export CSV.');
                        }
                      }
                    },
            ),
          ],
        ),
        const SettingsDivider(),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const SettingsGroupLabel('Snapshots'),
            if (!backup.isLoadingSnapshots)
              IconButton(
                icon: const Icon(
                  Icons.refresh_rounded,
                  size: 18,
                  color: SettingsColors.soft,
                ),
                tooltip: 'Refresh snapshots',
                visualDensity: VisualDensity.compact,
                padding: EdgeInsets.zero,
                constraints: const BoxConstraints(),
                onPressed: () {
                  CustomToast.showInfo(context, 'Refreshing snapshots…');
                  controller.fetchSnapshots();
                },
              ),
          ],
        ),
        if (backup.isLoadingSnapshots)
          const Padding(
            padding: EdgeInsets.symmetric(vertical: 14),
            child: Row(
              children: [
                SizedBox(
                  width: 16,
                  height: 16,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    color: SettingsColors.accent,
                  ),
                ),
                SizedBox(width: 10),
                Text(
                  'Loading snapshots…',
                  style: TextStyle(
                    color: SettingsColors.soft,
                    fontSize: 12.5,
                  ),
                ),
              ],
            ),
          )
        else if (backup.errorMessage != null && backup.snapshots.isEmpty)
          SettingsListRow(
            text: 'Failed to load snapshots',
            trailing: [
              SettingsPillButton(
                label: 'Retry',
                compact: true,
                onPressed: () => controller.fetchSnapshots(),
              ),
            ],
          )
        else if (backup.snapshots.isEmpty)
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 8),
            child: Text(
              'No snapshots available.',
              style: AppTextStyles.body.copyWith(
                color: SettingsColors.soft,
                fontSize: 12.5,
              ),
            ),
          )
        else
          for (final snapshot in backup.snapshots)
            SettingsListRow(
              text:
                  '${snapshot.formattedDate} · Health: ${snapshot.healthScore}',
              trailing: [
                SettingsPillButton(
                  label: 'Restore',
                  compact: true,
                  onPressed: () => CustomToast.showInfo(
                    context,
                    'Restoring snapshot ${snapshot.formattedDate}…',
                  ),
                ),
                SettingsPillButton(
                  label: 'Delete',
                  tone: SettingsButtonTone.danger,
                  compact: true,
                  onPressed: () {
                    controller.deleteSnapshot(snapshot.snapshotId);
                    CustomToast.showSuccess(context, 'Snapshot removed.');
                  },
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
