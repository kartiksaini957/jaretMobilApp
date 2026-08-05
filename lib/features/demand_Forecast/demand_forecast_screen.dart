import 'package:flutter/material.dart';
import 'package:flutter_application_1/features/opportunity/ScenarioLab/cenario_lab_screen.dart';
import 'package:flutter_application_1/features/opportunity/opportunities_screen.dart';

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
import '../../widgets/app_nav_destinations.dart';

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
    openNavDestination(context, index, currentIndex: AppNavIndex.demandForecast);
  }

  Widget _buildTabContent() {
    switch (_selectedTab) {
      case 1:
        return Column(
          key: const ValueKey('restOfMonth'),
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const ForecastHeadlineCard(data: restOfMonthForecast),

            const SizedBox(height: 8),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: const Color.fromARGB(51, 13, 61, 85),
                borderRadius: BorderRadius.circular(16),
                // border: Border.all(color: AppColors.glassBorder),
              ),
              child: RichText(
                text: TextSpan(
                  style: AppTextStyles.small.copyWith(
                    color: AppColors.mutedText,
                    height: 1.5,
                  ),
                  children: [
                    TextSpan(
                      text: '⚡ Biggest swing factor: ',
                      style: AppTextStyles.body.copyWith(
                        color: Colors.white,
                        fontSize: 13,
                      ),
                    ),
                    TextSpan(
                      text:
                          " Friday dough. Scale Thursday's prep past the ≈\$5,200 cap and the weekend runs toward \$15,000; sell out by 8pm again — it's happened twice this month — and ≈\$330 walks (≈17 orders at your \$19 ticket), nearer \$14,400.",
                      style: AppTextStyles.body.copyWith(color: Colors.white),
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(height: 12),
            // const SizedBox(height: 20),
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
            const SizedBox(height: 8),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: const Color.fromARGB(51, 13, 61, 85),
                borderRadius: BorderRadius.circular(16),
                // border: Border.all(color: AppColors.glassBorder),
              ),
              child: RichText(
                text: TextSpan(
                  style: AppTextStyles.small.copyWith(
                    color: AppColors.mutedText,
                    height: 1.5,
                  ),
                  children: [
                    TextSpan(
                      text: '⚡ Biggest swing factor: ',
                      style: AppTextStyles.body.copyWith(
                        color: Colors.white,
                        fontSize: 13,
                      ),
                    ),
                    TextSpan(
                      text:
                          " Friday dough. Scale Thursday's prep past the ≈\$5,200 cap and the weekend runs toward \$15,000; sell out by 8pm again — it's happened twice this month — and ≈\$330 walks (≈17 orders at your \$19 ticket), nearer \$14,400.",
                      style: AppTextStyles.body.copyWith(color: Colors.white),
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(height: 12),

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
