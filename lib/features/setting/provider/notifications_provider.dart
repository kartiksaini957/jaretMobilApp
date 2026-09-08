import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/api_services.dart';
import '../../../utils/pref_utils.dart';
import '../model/notificationsModel.dart';

export '../model/notificationsModel.dart' show ThresholdItem;

@immutable
class NotificationsState {
  const NotificationsState({
    this.pushEnabled = false,
    this.inAppEnabled = true,
    this.emailEnabled = true,
    this.escalateAfter = '2_days',
    this.criticalHealthAlerts = true,
    this.watchItems = true,
    this.actionReminders = true,
    this.opportunities = true,
    this.connectionProblems = true,
    this.weeklyReport = true,
    this.monthlySummary = true,
    this.quietHours = '9:00 PM – 7:00 AM',
    this.quietHoursEnabled = true,
    this.quietHoursStart = '21:00',
    this.quietHoursEnd = '07:00',
    this.alsoSendTo = const [],
    this.customThresholds = const [],
    this.isLoading = true,
    this.isSaving = false,
    this.error,
  });

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
  final String quietHours; // display label, e.g. "9:00 PM – 7:00 AM" or "Off"
  final bool quietHoursEnabled;
  final String quietHoursStart;
  final String quietHoursEnd;
  final List<String> alsoSendTo;
  final List<ThresholdItem> customThresholds;
  final bool isLoading;
  final bool isSaving;
  final String? error;

  static const escalateOptions = ['1_day', '2_days', '3_days', '1_week'];
  static const Map<String, String> escalateLabels = {
    '1_day': '1 day',
    '2_days': '2 days',
    '3_days': '3 days',
    '1_week': '1 week',
  };
   static String escalateLabelFor(String code) => escalateLabels[code] ?? code;

  static String escalateCodeFor(String label) => escalateLabels.entries
      .firstWhere((e) => e.value == label, orElse: () => MapEntry(label, label))
      .key;

  static const quietHoursOptions = [
    'Off',
    '9:00 PM – 7:00 AM',
    '10:00 PM – 6:00 AM',
    '11:00 PM – 7:00 AM',
  ];

  static const Map<String, (String, String)> _presetTimes = {
    '9:00 PM – 7:00 AM': ('21:00', '07:00'),
    '10:00 PM – 6:00 AM': ('22:00', '06:00'),
    '11:00 PM – 7:00 AM': ('23:00', '07:00'),
  };

  static String _labelFor(bool enabled, String start, String end) {
    if (!enabled) return 'Off';
    for (final entry in _presetTimes.entries) {
      if (entry.value.$1 == start && entry.value.$2 == end) return entry.key;
    }
    return quietHoursOptions[1]; // fallback to first preset
  }

  NotificationsState copyWith({
    bool? pushEnabled,
    bool? inAppEnabled,
    bool? emailEnabled,
    String? escalateAfter,
    bool? criticalHealthAlerts,
    bool? watchItems,
    bool? actionReminders,
    bool? opportunities,
    bool? connectionProblems,
    bool? weeklyReport,
    bool? monthlySummary,
    String? quietHours,
    bool? quietHoursEnabled,
    String? quietHoursStart,
    String? quietHoursEnd,
    List<String>? alsoSendTo,
    List<ThresholdItem>? customThresholds,
    bool? isLoading,
    bool? isSaving,
    String? error,
  }) {
    return NotificationsState(
      pushEnabled: pushEnabled ?? this.pushEnabled,
      inAppEnabled: inAppEnabled ?? this.inAppEnabled,
      emailEnabled: emailEnabled ?? this.emailEnabled,
      escalateAfter: escalateAfter ?? this.escalateAfter,
      criticalHealthAlerts: criticalHealthAlerts ?? this.criticalHealthAlerts,
      watchItems: watchItems ?? this.watchItems,
      actionReminders: actionReminders ?? this.actionReminders,
      opportunities: opportunities ?? this.opportunities,
      connectionProblems: connectionProblems ?? this.connectionProblems,
      weeklyReport: weeklyReport ?? this.weeklyReport,
      monthlySummary: monthlySummary ?? this.monthlySummary,
      quietHours: quietHours ?? this.quietHours,
      quietHoursEnabled: quietHoursEnabled ?? this.quietHoursEnabled,
      quietHoursStart: quietHoursStart ?? this.quietHoursStart,
      quietHoursEnd: quietHoursEnd ?? this.quietHoursEnd,
      alsoSendTo: alsoSendTo ?? this.alsoSendTo,
      customThresholds: customThresholds ?? this.customThresholds,
      isLoading: isLoading ?? this.isLoading,
      isSaving: isSaving ?? this.isSaving,
      error: error,
    );
  }
}

class NotificationsController extends Notifier<NotificationsState> {
  @override
  NotificationsState build() {
    Future.microtask(_load);
    return const NotificationsState();
  }

