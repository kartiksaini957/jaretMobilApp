class BillingPortalResponse {
  final bool success;
  final BillingPortalData? data;

  const BillingPortalResponse({
    this.success = false,
    this.data,
  });

  factory BillingPortalResponse.fromJson(Map<String, dynamic> json) {
    return BillingPortalResponse(
      success: json['success'] as bool? ?? false,
      data: json['data'] is Map<String, dynamic>
          ? BillingPortalData.fromJson(json['data'] as Map<String, dynamic>)
          : null,
    );
  }

  Map<String, dynamic> toJson() => {
        'success': success,
        'data': data?.toJson(),
      };
}

class BillingPortalData {
  final String userId;
  final String url;

  const BillingPortalData({
    required this.userId,
    required this.url,
  });

  factory BillingPortalData.fromJson(Map<String, dynamic> json) {
    return BillingPortalData(
      userId: json['user_id']?.toString() ?? '',
      url: json['url']?.toString() ?? '',
    );
  }

  Map<String, dynamic> toJson() => {
        'user_id': userId,
        'url': url,
      };
}
