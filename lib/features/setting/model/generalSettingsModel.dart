class GeneralSettingsResponse {
  const GeneralSettingsResponse({required this.success, required this.data});

  factory GeneralSettingsResponse.fromJson(Map<String, dynamic> json) {
    return GeneralSettingsResponse(
      success: json['success'] as bool? ?? false,
      data: GeneralSettingsData.fromJson(
        json['data'] as Map<String, dynamic>? ?? {},
      ),
    );
  }

  final bool success;
  final GeneralSettingsData data;
}

class GeneralSettingsData {
  const GeneralSettingsData({
    required this.userId,
    required this.timezone,
    required this.baseCurrency,
    required this.reportingPeriod,
    required this.demoMode,
    required this.reduceMotion,
    required this.updatedAt,
    required this.companyName,
  });

  factory GeneralSettingsData.fromJson(Map<String, dynamic> json) {
    return GeneralSettingsData(
      userId: json['user_id'] as String? ?? '',
      timezone: json['timezone'] as String? ?? 'America/New_York',
      baseCurrency: json['base_currency'] as String? ?? 'USD',
      reportingPeriod:
          (json['reporting_period'] as String? ?? 'monthly').toLowerCase(),
      demoMode: json['demo_mode'] as bool? ?? false,
      reduceMotion: json['reduce_motion'] as bool? ?? false,
      updatedAt: json['updated_at'] as String? ?? '',
      companyName: json['company_name'] as String? ?? '',
    );
  }

  final String userId;
  final String timezone;
  final String baseCurrency;
  final String reportingPeriod;
  final bool demoMode;
  final bool reduceMotion;
  final String updatedAt;
  final String companyName;
}