  Future<void> _load() async {
    state = state.copyWith(isLoading: true, error: null);
    try {
      final token = await PrefUtils.getAccessToken();
      if (token == null || token.isEmpty) {
        throw ApiException('Not signed in.');
      }
      final d = await ApiService().getNotificationSettings(accessToken: token);
      if (!ref.mounted) return;
      state = NotificationsState(
        pushEnabled: d.pushEnabled,
        inAppEnabled: d.inAppEnabled,
        emailEnabled: d.emailEnabled,
        escalateAfter: d.escalateAfter,
        criticalHealthAlerts: d.criticalHealthAlerts,
        watchItems: d.watchItems,
        actionReminders: d.actionReminders,
        opportunities: d.opportunities,
        connectionProblems: d.connectionProblems,
        weeklyReport: d.weeklyReport,
        monthlySummary: d.monthlySummary,
        quietHours: NotificationsState._labelFor(
          d.quietHoursEnabled, d.quietHoursStart, d.quietHoursEnd,
        ),
        quietHoursEnabled: d.quietHoursEnabled,
        quietHoursStart: d.quietHoursStart,
        quietHoursEnd: d.quietHoursEnd,
        alsoSendTo: d.recipients,
        customThresholds: d.customThresholds,
        isLoading: false,
      );
    } catch (e) {
      if (!ref.mounted) return;
      final message = e is ApiException ? e.message : 'Could not load notification settings.';
      state = state.copyWith(isLoading: false, error: message);
    }
  }

  void retry() => _load();

  Future<void> _patch(Map<String, dynamic> changes) async {
    state = state.copyWith(isSaving: true, error: null);
    try {
      final token = await PrefUtils.getAccessToken();
      if (token == null || token.isEmpty) {
        throw ApiException('Not signed in.');
      }
      await ApiService().updateNotificationSettings(accessToken: token, changes: changes);
      if (!ref.mounted) return;
      state = state.copyWith(isSaving: false);
    } catch (e) {
      if (!ref.mounted) return;
      final message = e is ApiException ? e.message : 'Could not save changes.';
      state = state.copyWith(isSaving: false, error: message);
    }
  }

  // ---- channels ----
  void setPushEnabled(bool v) {
    final prev = state.pushEnabled;
    state = state.copyWith(pushEnabled: v);
    _patch({'push_enabled': v}).then((_) {
      if (ref.mounted && state.error != null) state = state.copyWith(pushEnabled: prev);
    });
  }

  void setInAppEnabled(bool v) {
    final prev = state.inAppEnabled;
    state = state.copyWith(inAppEnabled: v);
    _patch({'in_app_enabled': v}).then((_) {
      if (ref.mounted && state.error != null) state = state.copyWith(inAppEnabled: prev);
    });
  }

  void setEmailEnabled(bool v) {
    final prev = state.emailEnabled;
    state = state.copyWith(emailEnabled: v);
    _patch({'email_enabled': v}).then((_) {
      if (ref.mounted && state.error != null) state = state.copyWith(emailEnabled: prev);
    });
  }

  void setEscalateAfter(String v) {
    final prev = state.escalateAfter;
    state = state.copyWith(escalateAfter: v);
    final days = int.tryParse(RegExp(r'\d+').stringMatch(v) ?? '') ?? 2;
    _patch({'escalate_after': v, 'escalation_days': days}).then((_) {
      if (ref.mounted && state.error != null) state = state.copyWith(escalateAfter: prev);
    });
  }

  // ---- categories ----
  void setCriticalHealthAlerts(bool v) {
    final prev = state.criticalHealthAlerts;
    state = state.copyWith(criticalHealthAlerts: v);
    _patch({
      'critical_health_alerts': v,
      'categories': _categoriesJson(critical: v),
    }).then((_) {
      if (ref.mounted && state.error != null) state = state.copyWith(criticalHealthAlerts: prev);
    });
  }

  void setWatchItems(bool v) {
    final prev = state.watchItems;
    state = state.copyWith(watchItems: v);
    _patch({'watch_items': v, 'categories': _categoriesJson(watch: v)}).then((_) {
      if (ref.mounted && state.error != null) state = state.copyWith(watchItems: prev);
    });
  }

  void setActionReminders(bool v) {
    final prev = state.actionReminders;
    state = state.copyWith(actionReminders: v);
    _patch({'action_reminders': v, 'categories': _categoriesJson(action: v)}).then((_) {
      if (ref.mounted && state.error != null) state = state.copyWith(actionReminders: prev);
    });
  }

  void setOpportunities(bool v) {
    final prev = state.opportunities;
    state = state.copyWith(opportunities: v);
    _patch({'opportunities': v, 'categories': _categoriesJson(opp: v)}).then((_) {
      if (ref.mounted && state.error != null) state = state.copyWith(opportunities: prev);
    });
  }

  void setConnectionProblems(bool v) {
    final prev = state.connectionProblems;
    state = state.copyWith(connectionProblems: v);
    _patch({'connection_problems': v, 'categories': _categoriesJson(conn: v)}).then((_) {
      if (ref.mounted && state.error != null) state = state.copyWith(connectionProblems: prev);
    });
  }

