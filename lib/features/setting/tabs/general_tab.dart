import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../widgets/customToast.dart';
import '../../business_profile/business_profile_screen.dart';
import '../provider/general_provider.dart';
import '../widgets/settings_row_controls.dart';
import '../widgets/settings_section_card.dart';

class GeneralTab extends ConsumerWidget {
  const GeneralTab({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final general = ref.watch(generalSettingsProvider);
    final controller = ref.read(generalSettingsProvider.notifier);

    return SettingsSectionCard(
      title: 'General',
      subtitle:
          'Company details live in your Business Profile — this is just the plumbing.',
      children: [
        SettingsActionRow(
          label: 'Company name',
          subtitle:
              '${general.companyName} · managed in Business Profile → Business Basics.',
          actions: [
            SettingsPillButton(
              label: 'Open Business Profile →',
              onPressed: () => Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (_) => const BusinessProfileScreen(),
                ),
              ),
            ),
          ],
        ),
        const SettingsDivider(),
        SettingsDropdownRow<String>(
          label: 'Timezone',
          value: general.timezone,
          options: GeneralSettingsState.timezones,
          onChanged: controller.setTimezone,
        ),
        const SettingsDivider(),
        SettingsDropdownRow<String>(
          label: 'Base currency',
          value: general.baseCurrency,
          options: GeneralSettingsState.currencies,
          onChanged: controller.setBaseCurrency,
        ),
        const SettingsDivider(),
        SettingsDropdownRow<String>(
          label: 'Default reporting period',
          value: general.reportingPeriod,
          options: GeneralSettingsState.reportingPeriods,
          onChanged: controller.setReportingPeriod,
        ),
        const SettingsDivider(),
        SettingsToggleRow(
          label: 'Demo mode',
          subtitle:
              'Shows sample data everywhere. Turn off before showing real numbers.',
          value: general.demoMode,
          onChanged: controller.setDemoMode,
        ),
        const SettingsDivider(),
        SettingsToggleRow(
          label: 'Reduce motion',
          subtitle: 'Calms animations beyond your device setting.',
          value: general.reduceMotion,
          onChanged: controller.setReduceMotion,
        ),
        const SettingsGroupLabel('Help & support'),
        SettingsActionRow(
          label:
              'Talk to a human, or send us a diagnostics file if something looks wrong.',
          actions: [
            SettingsPillButton(
              label: 'Contact support',
              onPressed: () =>
                  CustomToast.showInfo(context, 'Opening support chat…'),
            ),
            SettingsPillButton(
              label: 'Export diagnostics',
              onPressed: () => CustomToast.showSuccess(
                context,
                'Diagnostics file exported.',
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        const Text(
          'Changes save automatically.',
          style: TextStyle(color: Color(0xB3FFFFFF), fontSize: 11.5),
        ),
      ],
    );
  }
}
