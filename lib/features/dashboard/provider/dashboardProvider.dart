import 'dart:async';
import 'package:flutter_application_1/features/dashboard/model/dashboardTabsModel.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';
import '../../../core/api_services.dart';
import '../../../utils/pref_utils.dart';
import '../model/dashboardModel.dart';
import '../model/dashboardNumber.dart';
import '../model/dashboardNumberDetail.dart' as kpi_detail;

class DashboardRemindersNotifier
    extends StateNotifier<AsyncValue<List<ActionItem>>> {
  DashboardRemindersNotifier() : super(const AsyncValue.loading()) {
    fetch();
  }

  Future<void> fetch() async {
    state = const AsyncValue.loading();
    try {
      final token = await PrefUtils.getAccessToken();
      if (token == null || token.isEmpty) {
        throw ApiException('Not signed in.');
      }
      final items = await ApiService().getDashboardReminders(
        accessToken: token,
      );
      state = AsyncValue.data(items);
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }

  Future<void> refresh() => fetch();
}

final dashboardRemindersProvider =
    StateNotifierProvider<
      DashboardRemindersNotifier,
      AsyncValue<List<ActionItem>>
    >((ref) {
      return DashboardRemindersNotifier();
    });

class DashboardInsightsNotifier
    extends StateNotifier<AsyncValue<BusinessHealthResponse>> {
  DashboardInsightsNotifier() : super(const AsyncValue.loading()) {
    fetch();
  }

  Future<void> fetch() async {
    state = const AsyncValue.loading();
    try {
      final token = await PrefUtils.getAccessToken();
      if (token == null || token.isEmpty) {
        throw ApiException('Not signed in.');
      }
      final response = await ApiService().getDashboardInsights(
        accessToken: token,
      );
      state = AsyncValue.data(response);
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }

  Future<void> refresh() => fetch();
}

final dashboardInsightsProvider =
    StateNotifierProvider<
      DashboardInsightsNotifier,
      AsyncValue<BusinessHealthResponse>
    >((ref) {
      return DashboardInsightsNotifier();
    });

class DashboardKpisNotifier
    extends StateNotifier<AsyncValue<DashboardKpiResponse>> {
  DashboardKpisNotifier() : super(const AsyncValue.loading()) {
    fetch();
  }

  Future<void> fetch() async {
    state = const AsyncValue.loading();
    try {
      final token = await PrefUtils.getAccessToken();
      if (token == null || token.isEmpty) {
        throw ApiException('Not signed in.');
      }
      final response = await ApiService().getDashboardKpis(accessToken: token);
      state = AsyncValue.data(response);
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }

  Future<void> refresh() => fetch();
}

final dashboardKpisProvider =
    StateNotifierProvider<
      DashboardKpisNotifier,
      AsyncValue<DashboardKpiResponse>
    >((ref) {
      return DashboardKpisNotifier();
    });

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

final kpiExplainProvider =
    FutureProvider.family<kpi_detail.dashboardNumberDetail, KpiExplainArgs>((
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
