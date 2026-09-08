class BillingInvoicesResponse {
  final bool success;
  final List<InvoiceItemModel> data;

  const BillingInvoicesResponse({
    this.success = false,
    this.data = const [],
  });

  factory BillingInvoicesResponse.fromJson(Map<String, dynamic> json) {
    final list = json['data'];
    final items = <InvoiceItemModel>[];
    if (list is List) {
      for (final item in list) {
        if (item is Map<String, dynamic>) {
          items.add(InvoiceItemModel.fromJson(item));
        }
      }
    }
    return BillingInvoicesResponse(
      success: json['success'] as bool? ?? false,
      data: items,
    );
  }

  Map<String, dynamic> toJson() => {
        'success': success,
        'data': data.map((e) => e.toJson()).toList(),
      };
}

class InvoiceItemModel {
  final String id;
  final String invoiceNumber;
  final String date;
  final String amount;
  final String status;
  final String plan;

  const InvoiceItemModel({
    required this.id,
    required this.invoiceNumber,
    required this.date,
    required this.amount,
    required this.status,
    required this.plan,
  });

  factory InvoiceItemModel.fromJson(Map<String, dynamic> json) {
    return InvoiceItemModel(
      id: json['id'] as String? ?? '',
      invoiceNumber: json['invoice_number'] as String? ?? '',
      date: json['date'] as String? ?? '',
      amount: json['amount'] as String? ?? '',
      status: json['status'] as String? ?? 'paid',
      plan: json['plan'] as String? ?? '',
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'invoice_number': invoiceNumber,
        'date': date,
        'amount': amount,
        'status': status,
        'plan': plan,
      };
}
