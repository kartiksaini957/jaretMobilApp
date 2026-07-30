import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../widgets/customToast.dart';
import '../provider/notifications_provider.dart';
import '../theme/settings_colors.dart';
import '../widgets/settings_row_controls.dart';
import '../widgets/settings_section_card.dart';

class NotificationsTab extends ConsumerStatefulWidget {
  const NotificationsTab({super.key});

  @override
  ConsumerState<NotificationsTab> createState() => _NotificationsTabState();
}

class _NotificationsTabState extends ConsumerState<NotificationsTab> {
  final _recipientController = TextEditingController();

  @override
  void dispose() {
    _recipientController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final notif = ref.watch(notificationsProvider);
    final controller = ref.read(notificationsProvider.notifier);

    return SettingsSectionCard(
      title: 'Notifications',
      subtitle: 'What reaches you, and where.',
      children: [
        const SettingsGroupLabel('Channels', topPadding: 4),
        SettingsToggleRow(
          label: 'Push to your phone',
          subtitle:
              'The primary channel — alerts land where you\'ll actually see them.',
          value: notif.pushEnabled,
          onChanged: controller.setPushEnabled,
        ),
        const SettingsDivider(),
        SettingsToggleRow(
          label: 'In-app',
          value: notif.inAppEnabled,
          onChanged: controller.setInAppEnabled,
        ),
        const SettingsDivider(),
        SettingsToggleRow(
          label: 'Email',
          subtitle: 'Backup channel — reports and escalations.',
          value: notif.emailEnabled,
          onChanged: controller.setEmailEnabled,
        ),
        const SettingsDivider(),
        SettingsDropdownRow<String>(
          label: 'Escalate if I don\'t respond',
          subtitle:
              'A critical alert you haven\'t opened gets emailed as a follow-up.',
          value: notif.escalateAfter,
          options: NotificationsState.escalateOptions,
          onChanged: controller.setEscalateAfter,
        ),
        const SettingsGroupLabel('What you hear about'),
        SettingsToggleRow(
          label: 'Critical health alerts',
          subtitle: 'Business Health "act now" items — always urgent.',
          value: notif.criticalHealthAlerts,
          onChanged: controller.setCriticalHealthAlerts,
        ),
        const SettingsDivider(),
        SettingsToggleRow(
          label: 'Watch items',
          subtitle: 'Priority watch areas when something new starts building.',
          value: notif.watchItems,
          onChanged: controller.setWatchItems,
        ),
        const SettingsDivider(),
        SettingsToggleRow(
          label: 'Action reminders',
          subtitle: 'Unchecked action items from your forecast and insights.',
          value: notif.actionReminders,
          onChanged: controller.setActionReminders,
        ),
        const SettingsDivider(),
        SettingsToggleRow(
          label: 'Opportunities',
          subtitle: 'When a new opportunity clears your bar.',
          value: notif.opportunities,
          onChanged: controller.setOpportunities,
        ),
        const SettingsDivider(),
        SettingsToggleRow(
          label: 'Connection problems',
          subtitle:
              'A data source stops syncing — you hear about it before your numbers go stale.',
          value: notif.connectionProblems,
          onChanged: controller.setConnectionProblems,
        ),
        const SettingsDivider(),
        SettingsToggleRow(
          label: 'Weekly report',
          value: notif.weeklyReport,
          onChanged: controller.setWeeklyReport,
        ),
        const SettingsDivider(),
        SettingsToggleRow(
          label: 'Monthly summary',
          value: notif.monthlySummary,
          onChanged: controller.setMonthlySummary,
        ),
        const SettingsDivider(),
        SettingsDropdownRow<String>(
          label: 'Quiet hours',
          value: notif.quietHours,
          options: NotificationsState.quietHoursOptions,
          onChanged: controller.setQuietHours,
        ),
        const SettingsGroupLabel('Also send reports to'),
        const Text(
          'Your accountant or manager gets the weekly/monthly report too.',
          style: TextStyle(
            color: SettingsColors.faintText,
            fontSize: 12,
            height: 1.35,
          ),
        ),
        const SizedBox(height: 10),
        Row(
          children: [
            Expanded(
              child: SettingsTextField(
                controller: _recipientController,
                hintText: 'email@...',
              ),
            ),
            const SizedBox(width: 8),
            SettingsPillButton(
              label: 'Add',
              onPressed: () {
                controller.addRecipient(_recipientController.text);
                _recipientController.clear();
              },
            ),
          ],
        ),
        if (notif.alsoSendTo.isNotEmpty) ...[
          const SizedBox(height: 10),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              for (final email in notif.alsoSendTo)
                _RemovableChip(
                  label: email,
                  onRemove: () => controller.removeRecipient(email),
                ),
            ],
          ),
        ],
        const SettingsGroupLabel('Custom thresholds'),
        for (final threshold in notif.customThresholds)
          Padding(
            padding: const EdgeInsets.only(bottom: 10),
            child: _ThresholdRow(
              threshold: threshold,
              onChanged: (label) =>
                  controller.updateThreshold(threshold.id, label),
              onRemove: () => controller.removeThreshold(threshold.id),
            ),
          ),
        Row(
          children: [
            SettingsPillButton(
              label: '+ Add threshold',
              onPressed: controller.addThreshold,
            ),
            const SizedBox(width: 8),
            SettingsPillButton(
              label: 'Send test email',
              onPressed: () =>
                  CustomToast.showSuccess(context, 'Test email sent.'),
            ),
          ],
        ),
      ],
    );
  }
}

class _RemovableChip extends StatelessWidget {
  const _RemovableChip({required this.label, required this.onRemove});

  final String label;
  final VoidCallback onRemove;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(left: 12, right: 6, top: 5, bottom: 5),
      decoration: BoxDecoration(
        color: SettingsColors.cardFillStrong,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: SettingsColors.cardBorder),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            label,
            style: const TextStyle(color: SettingsColors.white, fontSize: 12),
          ),
          const SizedBox(width: 4),
          InkWell(
            onTap: onRemove,
            borderRadius: BorderRadius.circular(12),
            child: const Padding(
              padding: EdgeInsets.all(4),
              child: Icon(
                Icons.close,
                size: 14,
                color: SettingsColors.faintText,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _ThresholdRow extends StatefulWidget {
  const _ThresholdRow({
    required this.threshold,
    required this.onChanged,
    required this.onRemove,
  });

  final ThresholdItem threshold;
  final ValueChanged<String> onChanged;
  final VoidCallback onRemove;

  @override
  State<_ThresholdRow> createState() => _ThresholdRowState();
}

class _ThresholdRowState extends State<_ThresholdRow> {
  late final _controller = TextEditingController(text: widget.threshold.label);
  bool _editing = false;

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: _editing
              ? SettingsTextField(
                  controller: _controller,
                  onChanged: widget.onChanged,
                )
              : Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 14,
                    vertical: 12,
                  ),
                  decoration: BoxDecoration(
                    color: SettingsColors.cardFillStrong,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: SettingsColors.cardBorder),
                  ),
                  child: Text(
                    widget.threshold.label,
                    style: const TextStyle(
                      color: SettingsColors.white,
                      fontSize: 13,
                    ),
                  ),
                ),
        ),
        const SizedBox(width: 8),
        SettingsPillButton(
          label: _editing ? 'Remove' : 'Edit',
          danger: _editing,
          onPressed: () {
            if (_editing) {
              widget.onRemove();
            } else {
              setState(() => _editing = true);
            }
          },
        ),
      ],
    );
  }
}
