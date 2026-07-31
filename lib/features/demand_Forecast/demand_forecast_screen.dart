import 'package:flutter/material.dart';

import '../../theme/app_theme.dart';
import '../../widgets/app_nav_drawer.dart';
import '../../widgets/customAppbar.dart';
import '../../widgets/gradient_background.dart';
import '../FINANCIAL_Overview/financial_overview_screen.dart';
import '../Scenario_lab/scenario_lab_screen.dart';
import '../business_health/business_health_screen.dart';
import '../business_profile/business_profile_screen.dart';
import '../dashboard/dashboard_screen.dart';
import 'data/demand_forecast_data.dart';
import 'widgets/forecast_full_read_section.dart';
import 'widgets/forecast_headline_card.dart';
import 'widgets/forecast_tab_pills.dart';

/// Demand Forecast screen: This weekend / Rest of month / $ per slice,
/// each with a headline forecast card and "THE FULL READ" breakdown.
class DemandForecastScreen extends StatefulWidget {
  const DemandForecastScreen({super.key});

  @override
  State<DemandForecastScreen> createState() => _DemandForecastScreenState();
}

class _DemandForecastScreenState extends State<DemandForecastScreen> {
  static const _tabs = ['This weekend', 'Rest of month', '\$ / slices'];

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
    if (index == 6) {
      Navigator.of(
        context,
      ).push(MaterialPageRoute(builder: (_) => const BusinessProfileScreen()));
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
        return Column(
          key: const ValueKey('restOfMonth'),
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const ForecastHeadlineCard(data: restOfMonthForecast),
            const SizedBox(height: 20),
            const ForecastFullReadSection(data: restOfMonthForecast),
          ],
        );
      case 2:
        return const _SlicesPlaceholder(key: ValueKey('slices'));
      default:
        return Column(
          key: const ValueKey('thisWeekend'),
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const ForecastHeadlineCard(data: thisWeekendForecast),
            const SizedBox(height: 20),
            const ForecastFullReadSection(data: thisWeekendForecast),
          ],
        );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(
        title: 'Demand Forecast',
        hasUnreadNotifications: true,
      ),
      drawer: AppNavDrawer(
        selectedIndex: 1,
        onItemSelected: _onDrawerItemSelected,
      ),
      body: GradientBackground(
        child: SafeArea(
          top: false,
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 12, 16, 0),
                child: ForecastTabPills(
                  labels: _tabs,
                  selectedIndex: _selectedTab,
                  onSelect: (index) => setState(() => _selectedTab = index),
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

class _SlicesPlaceholder extends StatelessWidget {
  const _SlicesPlaceholder({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.glassDark,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.glassBorder),
      ),
      child: Text(
        '\$ / slices view is still being built.',
        style: AppTextStyles.small,
      ),
    );
  }
}
