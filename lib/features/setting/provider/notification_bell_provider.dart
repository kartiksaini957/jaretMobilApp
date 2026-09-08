import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../theme/settings_colors.dart';
enum NotificationTarget { businessHealth, opportunities, none }
enum NotificationSeverity { critical, watch, good, neutral }
extension NotificationSeverityColor on NotificationSeverity {
  Color get dotColor => switch (this) {
    NotificationSeverity.critical => SettingsColors.critical,
    NotificationSeverity.watch => SettingsColors.warning,
    NotificationSeverity.good => SettingsColors.statusConnected,
    NotificationSeverity.neutral => SettingsColors.statusNotConnected,
  };
}

class AppNotification {
  const AppNotification({
    required this.id,
    required this.severity,
    required this.title,
    required this.meta,
    this.target = NotificationTarget.none,
    this.read = false,
  });

  final String id;
  final NotificationSeverity severity;
  final String title;
  final String meta;
  final NotificationTarget target;
  final bool read;

  AppNotification copyWith({bool? read}) => AppNotification(
    id: id,
    severity: severity,
    title: title,
    meta: meta,
    target: target,
    read: read ?? this.read,
  );
}
class NotificationBellController extends Notifier<List<AppNotification>> {
  @override
  List<AppNotification> build() => const [
    AppNotification(
      id: 'cash-threshold',
      severity: NotificationSeverity.critical,
      title:
          'Cash dipped below your \$10,000 threshold — \$9,400 this morning.',
      meta: 'Critical · 2h ago · opens Business Health',
      target: NotificationTarget.businessHealth,
    ),
    AppNotification(
      id: 'lot-construction',
      severity: NotificationSeverity.watch,
      title:
          'New watch area: Friday lot construction may hit lunch revenue '
          'through August.',
      meta: 'Watch item · yesterday · opens Business Health',
      target: NotificationTarget.businessHealth,
    ),
    AppNotification(
      id: 'bayfest',
      severity: NotificationSeverity.good,
      title:
          'New opportunity cleared your bar: Bayfest vendor slots open '
          'Tuesday.',
      meta: 'Opportunity · 2d ago · opens Opportunities',
      target: NotificationTarget.opportunities,
    ),
    AppNotification(
      id: 'qbo-recovered',
      severity: NotificationSeverity.neutral,
      title: 'QuickBooks sync recovered after 40 minutes.',
      meta: 'Connection · 3d ago',
      read: true,
    ),
  ];
  void markRead(String id) {
    state = [
      for (final n in state)
        if (n.id == id) n.copyWith(read: true) else n,
    ];
  }

  void markAllRead() {
    state = [for (final n in state) n.copyWith(read: true)];
  }
}

final notificationBellProvider =
    NotifierProvider<NotificationBellController, List<AppNotification>>(
      NotificationBellController.new,
    );

final unreadNotificationCountProvider = Provider<int>((ref) {
  return ref.watch(notificationBellProvider).where((n) => !n.read).length;
});
