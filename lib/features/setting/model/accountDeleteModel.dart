class AccountDeleteResponse {
  const AccountDeleteResponse({required this.success, required this.data});

  factory AccountDeleteResponse.fromJson(Map<String, dynamic> json) {
    return AccountDeleteResponse(
      success: json['success'] as bool? ?? false,
      data: AccountDeleteData.fromJson(
        json['data'] as Map<String, dynamic>? ?? {},
      ),
    );
  }

  final bool success;
  final AccountDeleteData data;
}

class AccountDeleteData {
  const AccountDeleteData({
    required this.userId,
    required this.status,
    required this.gracePeriodDays,
    required this.hardDeletionDate,
  });

  factory AccountDeleteData.fromJson(Map<String, dynamic> json) {
    return AccountDeleteData(
      userId: json['user_id'] as String? ?? '',
      status: json['status'] as String? ?? '',
      gracePeriodDays: json['grace_period_days'] as int? ?? 14,
      hardDeletionDate: json['hard_deletion_date'] as String? ?? '',
    );
  }

  final String userId;
  final String status;
  final int gracePeriodDays;
  final String hardDeletionDate;
}