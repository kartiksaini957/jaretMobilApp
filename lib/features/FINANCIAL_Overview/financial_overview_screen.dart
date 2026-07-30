import 'package:flutter/material.dart';

import '../../widgets/app_nav_drawer.dart';
import '../business_health/business_health_screen.dart';
import '../dashboard/dashboard_screen.dart';
import '../demand_Forecast/demand_forecast_screen.dart';
import '../Scenario_lab/scenario_lab_screen.dart';
import 'theme/financial_colors.dart';
import 'widgets/ai_analysis_card.dart';
import 'widgets/ask_ai_chat_card.dart';
import 'widgets/expense_breakdown_card.dart';
import 'widgets/key_metrics_grid.dart';
import 'widgets/overdue_invoices_card.dart';
import 'widgets/pressing_alert_card.dart';
import 'widgets/profitability_status_card.dart';

/// Financial Overview screen: profitability status, overdue invoices,
/// key metrics, AI analysis/chat, and expense breakdown.
class FinancialOverviewScreen extends StatefulWidget {
  const FinancialOverviewScreen({super.key});

  @override
  State<FinancialOverviewScreen> createState() =>
      _FinancialOverviewScreenState();
}

class _FinancialOverviewScreenState extends State<FinancialOverviewScreen> {
  final _scaffoldKey = GlobalKey<ScaffoldState>();

  static const _metrics = [
    MetricData(
      label: 'GROSS MARGIN',
      value: '38.0%',
      statusLabel: 'Above Average',
      statusColor: FinancialColors.statusGood,
    ),
    MetricData(
      label: 'NET MARGIN',
      value: '13.8%',
      statusLabel: 'At Average',
      statusColor: FinancialColors.statusNeutral,
    ),
    MetricData(
      label: 'OPEX RATIO',
      value: '28.0%',
      statusLabel: 'At Average',
      statusColor: FinancialColors.statusNeutral,
    ),
    MetricData(
      label: 'CURRENT RATIO',
      value: '1.60',
      statusLabel: 'Above Average',
      statusColor: FinancialColors.statusGood,
    ),
    MetricData(
      label: 'QUICK RATIO',
      value: '1.30',
      statusLabel: 'Above Average',
      statusColor: FinancialColors.statusGood,
    ),
    MetricData(
      label: 'AR DAYS (DSO)',
      value: '28d',
      statusLabel: 'Below Average',
      statusColor: FinancialColors.statusBad,
    ),
    MetricData(
      label: 'AP DAYS (DPO)',
      value: '32d',
      statusLabel: 'At Average',
      statusColor: FinancialColors.statusNeutral,
    ),
    MetricData(
      label: 'CASH CONV. CYCLE',
      value: '21d',
      statusLabel: 'At Average',
      statusColor: FinancialColors.statusNeutral,
    ),
  ];

  static const _expenseSlices = [
    ExpenseSlice(label: 'Labor', percent: 38, amount: '\$69,312'),
    ExpenseSlice(label: 'Ingredients', percent: 27, amount: '\$49,248'),
    ExpenseSlice(label: 'Rent & Utilities', percent: 15, amount: '\$27,360'),
    ExpenseSlice(label: 'Marketing', percent: 10, amount: '\$18,240'),
    ExpenseSlice(label: 'Other', percent: 10, amount: '\$18,240'),
  ];

  void _onDrawerItemSelected(int index) {
    if (index == 2) return; // Financial Overview — already here.
    if (index == 1) {
      Navigator.of(
        context,
      ).push(MaterialPageRoute(builder: (_) => const DemandForecastScreen()));
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      drawer: AppNavDrawer(
        selectedIndex: 2,
        onItemSelected: _onDrawerItemSelected,
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [FinancialColors.bgTop, FinancialColors.bgBottom],
          ),
        ),
        child: SafeArea(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(4, 4, 16, 8),
                child: Row(
                  children: [
                    IconButton(
                      onPressed: () => _scaffoldKey.currentState?.openDrawer(),
                      icon: const Icon(
                        Icons.menu,
                        color: FinancialColors.white,
                      ),
                    ),
                    const SizedBox(width: 4),
                    const Text(
                      'FINANCIAL OVERVIEW',
                      style: TextStyle(
                        color: FinancialColors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.w800,
                        letterSpacing: 0.4,
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.fromLTRB(16, 4, 16, 24),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const ProfitabilityStatusCard(),
                      const SizedBox(height: 16),
                      const OverdueInvoicesCard(),
                      const SizedBox(height: 16),
                      const PressingAlertCard(),
                      const SizedBox(height: 22),
                      const Text(
                        'KEY METRICS',
                        style: TextStyle(
                          color: FinancialColors.white,
                          fontSize: 17,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                      const SizedBox(height: 12),
                      const KeyMetricsGrid(metrics: _metrics),
                      const SizedBox(height: 16),
                      const AiAnalysisCard(title: 'Gross Margin'),
                      const SizedBox(height: 16),
                      const AskAiChatCard(kpiName: 'Gross Margin'),
                      const SizedBox(height: 22),
                      const Text(
                        'Expense Breakdown',
                        style: TextStyle(
                          color: FinancialColors.white,
                          fontSize: 17,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                      const SizedBox(height: 12),
                      const ExpenseBreakdownCard(slices: _expenseSlices),
                    ],
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
