class DataPrivacyResponse {
  const DataPrivacyResponse({required this.success, required this.data});

  factory DataPrivacyResponse.fromJson(Map<String, dynamic> json) {
    return DataPrivacyResponse(
      success: json['success'] as bool? ?? false,
      data: DataPrivacyData.fromJson(
        json['data'] as Map<String, dynamic>? ?? {},
      ),
    );
  }

  final bool success;
  final DataPrivacyData data;
}

class DataPrivacyData {
  const DataPrivacyData({
    required this.userId,
    required this.peerBenchmarking,
    required this.anonymizedAiUse,
    required this.retentionDays,
    required this.photoPermissionsEnabled,
    required this.photoSources,
    required this.updatedAt,
  });

  factory DataPrivacyData.fromJson(Map<String, dynamic> json) {
    final photo = json['photo_permissions'] as Map<String, dynamic>? ?? {};
    final sources = (photo['sources'] as List<dynamic>? ?? [])
        .map((e) => e.toString())
        .toSet();
    return DataPrivacyData(
      userId: json['user_id'] as String? ?? '',
      peerBenchmarking: json['peer_benchmarking'] as bool? ?? false,
      anonymizedAiUse: json['anonymized_ai_use'] as bool? ?? false,
      retentionDays: json['retention_days'] as int? ?? 365,
      photoPermissionsEnabled: photo['enabled'] as bool? ?? false,
      photoSources: sources,
      updatedAt: json['updated_at'] as String? ?? '',
    );
  }

  final String userId;
  final bool peerBenchmarking;
  final bool anonymizedAiUse;
  final int retentionDays;
  final bool photoPermissionsEnabled;
  final Set<String> photoSources; // e.g. {"google", "website", "facebook"}
  final String updatedAt;
}