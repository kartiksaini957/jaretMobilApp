import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../widgets/customToast.dart';
import '../provider/billing_provider.dart';
import '../widgets/settings_row_controls.dart';
import '../widgets/settings_section_card.dart';

class BillingTab extends ConsumerWidget {
  const BillingTab({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final billing = ref.watch(billingProvider);

    return SettingsSectionCard(
      title: 'Billing',
      subtitle: 'Plan, payment, and invoices.',
      children: [
        SettingsActionRow(
          label: billing.planName,
          subtitle: billing.renewalLabel,
          actions: [
            SettingsPillButton(
              label: 'Open billing portal',
              tone: SettingsButtonTone.primary,
              onPressed: () =>
                  CustomToast.showInfo(context, 'Opening billing portal…'),
            ),
          ],
        ),
        const SettingsDivider(),
        SettingsActionRow(
          label: 'Payment method',
          subtitle: billing.cardLabel,
          actions: [
            SettingsPillButton(
              label: 'Update',
              onPressed: () =>
                  CustomToast.showInfo(context, 'Opening payment methods…'),
            ),
          ],
        ),
        const SettingsGroupLabel('Invoices'),
        for (final invoice in billing.invoices)
          SettingsListRow(
            text: '${invoice.date} · ${invoice.amount}',
            trailing: [
              SettingsPillButton(
                label: 'View',
                compact: true,
                onPressed: () =>
                    CustomToast.showInfo(context, 'Opening invoice…'),
              ),
            ],
          ),
      ],
    );
  }
}
