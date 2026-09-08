import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/api_services.dart';
import '../model/billing_invoices_model.dart';
import '../model/billing_summary_model.dart';

class BillingState {
  const BillingState({
    this.summary,
    this.planName = 'Comped Pro Plan',
    this.paymentMethod = 'Comped Account Pass',
    this.invoices = const [],
    this.isLoading = false,
    this.errorMessage,
  });

  final BillingSummaryData? summary;
  final String planName;
  final String paymentMethod;
  final List<InvoiceItemModel> invoices;
  final bool isLoading;
  final String? errorMessage;

  String get renewalLabel {
    if (summary != null) {
      if (summary!.renewalDate.isNotEmpty && summary!.nextPaymentDate.isNotEmpty) {
        if (summary!.isComped) {
          return 'Renews ${summary!.renewalDate} · ${summary!.status.toUpperCase()}';
        }
        return 'Renews ${summary!.renewalDate} · next payment ${summary!.nextPaymentDate}';
      } else if (summary!.renewalDate.isNotEmpty) {
        return 'Renews ${summary!.renewalDate}';
      }
    }
    return 'Renews 2027-09-03 · Active';
  }

  String get cardLabel => summary?.paymentMethod ?? paymentMethod;

  BillingState copyWith({
    BillingSummaryData? summary,
    String? planName,
    String? paymentMethod,
    List<InvoiceItemModel>? invoices,
    bool? isLoading,
    String? errorMessage,
  }) {
    return BillingState(
      summary: summary ?? this.summary,
      planName: planName ?? this.planName,
      paymentMethod: paymentMethod ?? this.paymentMethod,
      invoices: invoices ?? this.invoices,
      isLoading: isLoading ?? this.isLoading,
      errorMessage: errorMessage,
    );
  }
}

class BillingController extends Notifier<BillingState> {
  @override
  BillingState build() {
    Future.microtask(() => fetchBillingData());
    return const BillingState(isLoading: true);
  }

  Future<void> fetchBillingData() async {
    state = state.copyWith(isLoading: true, errorMessage: null);
    try {
      BillingSummaryData? summaryData;
      List<InvoiceItemModel> invoicesData = [];

      try {
        final summaryRes = await ApiService().getBillingSummary();
        summaryData = summaryRes.data;
      } catch (e) {
        debugPrint('[BillingController] getBillingSummary error: $e');
      }

      try {
        final invoicesRes = await ApiService().getBillingInvoices();
        invoicesData = invoicesRes.data;
      } catch (e) {
        debugPrint('[BillingController] getBillingInvoices error: $e');
      }

      state = state.copyWith(
        summary: summaryData,
        planName: summaryData?.planName ?? (invoicesData.isNotEmpty && invoicesData.first.plan.isNotEmpty ? invoicesData.first.plan : state.planName),
        paymentMethod: summaryData?.paymentMethod ?? state.paymentMethod,
        invoices: invoicesData,
        isLoading: false,
      );
    } catch (e) {
      debugPrint('[BillingController] Error fetching billing data: $e');
      state = state.copyWith(
        isLoading: false,
        errorMessage: e.toString(),
      );
    }
  }
}

final billingProvider = NotifierProvider<BillingController, BillingState>(
  BillingController.new,
);
