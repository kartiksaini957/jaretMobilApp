import 'package:flutter/material.dart';
import 'package:flutter_application_1/widgets/gradient_background.dart';

import '../../widgets/app_nav_drawer.dart';
import '../../widgets/customAppbar.dart';
import '../FINANCIAL_Overview/financial_overview_screen.dart';
import '../business_health/business_health_screen.dart';
import '../business_profile/business_profile_screen.dart';
import '../dashboard/dashboard_screen.dart';
import '../demand_Forecast/demand_forecast_screen.dart';
import 'scenario_lab_state.dart';
import '../opportunity/ScenarioLab/widgets/scenario_lab_colors.dart';
import 'widgets/cash_chart_card.dart';
import 'widgets/category_section.dart';
import 'widgets/empty_state_card.dart';
import 'widgets/follow_up_input_bar.dart';
import '../opportunity/ScenarioLab/widgets/key_numbers_grid.dart';
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
  ScenarioViewState _viewState = ScenarioViewState.empty;
  String _question =
      'Can I hire a second pizzaiolo for Friday nights and scale dough '
      'production to stop the sell-outs?';

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
      appBar: const CustomAppBar(
        title: 'Scenario Lab',
        hasUnreadNotifications: true,
      ),
      drawer: AppNavDrawer(
        selectedIndex: 5,
        onItemSelected: _onDrawerItemSelected,
      ),
      body: SafeArea(
        top: false,
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 8, 16, 8),
              child: Align(
                alignment: Alignment.centerRight,
                child: StateTabs(
                  value: _viewState,
                  onChanged: (state) => setState(() => _viewState = state),
                ),
              ),
            ),
            Expanded(child: _buildBody()),
          ],
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
                  headline: 'Feasible',
                  pills: [
                    VerdictPill(
                      label: 'Decision',
                      color: ScenarioLabColors.statusInfo,
                    ),
                    VerdictPill(
                      label: 'Confidence: High',
                      color: ScenarioLabColors.statusGood,
                      hasInfo: true,
                    ),
                    VerdictPill(
                      label: 'Risk: Low',
                      color: ScenarioLabColors.statusGood,
                      hasInfo: true,
                    ),
                  ],
                  body:
                      'The hire and the added prep cost about \$1,730 a '
                      'month all-in, and the ≈35 orders a week you turn '
                      'away at the sold-out Fri–Sat peak are worth ≈\$2,700 '
                      'a month at your \$19 average ticket. Cash dips to '
                      'about \$50,600 in month 2 while the recovered orders '
                      'ramp, then climbs past where it started — it never '
                      'comes within \$30,000 of your \$20,000 reserve floor, '
                      'so this is a capacity decision, not a cash-risk '
                      'decision.',
                  warningLabel: 'Timing note:',
                  warning:
                      'the NYC public-school mid-winter recess (Feb 16–20) '
                      'trims your school-lunch slice trade by about \$980 '
                      'that week, so the first scaled Fridays will read '
                      'soft. Judge the hire at week 6, not week 2.',
                ),
                const SizedBox(height: 20),
                const KeyNumbersGrid(
                  numbers: [
                    KeyNumberData(
                      label: 'FRIDAY HIRE, LOADED',
                      value: '\$950/mo',
                      note: 'your question · NYC weekend rate check',
                      dotColor: ScenarioLabColors.statusWarn,
                    ),
                    KeyNumberData(
                      label: 'ADDED DOUGH & PREP',
                      value: '\$180/wk',
                      note: 'estimated from your 400 lb/wk cheese usage',
                      dotColor: ScenarioLabColors.statusWarn,
                    ),
                    KeyNumberData(
                      label: 'ORDERS RECOVERED',
                      value: '≈\$2,700/mo',
                      note: '≈35 orders/wk · \$19 ticket · Square POS',
                      dotColor: ScenarioLabColors.statusGood,
                    ),
                    KeyNumberData(
                      label: 'CASH AT LOWEST POINT',
                      value: '\$50,600',
                      note: 'month 2 · floor is \$20,000',
                      dotColor: ScenarioLabColors.statusGood,
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                const CategorySection(),
                const SizedBox(height: 20),
                const CashChartCard(
                  xLabels: ['Now', 'Mo1', 'Mo2', 'Mo3', 'Mo4', 'Mo5', 'Mo6'],
                  projected: [58.0, 54.0, 50.6, 52.0, 55.0, 58.0, 60.5],
                  worstCase: [58.0, 52.0, 49.3, 49.3, 49.5, 50.0, 50.5],
                  reserveFloor: 20.0,
                  maxValue: 65.0,
                  breakEvenIndex: 5,
                  breakEvenLabel: 'Break-even',
                  lowPointIndex: 2,
                  lowPointLabel: 'Low \$50.6K',
                  reserveFloorLabel: 'Reserve floor \$20,000',
                  yAxisLabels: ['\$0', '\$20K', '\$40K', '\$65K'],
                  yAxisValues: [0.0, 20.0, 40.0, 65.0],
                  stressTestBody:
                      'the worst case assumes only ~60% of the '
                      'turned-away orders return and prep runs \$60/wk '
                      'over — cash flattens near \$49,300 but never '
                      'threatens the \$20,000 floor. Break-even in month '
                      '5 means the recovered Friday orders have by then '
                      'paid back every dollar of hire and prep since '
                      'launch; from there you run ~\$970 a month ahead.',
                ),
                const SizedBox(height: 20),
                ScenarioActionsRow(
                  disclaimer:
                      'These projections are based on your Square and '
                      'QuickBooks data plus comparable-market research. '
                      'No financing is involved, so there is no lender to '
                      'confirm with — but review the wage and hour '
                      'figures with your accountant before posting the '
                      'shift.',
                  onSave: () => showSaveScenarioDialog(
                    context,
                    initialName: 'Second Pizzaiolo, Friday Nights',
                    onConfirm: (_) {},
                  ),
                  onAdjust: () {},
                  onNewScenario: () => showNewScenarioDialog(
                    context,
                    onSaveFirst: () => showSaveScenarioDialog(
                      context,
                      initialName: 'Second Pizzaiolo, Friday Nights',
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
