import 'package:flutter/material.dart';

import '../../widgets/app_nav_drawer.dart';
import '../FINANCIAL_Overview/financial_overview_screen.dart';
import '../business_health/business_health_screen.dart';
import '../dashboard/dashboard_screen.dart';
import '../demand_Forecast/demand_forecast_screen.dart';
import 'scenario_lab_state.dart';
import 'theme/scenario_lab_colors.dart';
import 'widgets/assumptions_section.dart';
import 'widgets/cash_chart_card.dart';
import 'widgets/category_section.dart';
import 'widgets/empty_state_card.dart';
import 'widgets/follow_up_input_bar.dart';
import 'widgets/key_numbers_grid.dart';
import 'widgets/question_bubble.dart';
import 'widgets/scenario_actions.dart';
import 'widgets/shimmer_box.dart';
import 'widgets/state_tabs.dart';
import 'widgets/verdict_card.dart';

/// Scenario Lab — "what-if" scenario analysis. The Results/Empty/Loading
/// pill at the top lets you preview each state; asking a question (or
/// tapping a suggestion) drives the same flow: Empty -> Loading -> Results.
class ScenarioLabScreen extends StatefulWidget {
  const ScenarioLabScreen({super.key});

  @override
  State<ScenarioLabScreen> createState() => _ScenarioLabScreenState();
}

class _ScenarioLabScreenState extends State<ScenarioLabScreen> {
  final _scaffoldKey = GlobalKey<ScaffoldState>();

  ScenarioViewState _viewState = ScenarioViewState.empty;
  String _question =
      'What if I move my food truck to a storefront on Government St?';

  void _ask(String question) {
    setState(() {
      _question = question;
      _viewState = ScenarioViewState.loading;
    });
    Future.delayed(const Duration(milliseconds: 1400), () {
      if (!mounted) return;
      setState(() => _viewState = ScenarioViewState.results);
    });
  }

  void _onDrawerItemSelected(int index) {
    if (index == 5) return; // Scenario Lab — already here.
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
    if (index == 3) {
      Navigator.of(
        context,
      ).push(MaterialPageRoute(builder: (_) => const BusinessHealthScreen()));
      return;
    }
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(
        builder: (_) => DashboardScreen(initialDrawerIndex: index),
      ),
    );
  }

  Widget _buildBody() {
    switch (_viewState) {
      case ScenarioViewState.empty:
        return _EmptyBody(onAsk: _ask);
      case ScenarioViewState.loading:
        return _LoadingBody(question: _question);
      case ScenarioViewState.results:
        return _ResultsBody(question: _question, onAsk: _ask);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      drawer: AppNavDrawer(
        selectedIndex: 5,
        onItemSelected: _onDrawerItemSelected,
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [ScenarioLabColors.bgTop, ScenarioLabColors.bgBottom],
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(8, 8, 16, 8),
                child: Row(
                  children: [
                    IconButton(
                      onPressed: () => _scaffoldKey.currentState?.openDrawer(),
                      icon: const Icon(
                        Icons.menu,
                        color: ScenarioLabColors.white,
                      ),
                    ),
                    const Spacer(),
                    StateTabs(
                      value: _viewState,
                      onChanged: (state) => setState(() => _viewState = state),
                    ),
                  ],
                ),
              ),
              Expanded(child: _buildBody()),
            ],
          ),
        ),
      ),
    );
  }
}

class _EmptyBody extends StatelessWidget {
  const _EmptyBody({required this.onAsk});

  final ValueChanged<String> onAsk;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          child: SingleChildScrollView(
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
            child: EmptyStateCard(onSuggestionTap: onAsk),
          ),
        ),
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
          child: FollowUpInputBar(
            hintText: 'Type any business scenario...',
            onSubmit: onAsk,
          ),
        ),
      ],
    );
  }
}

class _LoadingBody extends StatelessWidget {
  const _LoadingBody({required this.question});

  final String question;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          QuestionBubble(text: question),
          const SizedBox(height: 16),
          const ShimmerBox(height: 100),
          const SizedBox(height: 12),
          const ShimmerBox(height: 100),
          const SizedBox(height: 12),
          const ShimmerBox(height: 100),
        ],
      ),
    );
  }
}

class _ResultsBody extends StatelessWidget {
  const _ResultsBody({required this.question, required this.onAsk});

  final String question;
  final ValueChanged<String> onAsk;

  static const _assumptions = [
    AssumptionData(label: 'Monthly rent', value: '\$2,400', source: 'Listing'),
    AssumptionData(
      label: 'Build-out cost',
      value: '\$16,000',
      source: 'Contractor quote',
    ),
    AssumptionData(
      label: 'Avg ticket',
      value: '\$14.50',
      source: 'Last 90 days',
    ),
    AssumptionData(
      label: 'Catering ramp',
      value: 'Month 3',
      source: 'Estimate',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          child: SingleChildScrollView(
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                QuestionBubble(text: question),
                const SizedBox(height: 16),
                const VerdictCard(
                  headline: 'Proceed with caution',
                  pills: [
                    VerdictPill(
                      label: 'Decision: Conditional go',
                      color: ScenarioLabColors.statusInfo,
                    ),
                    VerdictPill(
                      label: 'Risk: Medium',
                      color: ScenarioLabColors.statusWarn,
                    ),
                    VerdictPill(
                      label: 'Confidence: Moderate',
                      color: ScenarioLabColors.statusWarn,
                    ),
                  ],
                  body:
                      'The move pencils out to roughly 2.4× ROI over 24 '
                      'months and break-even by month 5 — but cash dips to '
                      '-\$4.1k in month 2, so secure a small credit buffer '
                      'and lock catering accounts before signing.',
                  warning:
                      'Worst-case cash goes negative in month 2. A \$10k '
                      'line of credit removes the risk.',
                ),
                const SizedBox(height: 20),
                const KeyNumbersGrid(
                  numbers: [
                    KeyNumberData(
                      label: 'SETUP COST RANGE',
                      value: '\$18k-24k',
                      note: 'From assumptions',
                    ),
                    KeyNumberData(
                      label: 'NEW MONTHLY FIXED',
                      value: '\$3,200',
                      note: 'Lease + staff',
                      dotColor: ScenarioLabColors.statusWarn,
                    ),
                    KeyNumberData(
                      label: 'BREAK-EVEN MONTH',
                      value: 'Month 5',
                      note: 'Projected',
                      dotColor: ScenarioLabColors.statusGood,
                    ),
                    KeyNumberData(
                      label: 'CASH AT LOWEST POINT',
                      value: '-\$4,100',
                      note: 'Month 2 (worst)',
                      dotColor: ScenarioLabColors.statusBad,
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                const CategorySection(),
                const SizedBox(height: 20),
                const AssumptionsSection(assumptions: _assumptions),
                const SizedBox(height: 16),
                const CashChartCard(),
                const SizedBox(height: 20),
                ScenarioActionsRow(
                  onSave: () => showSaveScenarioDialog(
                    context,
                    initialName: 'Restaurant Transition Mobile AL',
                    onConfirm: (_) {},
                  ),
                  onAdjust: () {},
                  onNewScenario: () => showNewScenarioDialog(
                    context,
                    onSaveFirst: () => showSaveScenarioDialog(
                      context,
                      initialName: 'Restaurant Transition Mobile AL',
                      onConfirm: (_) {},
                    ),
                    onStartFresh: () {},
                  ),
                ),
              ],
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
          child: FollowUpInputBar(
            hintText: 'Ask a follow-up about this scenario...',
            onSubmit: onAsk,
          ),
        ),
      ],
    );
  }
}
