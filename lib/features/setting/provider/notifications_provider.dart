import 'package:flutter_riverpod/flutter_riverpod.dart';

class ThresholdItem {
  const ThresholdItem({required this.id, required this.label});

  final String id;
  final String label;

  ThresholdItem copyWith({String? label}) =>
      ThresholdItem(id: id, label: label ?? this.label);
}

class NotificationsState {
  const NotificationsState({
    this.pushEnabled = true,
    this.inAppEnabled = true,
    this.emailEnabled = true,
    this.escalateAfter = 'After 2 days',
    this.criticalHealthAlerts = true,
    this.watchItems = false,
    this.actionReminders = false,
    this.opportunities = true,
    this.connectionProblems = true,
    this.weeklyReport = true,
    this.monthlySummary = true,
    this.quietHours = '9 PM – 7 AM',
    this.alsoSendTo = const [],
    this.customThresholds = const [
      ThresholdItem(id: 'cash', label: 'Cash < \$10k'),
      ThresholdItem(id: 'permit', label: 'Permit expires < 30 days'),
    ],
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
  final String quietHours;
  final List<String> alsoSendTo;
  final List<ThresholdItem> customThresholds;

  static const escalateOptions = [
    'After 1 day',
    'After 2 days',
    'After 3 days',
    'Never',
  ];
  static const quietHoursOptions = [
    '9 PM – 7 AM',
    '10 PM – 6 AM',
    '11 PM – 7 AM',
    'Off',
  ];

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
    List<String>? alsoSendTo,
    List<ThresholdItem>? customThresholds,
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
      alsoSendTo: alsoSendTo ?? this.alsoSendTo,
      customThresholds: customThresholds ?? this.customThresholds,
    );
  }
}

/// Notifications tab: delivery channels, which alerts fire, quiet hours,
/// extra recipients, and custom numeric thresholds.
class NotificationsController extends Notifier<NotificationsState> {
  @override
  NotificationsState build() => const NotificationsState();

  void setPushEnabled(bool v) => state = state.copyWith(pushEnabled: v);
  void setInAppEnabled(bool v) => state = state.copyWith(inAppEnabled: v);
  void setEmailEnabled(bool v) => state = state.copyWith(emailEnabled: v);
  void setEscalateAfter(String v) => state = state.copyWith(escalateAfter: v);
  void setCriticalHealthAlerts(bool v) =>
      state = state.copyWith(criticalHealthAlerts: v);
  void setWatchItems(bool v) => state = state.copyWith(watchItems: v);
  void setActionReminders(bool v) =>
      state = state.copyWith(actionReminders: v);
  void setOpportunities(bool v) => state = state.copyWith(opportunities: v);
  void setConnectionProblems(bool v) =>
      state = state.copyWith(connectionProblems: v);
  void setWeeklyReport(bool v) => state = state.copyWith(weeklyReport: v);
  void setMonthlySummary(bool v) => state = state.copyWith(monthlySummary: v);
  void setQuietHours(String v) => state = state.copyWith(quietHours: v);

  void addRecipient(String email) {
    final trimmed = email.trim();
    if (trimmed.isEmpty || state.alsoSendTo.contains(trimmed)) return;
    state = state.copyWith(alsoSendTo: [...state.alsoSendTo, trimmed]);
  }

  void removeRecipient(String email) {
    state = state.copyWith(
      alsoSendTo: state.alsoSendTo.where((e) => e != email).toList(),
    );
  }

  void addThreshold() {
    final id = 'threshold_${state.customThresholds.length}_${DateTime.now().microsecondsSinceEpoch}';
    state = state.copyWith(
      customThresholds: [
        ...state.customThresholds,
        ThresholdItem(id: id, label: 'New threshold'),
      ],
    );
  }

  void updateThreshold(String id, String label) {
    state = state.copyWith(
      customThresholds: [
        for (final t in state.customThresholds)
          if (t.id == id) t.copyWith(label: label) else t,
      ],
    );
  }

  void removeThreshold(String id) {
    state = state.copyWith(
      customThresholds:
          state.customThresholds.where((t) => t.id != id).toList(),
    );
  }
}

final notificationsProvider =
    NotifierProvider<NotificationsController, NotificationsState>(
      NotificationsController.new,
    );
