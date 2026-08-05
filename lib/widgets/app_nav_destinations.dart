import 'package:flutter/material.dart';

import '../features/FINANCIAL_Overview/financial_overview_screen.dart';
import '../features/business_health/business_health_screen.dart';
import '../features/business_profile/business_profile_screen.dart';
import '../features/dashboard/dashboard_screen.dart';
import '../features/demand_Forecast/demand_forecast_screen.dart';
import '../features/opportunity/ScenarioLab/cenario_lab_screen.dart';
import '../features/opportunity/opportunities_screen.dart';
import '../features/setting/settings_screen.dart';

/// Drawer slot indices, in the order [AppNavDrawer] lists them.
class AppNavIndex {
  AppNavIndex._();

  static const dashboard = 0;
  static const demandForecast = 1;
  static const financialOverview = 2;
  static const businessHealth = 3;
  static const opportunities = 4;
  static const scenarioLab = 5;
  static const businessProfile = 6;
  static const settings = 7;
}

/// Routes a drawer tap from any screen.
///
/// This lived as a copy-pasted `if (index == n)` ladder in all eight screens,
/// each ending in a fall-through to the dashboard. Every copy that forgot a
/// case silently sent the user to the dashboard instead — which is why
/// Settings only opened from two of the eight screens. One table, used
/// everywhere, means a missing case is impossible.
///
/// [currentIndex] is the slot the calling screen occupies, so re-tapping the
/// screen you are already on does nothing.
void openNavDestination(
  BuildContext context,
  int index, {
  required int currentIndex,
}) {
  if (index == currentIndex) return;

  // The dashboard is the root, so it replaces rather than stacks — otherwise
  // Dashboard → X → Dashboard would leave two dashboards on the stack.
  if (index == AppNavIndex.dashboard) {
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(
        builder: (_) => const DashboardScreen(
          initialDrawerIndex: AppNavIndex.dashboard,
        ),
      ),
    );
    return;
  }

  final builder = switch (index) {
    AppNavIndex.demandForecast => (_) => const DemandForecastScreen(),
    AppNavIndex.financialOverview => (_) => const FinancialOverviewScreen(),
    AppNavIndex.businessHealth => (_) => const BusinessHealthScreen(),
    AppNavIndex.opportunities => (_) => const OpportunitiesScreen(),
    AppNavIndex.scenarioLab => (_) => const ScenariooLabScreen(),
    AppNavIndex.businessProfile => (_) => const BusinessProfileScreen(),
    AppNavIndex.settings => (_) => const SettingsScreen(),
    _ => null,
  };
  if (builder == null) return;

  Navigator.of(context).push(MaterialPageRoute(builder: builder));
}
