class LivingSummaryResponse {
  const LivingSummaryResponse({
    required this.success,
    this.data,
  });

  factory LivingSummaryResponse.fromJson(Map<String, dynamic> json) {
    return LivingSummaryResponse(
      success: json['success'] as bool? ?? false,
      data: json['data'] != null && json['data'] is Map<String, dynamic>
          ? LivingSummaryData.fromJson(json['data'] as Map<String, dynamic>)
          : null,
    );
  }

  final bool success;
  final LivingSummaryData? data;
}

class LivingSummaryData {
  const LivingSummaryData({
    required this.userId,
    required this.observations,
    required this.updatedAt,
  });

  factory LivingSummaryData.fromJson(Map<String, dynamic> json) {
    final obsRaw = json['observations'];
    final List<String> obs = [];
    if (obsRaw is List) {
      for (final item in obsRaw) {
        if (item != null && item.toString().trim().isNotEmpty) {
          obs.add(item.toString());
        }
      }
    }
    return LivingSummaryData(
      userId: json['user_id'] as String? ?? '',
      observations: obs,
      updatedAt: json['updated_at'] as String? ?? '',
    );
  }

  final String userId;
  final List<String> observations;
  final String updatedAt;
}
