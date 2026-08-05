import 'package:flutter/material.dart';
import 'package:flutter_application_1/features/opportunity/ScenarioLab/cenario_lab_screen.dart';
import 'package:flutter_application_1/features/opportunity/opportunities_screen.dart';

import '../../theme/app_theme.dart';
import '../../widgets/app_nav_drawer.dart';
import '../../widgets/customAppbar.dart';
import '../../widgets/gradient_background.dart';
import '../Scenario_lab/scenario_lab_screen.dart';
import '../business_health/business_health_screen.dart';
import '../business_profile/business_profile_screen.dart';
import '../dashboard/dashboard_screen.dart';
import '../demand_Forecast/demand_forecast_screen.dart';
import 'data/financial_overview_data.dart';
import 'widgets/financial_category_tabs.dart';
import 'widgets/financial_metric_detail_card.dart';
import 'widgets/financial_metric_pills.dart';
import 'widgets/financial_status_banner.dart';
import 'widgets/expenses_overview_tab.dart';
import 'widgets/home_overview_tab.dart';
import 'widgets/pressing_now_tab.dart';
import '../../widgets/app_nav_destinations.dart';

/// Financial Overview: a status banner, category tabs (Home / Pressing
/// now / Ratios / Expenses), and — on Ratios — a metric pill row driving
/// a detailed metric card (trend, peer comparison, drivers, actions, AI).
class FinancialOverviewScreen extends StatefulWidget {
  const FinancialOverviewScreen({super.key});

  @override
  State<FinancialOverviewScreen> createState() =>
      _FinancialOverviewScreenState();
}

class _FinancialOverviewScreenState extends State<FinancialOverviewScreen> {
  static const _homeCategoryIndex = 0;
  static const _pressingNowCategoryIndex = 1;
  static const _ratiosCategoryIndex = 2;
  static const _expensesCategoryIndex = 3;

  int _selectedCategory = _homeCategoryIndex;
  int _selectedMetric = 0;

  void _onDrawerItemSelected(int index) {
    openNavDestination(context, index, currentIndex: AppNavIndex.financialOverview);
  }

  Widget _buildCategoryContent() {
    if (_selectedCategory == _homeCategoryIndex) {
      return HomeOverviewTab(
        key: const ValueKey('home'),
        onViewPressingTap: () =>
            setState(() => _selectedCategory = _pressingNowCategoryIndex),
      );
    }
    if (_selectedCategory == _pressingNowCategoryIndex) {
      return const PressingNowTab(key: ValueKey('pressingNow'));
    }
    if (_selectedCategory == _ratiosCategoryIndex) {
      return Column(
        key: const ValueKey('ratios'),
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          FinancialMetricPills(
            metrics: metricDetails,
            selectedIndex: _selectedMetric,
            onSelect: (index) => setState(() => _selectedMetric = index),
          ),
          const SizedBox(height: 16),
          FinancialMetricDetailCard(metric: metricDetails[_selectedMetric]),
        ],
      );
    }
    if (_selectedCategory == _expensesCategoryIndex) {
      return const ExpensesOverviewTab(key: ValueKey('expenses'));
    }

    final label = financialCategories[_selectedCategory];
    return Container(
      key: ValueKey(label),
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.glassDark,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.glassBorder),
      ),
      child: Text(
        '$label view is still being built.',
        style: AppTextStyles.small,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(
        title: 'Financial Overview',
        hasUnreadNotifications: true,
      ),
      drawer: AppNavDrawer(
        selectedIndex: 2,
        onItemSelected: _onDrawerItemSelected,
      ),
      body: GradientBackground(
        child: SafeArea(
          top: false,
          child: SingleChildScrollView(
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const FinancialStatusBanner(
                  headline: "You're profitable — 1 thing needs you this week.",
                  freshnessLabel: 'Updated 2h ago · QuickBooks + Square synced',
                ),
                const SizedBox(height: 14),
                FinancialCategoryTabs(
                  labels: financialCategories,
                  selectedIndex: _selectedCategory,
                  onSelect: (index) =>
                      setState(() => _selectedCategory = index),
                ),
                const SizedBox(height: 12),
                AnimatedSwitcher(
                  duration: const Duration(milliseconds: 300),
                  child: _buildCategoryContent(),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
