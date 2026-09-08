import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../core/api_services.dart';
import '../../../theme/app_theme.dart';
import '../../../widgets/customToast.dart';
import '../model/billing_invoices_model.dart';
import '../provider/billing_provider.dart';
import '../widgets/settings_row_controls.dart';
import '../widgets/settings_section_card.dart';

class BillingTab extends ConsumerWidget {
  const BillingTab({super.key});

  Future<void> _openBillingPortal(BuildContext context) async {
    CustomToast.showInfo(context, 'Opening billing portal…');
    try {
      final res = await ApiService().getBillingPortalUrl();
      final urlString = res.data?.url ?? '';
      if (urlString.isEmpty) {
        if (context.mounted) {
          CustomToast.showError(context, 'Portal URL not found.');
        }
        return;
      }
      final uri = Uri.parse(urlString);
      final launched = await launchUrl(uri, mode: LaunchMode.externalApplication);
      if (!launched && context.mounted) {
        CustomToast.showError(context, 'Could not open billing portal.');
      }
    } catch (e) {
      if (context.mounted) {
        CustomToast.showError(context, 'Failed to open portal: $e');
      }
    }
  }

  void _showInvoiceDetails(BuildContext context, InvoiceItemModel invoice) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (ctx) => Container(
        padding: const EdgeInsets.all(22),
        decoration: BoxDecoration(
          color: const Color(0xFF052B3C),
          borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
          border: Border.all(
            color: const Color.fromRGBO(127, 227, 255, 0.35),
            width: 1.2,
          ),
          boxShadow: const [
            BoxShadow(
              color: Color.fromRGBO(0, 15, 30, 0.7),
              blurRadius: 30,
              offset: Offset(0, -5),
            ),
          ],
        ),
        child: SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Invoice Details',
                    style: AppTextStyles.headline.copyWith(
                      fontSize: 20,
                      fontWeight: FontWeight.w700,
                      color: Colors.white,
                    ),
                  ),
                  IconButton(
                    onPressed: () => Navigator.pop(ctx),
                    icon: const Icon(Icons.close_rounded, color: Colors.white70),
                  ),
                ],
              ),
              const SizedBox(height: 14),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: const Color.fromRGBO(8, 48, 68, 0.45),
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(
                    color: const Color.fromRGBO(127, 227, 255, 0.2),
                  ),
                ),
                child: Column(
                  children: [
                    _invoiceRow('Invoice Number', invoice.invoiceNumber),
                    const Divider(color: Color.fromRGBO(255, 255, 255, 0.1), height: 18),
                    _invoiceRow('Date', invoice.date),
                    const Divider(color: Color.fromRGBO(255, 255, 255, 0.1), height: 18),
                    _invoiceRow('Plan', invoice.plan.isNotEmpty ? invoice.plan : 'Pro Plan'),
                    const Divider(color: Color.fromRGBO(255, 255, 255, 0.1), height: 18),
                    _invoiceRow('Amount', invoice.amount),
                    const Divider(color: Color.fromRGBO(255, 255, 255, 0.1), height: 18),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Status',
                          style: AppTextStyles.body.copyWith(
                            fontSize: 13.5,
                            color: const Color(0xFF90DFFF),
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                          decoration: BoxDecoration(
                            color: const Color(0xFF6FDB6C).withValues(alpha: 0.18),
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(
                              color: const Color(0xFF6FDB6C).withValues(alpha: 0.6),
                            ),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Container(
                                width: 6,
                                height: 6,
                                decoration: const BoxDecoration(
                                  color: Color(0xFF6FDB6C),
                                  shape: BoxShape.circle,
                                ),
                              ),
                              const SizedBox(width: 6),
                              Text(
                                invoice.status.toUpperCase(),
                                style: AppTextStyles.small.copyWith(
                                  fontSize: 11.5,
                                  fontWeight: FontWeight.w700,
                                  color: const Color(0xFF6FDB6C),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 18),
              SizedBox(
                width: double.infinity,
                height: 46,
                child: ElevatedButton(
                  onPressed: () => Navigator.pop(ctx),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF5FE0FF),
                    foregroundColor: const Color(0xFF04303F),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    elevation: 0,
                  ),
                  child: const Text(
                    'Close',
                    style: TextStyle(fontWeight: FontWeight.w700, fontSize: 14),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _invoiceRow(String label, String value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: AppTextStyles.body.copyWith(
            fontSize: 13.5,
            color: const Color(0xFF90DFFF),
          ),
        ),
        Flexible(
          child: Text(
            value,
            textAlign: TextAlign.end,
            style: AppTextStyles.body.copyWith(
              fontSize: 13.5,
              fontWeight: FontWeight.w600,
              color: Colors.white,
            ),
          ),
        ),
      ],
    );
  }

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
              onPressed: () => _openBillingPortal(context),
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
              onPressed: () => _openBillingPortal(context),
            ),
          ],
        ),
        const SettingsGroupLabel('Invoices'),
        if (billing.isLoading)
          const Padding(
            padding: EdgeInsets.symmetric(vertical: 16),
            child: Center(
              child: SizedBox(
                width: 22,
                height: 22,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  color: Color(0xFF5FE0FF),
                ),
              ),
            ),
          )
        else if (billing.invoices.isEmpty)
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 12),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  billing.errorMessage != null
                      ? 'Failed to load invoices'
                      : 'No invoices available',
                  style: const TextStyle(color: Colors.white60, fontSize: 13),
                ),
                if (billing.errorMessage != null)
                  SettingsPillButton(
                    label: 'Retry',
                    compact: true,
                    onPressed: () =>
                        ref.read(billingProvider.notifier).fetchBillingData(),
                  ),
              ],
            ),
          )
        else
          for (final invoice in billing.invoices)
            SettingsListRow(
              text: '${invoice.date} · ${invoice.amount}',
              trailing: [
                SettingsPillButton(
                  label: 'View',
                  compact: true,
                  onPressed: () => _showInvoiceDetails(context, invoice),
                ),
              ],
            ),
      ],
    );
  }
}
