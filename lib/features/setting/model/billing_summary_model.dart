class BillingSummaryResponse {
  final bool success;
  final BillingSummaryData? data;

  const BillingSummaryResponse({
    this.success = false,
    this.data,
  });

  factory BillingSummaryResponse.fromJson(Map<String, dynamic> json) {
    return BillingSummaryResponse(
      success: json['success'] as bool? ?? false,
      data: json['data'] is Map<String, dynamic>
          ? BillingSummaryData.fromJson(json['data'] as Map<String, dynamic>)
          : null,
    );
  }

  Map<String, dynamic> toJson() => {
        'success': success,
        'data': data?.toJson(),
      };
}

class BillingSummaryData {
  final String userId;
  final bool isComped;
  final String planName;
  final String status;
  final String renewalDate;
  final String nextPaymentDate;
  final String paymentMethod;

  const BillingSummaryData({
    required this.userId,
    required this.isComped,
    required this.planName,
    required this.status,
    required this.renewalDate,
    required this.nextPaymentDate,
    required this.paymentMethod,
  });

  factory BillingSummaryData.fromJson(Map<String, dynamic> json) {
    return BillingSummaryData(
      userId: json['user_id']?.toString() ?? '',
      isComped: json['is_comped'] as bool? ?? false,
      planName: json['plan_name']?.toString() ?? 'Comped Pro Plan',
      status: json['status']?.toString() ?? 'active',
      renewalDate: json['renewal_date']?.toString() ?? '',
      nextPaymentDate: json['next_payment_date']?.toString() ?? '',
      paymentMethod: json['payment_method']?.toString() ?? 'Comped Account Pass',
    );
  }

  Map<String, dynamic> toJson() => {
        'user_id': userId,
        'is_comped': isComped,
        'plan_name': planName,
        'status': status,
        'renewal_date': renewalDate,
        'next_payment_date': nextPaymentDate,
        'payment_method': paymentMethod,
      };
}
