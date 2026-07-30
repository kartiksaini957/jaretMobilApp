import 'package:flutter/material.dart';

import '../../widgets/app_nav_drawer.dart';
import '../FINANCIAL_Overview/financial_overview_screen.dart';
import '../business_health/business_health_screen.dart';
import '../dashboard/dashboard_screen.dart';
import '../Scenario_lab/scenario_lab_screen.dart';
import 'theme/demand_colors.dart';
import 'widgets/demand_forecasting_tab.dart';
import 'widgets/demand_tab_bar.dart';
import 'widgets/placeholder_tab.dart';

/// Demand Forecast screen: three tabs (Demand Forecasting / Tracking /
/// Current) over a teal gradient background.
class DemandForecastScreen extends StatefulWidget {
  const DemandForecastScreen({super.key});

  @override
  State<DemandForecastScreen> createState() => _DemandForecastScreenState();
}

class _DemandForecastScreenState extends State<DemandForecastScreen> {
  static const _tabs = ['Demand Forecasting', 'Tracking', 'Current'];

  final _scaffoldKey = GlobalKey<ScaffoldState>();

  int _selectedTab = 0;

  void _onDrawerItemSelected(int index) {
    if (index == 1) return; // Demand Forecast — already here.
    if (index == 2) {
      Navigator.of(context).push(
        MaterialPageRoute(builder: (_) => const FinancialOverviewScreen()),
      );
      return;
    }
    if (index == 3) {
      Navigator.of(
        context,
      ).push(MaterialPageRoute(builder: (_) => const BusinessHealthScreen()));
      return;
    }
    if (index == 5) {
      Navigator.of(
        context,
      ).push(MaterialPageRoute(builder: (_) => const ScenarioLabScreen()));
      return;
    }
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(
        builder: (_) => DashboardScreen(initialDrawerIndex: index),
      ),
    );
  }

  Widget _buildTabContent() {
    switch (_selectedTab) {
      case 1:
        return const PlaceholderTab(
          key: ValueKey('tracking'),
          message: 'Tracking view is still being built.',
        );
      case 2:
        return const PlaceholderTab(
          key: ValueKey('current'),
          message: 'Current view is still being built.',
        );
      default:
        return const DemandForecastingTab(key: ValueKey('forecasting'));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      drawer: AppNavDrawer(
        selectedIndex: 1,
        onItemSelected: _onDrawerItemSelected,
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [DemandColors.bgTop, DemandColors.bgBottom],
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: DemandTabBar(
                  tabs: _tabs,
                  selectedIndex: _selectedTab,
                  onTap: (index) => setState(() => _selectedTab = index),
                  onMenuTap: () => _scaffoldKey.currentState?.openDrawer(),
                ),
              ),
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.fromLTRB(16, 16, 16, 24),
                  child: AnimatedSwitcher(
                    duration: const Duration(milliseconds: 250),
                    child: _buildTabContent(),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
