class AlertNotificationItem {
  const AlertNotificationItem({
    required this.level,
    required this.title,
    required this.message,
    required this.action,
    required this.metric,
  });

  factory AlertNotificationItem.fromJson(Map<String, dynamic> json) {
    return AlertNotificationItem(
      level: json['level'] as String? ?? 'info',
      title: json['title'] as String? ?? '',
      message: json['message'] as String? ?? '',
      action: json['action'] as String? ?? '',
      metric: json['metric'] as String? ?? '',
    );
  }

  final String level;
  final String title;
  final String message;
  final String action;
  final String metric;

  bool get isWarning =>
      level.toLowerCase() == 'warning' || level.toLowerCase() == 'warn';
  bool get isDanger =>
      level.toLowerCase() == 'danger' ||
      level.toLowerCase() == 'critical' ||
      level.toLowerCase() == 'crit';
  bool get isSuccess =>
      level.toLowerCase() == 'success' || level.toLowerCase() == 'good';
}

class AlertNotificationsData {
  const AlertNotificationsData({
    required this.alerts,
    required this.count,
    required this.generatedAt,
  });

  factory AlertNotificationsData.fromJson(Map<String, dynamic> json) {
    final list = (json['alerts'] as List<dynamic>? ?? [])
        .map((e) => AlertNotificationItem.fromJson(e as Map<String, dynamic>))
        .toList();
    return AlertNotificationsData(
      alerts: list,
      count: json['count'] as int? ?? list.length,
      generatedAt: json['generated_at'] as String? ?? '',
    );
  }

  final List<AlertNotificationItem> alerts;
  final int count;
  final String generatedAt;
}

class AlertNotificationsResponse {
  const AlertNotificationsResponse({
    required this.success,
    required this.data,
  });

  factory AlertNotificationsResponse.fromJson(Map<String, dynamic> json) {
    return AlertNotificationsResponse(
      success: json['success'] as bool? ?? false,
      data: json['data'] is Map<String, dynamic>
          ? AlertNotificationsData.fromJson(
              json['data'] as Map<String, dynamic>,
            )
          : const AlertNotificationsData(
              alerts: [],
              count: 0,
              generatedAt: '',
            ),
    );
  }

  final bool success;
  final AlertNotificationsData data;
}
