import 'package:flutter_application_1/features/dashboard/model/dashboardTabsModel.dart';
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
final dashboardInsightsProvider =
    FutureProvider.autoDispose<BusinessHealthResponse>((ref) async {
  // Get saved access token
  final token = await PrefUtils.getAccessToken();

  // If user is not logged in
  if (token == null || token.isEmpty) {
    throw ApiException('Not signed in.');
  }

  // Call API
  return ApiService().getDashboardInsights(
    accessToken: token,
  );
});
