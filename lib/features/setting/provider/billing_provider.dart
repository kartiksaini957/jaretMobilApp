import 'package:flutter_riverpod/flutter_riverpod.dart';

class InvoiceItem {
  const InvoiceItem({required this.date, required this.amount});

  /// Already formatted for display — "Jun 1, 2026".
  final String date;

  /// Already formatted for display — "$199".
  final String amount;
}

class BillingState {
  const BillingState({
    this.planName = 'Pro plan',
    this.renewsOn = 'Jan 1, 2027',
    this.nextPaymentOn = 'Dec 1, 2026',
    this.cardBrand = 'Visa',
    this.cardLast4 = '4242',
    this.invoices = const [
      InvoiceItem(date: 'Jun 1, 2026', amount: '\$199'),
      InvoiceItem(date: 'May 1, 2026', amount: '\$199'),
    ],
  });

  final String planName;
  final String renewsOn;
  final String nextPaymentOn;
  final String cardBrand;
  final String cardLast4;
  final List<InvoiceItem> invoices;

  /// "Renews Jan 1, 2027 · next payment Dec 1, 2026".
  String get renewalLabel =>
      'Renews $renewsOn · next payment $nextPaymentOn';

  /// "Visa ····4242".
  String get cardLabel => '$cardBrand ····$cardLast4';
}

/// Billing tab is read-mostly — plan/payment/invoices come from the
/// billing provider (Stripe et al.) in a real integration; this just
/// exposes the current snapshot for the UI to render.
class BillingController extends Notifier<BillingState> {
  @override
  BillingState build() => const BillingState();
}

final billingProvider = NotifierProvider<BillingController, BillingState>(
  BillingController.new,
);
