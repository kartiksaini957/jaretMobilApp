import 'package:flutter/material.dart';
import 'package:flutter_application_1/core/api_services.dart';
import 'package:flutter_application_1/features/setting/model/diagnosticsExportModel.dart';
import 'package:flutter_application_1/utils/diagnostics_export_helper.dart';
import 'package:flutter_application_1/utils/pref_utils.dart';
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

    final companySub = general.isLoading
        ? 'Loading company details…'
        : (general.companyName.isNotEmpty
            ? '${general.companyName} · managed in Business Profile → Business Basics.'
            : 'Managed in Business Profile → Business Basics.');

    return SettingsSectionCard(
      title: 'General',
      subtitle:
          'Company details live in your Business Profile — this is just the plumbing.',
      children: [
        SettingsActionRow(
          label: 'Company name',
          subtitle: companySub,
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
          isLoading: general.isLoading,
          onChanged: controller.setTimezone,
        ),
        const SettingsDivider(),
        SettingsDropdownRow<String>(
          label: 'Base currency',
          value: general.baseCurrency,
          options: GeneralSettingsState.currencies,
          isLoading: general.isLoading,
          onChanged: controller.setBaseCurrency,
        ),
        const SettingsDivider(),
        SettingsDropdownRow<String>(
          label: 'Default reporting period',
          value: general.reportingPeriod,
          options: GeneralSettingsState.reportingPeriods,
          isLoading: general.isLoading,
          labelBuilder: (v) => v.isNotEmpty
              ? '${v[0].toUpperCase()}${v.substring(1)}'
              : v,
          onChanged: controller.setReportingPeriod,
        ),
        const SettingsDivider(),
        SettingsToggleRow(
          label: 'Demo mode',
          subtitle:
              'Shows sample data everywhere. Turn off before showing real numbers.',
          value: general.demoMode,
          isLoading: general.isLoading,
          onChanged: controller.setDemoMode,
        ),
        const SettingsDivider(),
        SettingsToggleRow(
          label: 'Reduce motion',
          subtitle: 'Calms animations beyond your device setting.',
          value: general.reduceMotion,
          isLoading: general.isLoading,
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
                  CustomToast.showInfo(context, 'Coming soon...'),
            ),
             SettingsPillButton(
              label: 'Export diagnostics',
              onPressed: () => _exportDiagnostics(context),
            ),
          ],
        ),
        const SizedBox(height: 16),
       Text(
          general.isSaving ? 'Saving…' : 'Changes save automatically.',
          style: const TextStyle(color: Color(0xB3FFFFFF), fontSize: 11.5),
        ),
      ],
    );
  }
  Future<void> _exportDiagnostics(BuildContext context) async {
  CustomToast.showInfo(context, 'Preparing diagnostics export…');
  try {
    final token = await PrefUtils.getAccessToken();
    if (token == null || token.isEmpty) {
      throw ApiException('Not signed in.');
    }
    final DiagnosticsExportData data =
        await ApiService().getDiagnosticsExport(accessToken: token);

    await DiagnosticsExportHelper.exportToCsvAndShare(data);

    if (context.mounted) {
      CustomToast.showSuccess(context, 'Diagnostics file ready to save.');
    }
  } catch (e) {
    final message = e is ApiException
        ? e.message
        : 'Could not export diagnostics. Please try again.';
    if (context.mounted) {
      CustomToast.showError(context, message);
    }
  }
}
}
