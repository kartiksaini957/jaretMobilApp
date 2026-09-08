  class NotificationsResponse {
    const NotificationsResponse({required this.success, required this.data});

    factory NotificationsResponse.fromJson(Map<String, dynamic> json) {
      return NotificationsResponse(
        success: json['success'] as bool? ?? false,
        data: NotificationsData.fromJson(
          json['data'] as Map<String, dynamic>? ?? {},
        ),
      );
    }

    final bool success;
    final NotificationsData data;
  }

  class ThresholdItem {
    const ThresholdItem({
      required this.id,
      required this.metric,
      required this.operatorSymbol,
      required this.value,
      required this.label,
    });

    factory ThresholdItem.fromJson(Map<String, dynamic> json) {
      return ThresholdItem(
        id: json['id'] as String? ?? '',
        metric: json['metric'] as String? ?? '',
        operatorSymbol: json['operator'] as String? ?? '<',
        value: json['value'] as num? ?? 0,
        label: json['label'] as String? ?? '',
      );
    }

    final String id;
    final String metric;
    final String operatorSymbol;
    final num value;
    final String label;

    ThresholdItem copyWith({String? label}) {
      return ThresholdItem(
        id: id,
        metric: metric,
        operatorSymbol: operatorSymbol,
        value: value,
        label: label ?? this.label,
      );
    }

    Map<String, dynamic> toJson() => {
          'id': id,
          'metric': metric,
          'operator': operatorSymbol,
          'value': value,
          'label': label,
        };
  }

  class NotificationsData {
    const NotificationsData({
      required this.pushEnabled,
      required this.inAppEnabled,
      required this.emailEnabled,
      required this.escalateAfter,
      required this.criticalHealthAlerts,
      required this.watchItems,
      required this.actionReminders,
      required this.opportunities,
      required this.connectionProblems,
      required this.weeklyReport,
      required this.monthlySummary,
      required this.quietHoursEnabled,
      required this.quietHoursStart,
      required this.quietHoursEnd,
      required this.recipients,
      required this.customThresholds,
    });

    factory NotificationsData.fromJson(Map<String, dynamic> json) {
      final quietHours = json['quiet_hours'] as Map<String, dynamic>? ?? {};
      final thresholds = (json['custom_thresholds'] as List<dynamic>? ?? [])
          .map((e) => ThresholdItem.fromJson(e as Map<String, dynamic>))
          .toList();
      final recipients = (json['report_recipient_emails'] as List<dynamic>? ??
              json['recipients'] as List<dynamic>? ??
              [])
          .map((e) => e.toString())
          .toList();
      return NotificationsData(
        pushEnabled: json['push_enabled'] as bool? ?? false,
        inAppEnabled: json['in_app_enabled'] as bool? ?? false,
        emailEnabled: json['email_enabled'] as bool? ?? false,
        escalateAfter: json['escalate_after'] as String? ?? '2_days',
        criticalHealthAlerts: json['critical_health_alerts'] as bool? ?? false,
        watchItems: json['watch_items'] as bool? ?? false,
        actionReminders: json['action_reminders'] as bool? ?? false,
        opportunities: json['opportunities'] as bool? ?? false,
        connectionProblems: json['connection_problems'] as bool? ?? false,
        weeklyReport: json['weekly_report'] as bool? ?? false,
        monthlySummary: json['monthly_summary'] as bool? ?? false,
        quietHoursEnabled: quietHours['enabled'] as bool? ??
            (json['quiet_hours_start'] != null),
        quietHoursStart: quietHours['start'] as String? ??
            json['quiet_hours_start'] as String? ??
            '21:00',
        quietHoursEnd: quietHours['end'] as String? ??
            json['quiet_hours_end'] as String? ??
            '07:00',
        recipients: recipients,
        customThresholds: thresholds,
      );
    }

    final bool pushEnabled;
    final bool inAppEnabled;
    final bool emailEnabled;
    final String escalateAfter;
    final bool criticalHealthAlerts;
    final bool watchItems;
    final bool actionReminders;
    final bool opportunities;
    final bool connectionProblems;
    final bool weeklyReport;
    final bool monthlySummary;
    final bool quietHoursEnabled;
    final String quietHoursStart;
    final String quietHoursEnd;
    final List<String> recipients;
    final List<ThresholdItem> customThresholds;
  }