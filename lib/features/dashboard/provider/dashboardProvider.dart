import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/api_services.dart';
import '../../../utils/pref_utils.dart';
import '../model/dashboardModel.dart';

/// Upcoming reminders shown on the dashboard — fetched from
/// `GET /api/dashboard/reminders` using the saved access token. Re-runs
/// whenever the dashboard rebuilds it (e.g. pull-to-refresh via
/// `ref.refresh(dashboardRemindersProvider)`).
final dashboardRemindersProvider = FutureProvider.autoDispose<List<ActionItem>>(
  (ref) async {
    final token = await PrefUtils.getAccessToken();
    if (token == null || token.isEmpty) {
      throw ApiException('Not signed in.');
    }
    return ApiService().getDashboardReminders(accessToken: token);
  },
);