  void setWeeklyReport(bool v) {
    final prev = state.weeklyReport;
    state = state.copyWith(weeklyReport: v);
    _patch({'weekly_report': v, 'categories': _categoriesJson(weekly: v)}).then((_) {
      if (ref.mounted && state.error != null) state = state.copyWith(weeklyReport: prev);
    });
  }

  void setMonthlySummary(bool v) {
    final prev = state.monthlySummary;
    state = state.copyWith(monthlySummary: v);
    _patch({'monthly_summary': v, 'categories': _categoriesJson(monthly: v)}).then((_) {
      if (ref.mounted && state.error != null) state = state.copyWith(monthlySummary: prev);
    });
  }

  Map<String, dynamic> _categoriesJson({
    bool? critical,
    bool? watch,
    bool? action,
    bool? opp,
    bool? conn,
    bool? weekly,
    bool? monthly,
  }) {
    return {
      'critical_alerts': critical ?? state.criticalHealthAlerts,
      'watch_items': watch ?? state.watchItems,
      'action_reminders': action ?? state.actionReminders,
      'opportunities': opp ?? state.opportunities,
      'connection_problems': conn ?? state.connectionProblems,
      'weekly_report': weekly ?? state.weeklyReport,
      'monthly_summary': monthly ?? state.monthlySummary,
    };
  }

  // ---- quiet hours ----
  void setQuietHours(String label) {
    final prev = state.quietHours;
    final enabled = label != 'Off';
    final times = NotificationsState._presetTimes[label];
    final start = times?.$1 ?? state.quietHoursStart;
    final end = times?.$2 ?? state.quietHoursEnd;

    state = state.copyWith(
      quietHours: label,
      quietHoursEnabled: enabled,
      quietHoursStart: start,
      quietHoursEnd: end,
    );
    _patch({
      'quiet_hours': {'enabled': enabled, 'start': start, 'end': end},
      'quiet_hours_start': start,
      'quiet_hours_end': end,
    }).then((_) {
      if (ref.mounted && state.error != null) state = state.copyWith(quietHours: prev);
    });
  }

  // ---- recipients ----
  void addRecipient(String email) {
    final trimmed = email.trim();
    if (trimmed.isEmpty || state.alsoSendTo.contains(trimmed)) return;
    final prev = state.alsoSendTo;
    final updated = [...state.alsoSendTo, trimmed];
    state = state.copyWith(alsoSendTo: updated);
    _patch({'report_recipient_emails': updated, 'recipients': updated}).then((_) {
      if (ref.mounted && state.error != null) state = state.copyWith(alsoSendTo: prev);
    });
  }

  void removeRecipient(String email) {
    final prev = state.alsoSendTo;
    final updated = state.alsoSendTo.where((e) => e != email).toList();
    state = state.copyWith(alsoSendTo: updated);
    _patch({'report_recipient_emails': updated, 'recipients': updated}).then((_) {
      if (ref.mounted && state.error != null) state = state.copyWith(alsoSendTo: prev);
    });
  }

  // ---- custom thresholds ----
  void addThreshold() {
    final prev = state.customThresholds;
    final newItem = ThresholdItem(
      id: 'thresh_${DateTime.now().millisecondsSinceEpoch}',
      metric: 'custom',
      operatorSymbol: '<',
      value: 0,
      label: 'New threshold',
    );
    final updated = [...state.customThresholds, newItem];
    state = state.copyWith(customThresholds: updated);
    _patch({'custom_thresholds': updated.map((t) => t.toJson()).toList()}).then((_) {
      if (ref.mounted && state.error != null) state = state.copyWith(customThresholds: prev);
    });
  }

  void updateThreshold(String id, String label) {
    final prev = state.customThresholds;
    final updated = [
      for (final t in state.customThresholds)
        if (t.id == id) t.copyWith(label: label) else t,
    ];
    state = state.copyWith(customThresholds: updated);
    _patch({'custom_thresholds': updated.map((t) => t.toJson()).toList()}).then((_) {
      if (ref.mounted && state.error != null) state = state.copyWith(customThresholds: prev);
    });
  }

  void removeThreshold(String id) {
    final prev = state.customThresholds;
    final updated = state.customThresholds.where((t) => t.id != id).toList();
    state = state.copyWith(customThresholds: updated);
    _patch({'custom_thresholds': updated.map((t) => t.toJson()).toList()}).then((_) {
      if (ref.mounted && state.error != null) state = state.copyWith(customThresholds: prev);
    });
  }
    Future<String> sendTestNotification() async {
    final token = await PrefUtils.getAccessToken();
    if (token == null || token.isEmpty) {
      throw ApiException('Not signed in.');
    }
    final result = await ApiService().sendTestNotification(accessToken: token);
    return result.message;
  }
}

final notificationsProvider =
    NotifierProvider<NotificationsController, NotificationsState>(
  NotificationsController.new,
);