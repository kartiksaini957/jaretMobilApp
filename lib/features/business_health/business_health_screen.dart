import 'package:flutter/material.dart';

import '../../widgets/app_nav_drawer.dart';
import '../../widgets/customAppbar.dart';
import '../../widgets/gradient_background.dart';
import '../FINANCIAL_Overview/financial_overview_screen.dart';
import '../dashboard/dashboard_screen.dart';
import '../demand_Forecast/demand_forecast_screen.dart';
import '../Scenario_lab/scenario_lab_screen.dart';
import 'theme/business_health_colors.dart';
import 'widgets/full_read_section.dart';
import 'widgets/header_action_button.dart';
import 'widgets/health_category_card.dart';
import 'widgets/narrative_card.dart';
import 'widgets/overall_health_card.dart';
import 'widgets/previous_snapshot_card.dart';
import 'widgets/snapshot_dropdown_pill.dart';

/// Business Health screen: overall score and the category breakdown grid.
class BusinessHealthScreen extends StatefulWidget {
  const BusinessHealthScreen({super.key});

  @override
  State<BusinessHealthScreen> createState() => _BusinessHealthScreenState();
}

class _BusinessHealthScreenState extends State<BusinessHealthScreen> {
  bool _showJan11Snapshot = true;

  void _onDrawerItemSelected(int index) {
    if (index == 3) return; // Business Health — already here.
    if (index == 1) {
      Navigator.of(
        context,
      ).push(MaterialPageRoute(builder: (_) => const DemandForecastScreen()));
      return;
    }
    if (index == 2) {
      Navigator.of(context).push(
        MaterialPageRoute(builder: (_) => const FinancialOverviewScreen()),
      );
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(
        title: 'Business Health',
        hasUnreadNotifications: true,
      ),
      drawer: AppNavDrawer(
        selectedIndex: 3,
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
                Row(
                  children: [
                    const SnapshotDropdownPill(label: 'Snapshot · Feb 11'),
                    const Spacer(),
                    HeaderActionButton(
                      icon: Icons.refresh,
                      label: 'Refresh',
                      onTap: () {},
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                Row(
                  children: [
                    Container(
                      width: 6,
                      height: 6,
                      decoration: const BoxDecoration(
                        color: BusinessHealthColors.dotGood,
                        shape: BoxShape.circle,
                      ),
                    ),
                    const SizedBox(width: 8),
                    const Text(
                      'BUSINESS HEALTH · AS OF FEB 11',
                      style: TextStyle(
                        color: BusinessHealthColors.faintText,
                        fontSize: 11.5,
                        fontWeight: FontWeight.w700,
                        letterSpacing: 0.8,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 14),
                const OverallHealthCard(
                  score: 74,
                  statusLabel: 'Above Average',
                  statusGood: true,
                  deltaText: '+3 since Jan 11',
                  confidenceText:
                      'AI Confidence 92% · Full coverage — QuickBooks '
                      'Online, Square, and your Google reviews are '
                      'connected. Reads are at full strength.',
                ),
                const SizedBox(height: 16),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: HealthCategoryCard(
                        title: 'PROFITABILITY',
                        score: 78,
                        deltaText: '+2',
                        statusText: 'Above Average',
                        statusGood: true,
                        progress: 0.78,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: HealthCategoryCard(
                        title: 'CASH',
                        score: 66,
                        deltaText: '-3',
                        deltaPositive: false,
                        statusText: 'At Average',
                        statusGood: false,
                        progress: 0.66,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: HealthCategoryCard(
                        title: 'GROWTH',
                        score: 81,
                        deltaText: '+4',
                        statusText: 'Above Average',
                        statusGood: true,
                        progress: 0.81,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: HealthCategoryCard(
                        title: 'CUSTOMERS',
                        score: 79,
                        deltaText: '+1',
                        statusText: 'Above Average',
                        statusGood: true,
                        progress: 0.79,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: HealthCategoryCard(
                        title: 'RISK',
                        score: 68,
                        deltaText: '-2',
                        deltaPositive: false,
                        statusText: 'At Average',
                        statusGood: false,
                        progress: 0.68,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: HealthCategoryCard(
                        title: 'PEERS',
                        score: 71,
                        statusText: 'Brooklyn slice-shop pool',
                        progress: 0.71,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                const NarrativeCard(
                  text:
                      'Weekend dinner is doing the carrying — Friday and '
                      'Saturday are running 14% ahead of last February and '
                      'revenue is pacing 9.4% ahead of January. The '
                      'pressure point is cheese: an 8% mozzarella increase '
                      'since December has taken 1.1 points of margin, and '
                      'the 7.5-month cash cushion now sits below the '
                      '10-month peer median with the summer slow weeks '
                      'ahead.',
                ),
                if (_showJan11Snapshot) ...[
                  const SizedBox(height: 16),
                  PreviousSnapshotCard(
                    label: 'JAN 11 SNAPSHOT',
                    score: 71,
                    statusLabel: 'Above Average',
                    statusGood: true,
                    confidenceText:
                        'AI Confidence 89% · Full coverage — QuickBooks '
                        'Online, Square, and your Google reviews are '
                        'connected.',
                    onDismiss: () =>
                        setState(() => _showJan11Snapshot = false),
                    narrative:
                        'January was steady rather than strong — weekend '
                        'dinner held the month near \$101,300 while '
                        'weekday lunch leaned on the school-slice trade. '
                        'Cheese prices had just started creeping and '
                        'Friday dough sold out once, both small enough '
                        'then to watch rather than act on.',
                    categories: const [
                      HealthCategoryCard(
                        title: 'PROFITABILITY',
                        score: 76,
                        statusText: 'Above Average',
                        statusGood: true,
                        progress: 0.76,
                      ),
                      HealthCategoryCard(
                        title: 'CASH',
                        score: 69,
                        statusText: 'At Average',
                        statusGood: false,
                        progress: 0.69,
                      ),
                      HealthCategoryCard(
                        title: 'GROWTH',
                        score: 77,
                        statusText: 'Above Average',
                        statusGood: true,
                        progress: 0.77,
                      ),
                      HealthCategoryCard(
                        title: 'CUSTOMERS',
                        score: 78,
                        statusText: 'Above Average',
                        statusGood: true,
                        progress: 0.78,
                      ),
                      HealthCategoryCard(
                        title: 'RISK',
                        score: 70,
                        statusText: 'At Average',
                        statusGood: false,
                        progress: 0.70,
                      ),
                      HealthCategoryCard(
                        title: 'PEERS',
                        score: 70,
                        statusText: 'Brooklyn slice-shop pool',
                        progress: 0.70,
                      ),
                    ],
                  ),
                ],
                const SizedBox(height: 20),
                const FullReadSection(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
