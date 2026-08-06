import 'dart:async';

import 'package:flutter_application_1/features/dashboard/model/dashboardTabsModel.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
// `KeepAliveLink` lives here rather than in the main barrel file.
import 'package:flutter_riverpod/misc.dart';

import '../../../core/api_services.dart';
import '../../../utils/pref_utils.dart';
import '../model/dashboardModel.dart';
import '../model/dashboardNumber.dart';
// Prefixed: this model declares its own `ActionItem`, which clashes with the
// reminders one in dashboardModel.dart.
import '../model/dashboardNumberDetail.dart' as kpi_detail;

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
/// Holds an autoDispose provider's value for [duration] after its last
/// listener goes away, instead of tearing it down immediately. Leaving a
/// screen and coming back inside that window reuses the cached response
/// rather than re-hitting the API.
KeepAliveLink _cacheFor(Ref ref, Duration duration) {
  final link = ref.keepAlive();
  Timer? timer;

  ref.onDispose(() => timer?.cancel());
  // No listeners left — start the countdown to disposal.
  ref.onCancel(() => timer = Timer(duration, link.close));
  // Someone re-subscribed before it expired — call the countdown off.
  ref.onResume(() {
    timer?.cancel();
    timer = null;
  });

  return link;
}

final dashboardKpisProvider = FutureProvider.autoDispose<DashboardKpiResponse>((
  ref,
) async {
  // Cached for a minute, so flipping back to the Numbers tab doesn't re-hit
  // the API. Failures drop out of the cache immediately (see below) so the
  // next tap is a real retry.
  final link = _cacheFor(ref, const Duration(minutes: 1));

  try {
    // Get saved access token
    final token = await PrefUtils.getAccessToken();

    // If user is not logged in
    if (token == null || token.isEmpty) {
      throw ApiException('Not signed in.');
    }

    // Call API
    return await ApiService().getDashboardKpis(accessToken: token);
  } catch (_) {
    link.close();
    rethrow;
  }
});

/// Identifies one KPI for `POST /dashboard/kpi-explain`. Doubles as the
/// family key, so it needs value equality — otherwise every rebuild of the
/// sheet would key a fresh provider and re-fire the request.
class KpiExplainArgs {
  const KpiExplainArgs({
    required this.kpiName,
    required this.currentValue,
    required this.priorValue,
    required this.formatType,
  });

  final String kpiName;
  final num currentValue;
  final num priorValue;
  final String formatType;

  @override
  bool operator ==(Object other) =>
      other is KpiExplainArgs &&
      other.kpiName == kpiName &&
      other.currentValue == currentValue &&
      other.priorValue == priorValue &&
      other.formatType == formatType;

  @override
  int get hashCode =>
      Object.hash(kpiName, currentValue, priorValue, formatType);
}

/// Explanation for a single KPI. Only fetched when a stat tile is tapped,
/// since the metric sheet is what watches it.
final kpiExplainProvider = FutureProvider.autoDispose
    .family<kpi_detail.dashboardNumberDetail, KpiExplainArgs>((
      ref,
      args,
    ) async {
      final token = await PrefUtils.getAccessToken();

      if (token == null || token.isEmpty) {
        throw ApiException('Not signed in.');
      }

      return ApiService().getKpiExplain(
        accessToken: token,
        kpiName: args.kpiName,
        currentValue: args.currentValue,
        priorValue: args.priorValue,
        formatType: args.formatType,
      );
    });
