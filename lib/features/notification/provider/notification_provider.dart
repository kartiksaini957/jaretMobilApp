import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/api_services.dart';
import '../model/alert_notification_model.dart';

class NotificationState {
  const NotificationState({
    this.alerts = const [],
    this.count = 0,
    this.generatedAt = '',
    this.isLoading = true,
    this.errorMessage,
  });

  final List<AlertNotificationItem> alerts;
  final int count;
  final String generatedAt;
  final bool isLoading;
  final String? errorMessage;

  NotificationState copyWith({
    List<AlertNotificationItem>? alerts,
    int? count,
    String? generatedAt,
    bool? isLoading,
    String? errorMessage,
  }) {
    return NotificationState(
      alerts: alerts ?? this.alerts,
      count: count ?? this.count,
      generatedAt: generatedAt ?? this.generatedAt,
      isLoading: isLoading ?? this.isLoading,
      errorMessage: errorMessage,
    );
  }
}

class NotificationController extends Notifier<NotificationState> {
  @override
  NotificationState build() {
    Future.microtask(() => fetchAlerts());
    return const NotificationState(isLoading: true);
  }

  Future<void> fetchAlerts() async {
    state = state.copyWith(isLoading: true, errorMessage: null);
    try {
      final res = await ApiService().getDashboardAlerts();
      state = state.copyWith(
        alerts: res.data.alerts,
        count: res.data.count,
        generatedAt: res.data.generatedAt,
        isLoading: false,
      );
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        errorMessage: ApiException.cleanErrorMessage(e),
      );
    }
  }

  void refresh() => fetchAlerts();
}

final notificationProvider =
    NotifierProvider<NotificationController, NotificationState>(
  NotificationController.new,
);
