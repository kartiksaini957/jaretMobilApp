import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../widgets/customToast.dart';
import '../provider/billing_provider.dart';
import '../theme/settings_colors.dart';
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
          subtitle:
              'Renews ${billing.renewsOn} · next payment ${billing.nextPaymentOn}',
          actions: [
            SettingsPillButton(
              label: 'Open billing portal',
              onPressed: () =>
                  CustomToast.showInfo(context, 'Opening billing portal…'),
            ),
          ],
        ),
        const SettingsDivider(),
        Row(
          children: [
            const Expanded(
              child: Text(
                'Payment method',
                style: TextStyle(
                  color: SettingsColors.white,
                  fontSize: 14,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
            Text(
              '${billing.cardBrand} —${billing.cardLast4} · exp ${billing.cardExpiry}',
              style: const TextStyle(
                color: SettingsColors.faintText,
                fontSize: 12.5,
              ),
            ),
          ],
        ),
        const SettingsGroupLabel('Invoices'),
        for (final invoice in billing.invoices)
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 6),
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    '${invoice.date} · ${invoice.amount.toStringAsFixed(2)} ${invoice.currency}',
                    style: const TextStyle(
                      color: SettingsColors.white,
                      fontSize: 13,
                    ),
                  ),
                ),
                SettingsPillButton(
                  label: 'View',
                  onPressed: () =>
                      CustomToast.showInfo(context, 'Opening invoice…'),
                ),
              ],
            ),
          ),
      ],
    );
  }
}
