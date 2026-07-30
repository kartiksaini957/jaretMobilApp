import 'package:flutter_riverpod/flutter_riverpod.dart';

class InvoiceItem {
  const InvoiceItem({
    required this.date,
    required this.amount,
    required this.currency,
  });

  final String date;
  final double amount;
  final String currency;
}

class BillingState {
  const BillingState({
    this.planName = 'Pro plan',
    this.renewsOn = '2026-01-01',
    this.nextPaymentOn = '2025-11-01',
    this.cardBrand = 'Visa',
    this.cardLast4 = '4242',
    this.cardExpiry = '12/27',
    this.invoices = const [
      InvoiceItem(date: '2025-10-01', amount: 199.00, currency: 'USD'),
    ],
  });

  final String planName;
  final String renewsOn;
  final String nextPaymentOn;
  final String cardBrand;
  final String cardLast4;
  final String cardExpiry;
  final List<InvoiceItem> invoices;
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
