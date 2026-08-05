import 'dart:math' as math;
import 'dart:ui';
import 'dart:math' show pi;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_application_1/features/FINANCIAL_Overview/financial_overview_screen.dart';
import 'package:flutter_application_1/features/business_health/business_health_screen.dart';
import 'package:flutter_application_1/features/business_profile/business_profile_screen.dart';
import 'package:flutter_application_1/features/dashboard/dashboard_screen.dart';
import 'package:flutter_application_1/features/demand_Forecast/demand_forecast_screen.dart';
import 'package:flutter_application_1/features/opportunity/ScenarioLab/widgets/key_numbers_grid.dart';
import 'package:flutter_application_1/features/setting/settings_screen.dart';
import 'package:flutter_application_1/theme/app_theme.dart';
import 'package:flutter_application_1/widgets/app_nav_drawer.dart';
import 'package:flutter_application_1/widgets/customAppbar.dart';
import 'package:flutter_application_1/widgets/gradient_background.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';
import '../opportunities_screen.dart';
import '../../../widgets/app_nav_destinations.dart';

class LS {
  static const fg = Color(0xFFFFFFFF);
  static const soft = Color(0xFFCFEFFB);
  static const mute = Color(0xFFA7DCF0);
  static const good = Color(0xFF7BEFD0);
  static const goodText = Color(0xFFA6F5DC);
  static const warn = Color(0xFFFFD98A);
  static const warnText = Color(0xFFFFD466);
  static const crit = Color(0xFFFF7A7A);
  static const accent = Color(0xFF5FE0FF);
  static const ink = Color(0xFF04303F);

  static const sevCritical = Color(0xFFFF5757);
  static const sevBuilding = Color(0xFFFFD466);
  static const sevStable = Color(0xFFFFFFFF);
  static const sevResolved = Color(0xFF26C281);

  static const bg1 = Color(0xFF2BD4FF);
  static const bg2 = Color(0xFF18A8DC);
  static const bg3 = Color(0xFF0E9ED0);
  static const bg4 = Color(0xFF1AAEDE);
  static const bgBase1 = Color(0xFF064A63);
  static const bgBase2 = Color(0xFF05688A);
  static const bgBase3 = Color(0xFF0892C0);

  static const scrimTop = Color(0x57082838);
  static const scrimBot = Color(0x4D082838);

  static const bodyBg = Color(0xFF0A2733);
}

class GlassCard extends StatelessWidget {
  final Widget child;
  final EdgeInsetsGeometry padding;
  final double radius;
  const GlassCard({
    super.key,
    required this.child,
    this.padding = const EdgeInsets.all(16),
    this.radius = 20,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(radius),
        border: Border.all(color: Colors.white.withOpacity(.16)),
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [LS.scrimTop, LS.scrimBot, Colors.white.withOpacity(.03)],
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(.35),
            blurRadius: 40,
            offset: const Offset(0, 18),
          ),
          BoxShadow(
            color: Colors.white.withOpacity(.35),
            blurRadius: 0,
            spreadRadius: -.5,
            offset: const Offset(0, 1),
          ),
        ],
      ),
      padding: padding,
      child: DefaultTextStyle.merge(
        style: const TextStyle(
          shadows: [
            Shadow(
              color: Color(0x66001220),
              blurRadius: 2,
              offset: Offset(0, 1),
            ),
          ],
        ),
        child: child,
      ),
    );
  }
}

class Kpi {
  final String label, value, source;
  final Color? sev;
  Kpi(this.label, this.value, this.source, [this.sev]);
}

class TtrCard {
  final String eyebrow, title;
  final List<String> body;
  final String? gate;
  TtrCard(this.eyebrow, this.title, this.body, {this.gate});
}

class WheelNode {
  final String title, kpi, kpiLabel, time, body, action;
  WheelNode(
    this.title,
    this.kpi,
    this.kpiLabel,
    this.time,
    this.body,
    this.action,
  );
}

class AssumptionRow {
  final String label, value, source;
  AssumptionRow(this.label, this.value, this.source);
}

enum SectionKind { ttr, wheel }

class Section {
  final String key, label;
  final SectionKind kind;
  final List<TtrCard>? cards;
  final List<WheelNode>? nodes;
  final String? wheelName;
  Section.ttr(this.key, this.label, this.cards)
    : kind = SectionKind.ttr,
      nodes = null,
      wheelName = null;
  Section.wheel(this.key, this.label, this.wheelName, this.nodes)
    : kind = SectionKind.wheel,
      cards = null;
}

final kKpis = [
  Kpi(
    'Friday hire, loaded',
    '\$950/mo',
    'your question · NYC weekend rate check',
    LS.sevBuilding,
  ),
  Kpi(
    'Added dough & prep',
    '\$180/wk',
    'estimated from your 400 lb/wk cheese usage',
    LS.sevBuilding,
  ),
  Kpi(
    'Orders recovered',
    '≈\$2,700/mo',
    '≈35 orders/wk × \$19 ticket · Square POS',
    LS.sevResolved,
  ),
  Kpi('Cash at lowest point', '\$50,600', 'month 2 · floor is \$20,000', null),
];

final kAssumptions = [
  AssumptionRow(
    'Friday pizzaiolo, loaded',
    '\$950/mo',
    'you · NYC weekend market check',
  ),
  AssumptionRow(
    'Added dough & ingredient prep',
    '\$180/wk',
    'estimated · scaled from your 400 lb/wk cheese usage',
  ),
  AssumptionRow(
    'Recovered Friday orders',
    '≈35/wk × \$19',
    'Square POS · two February sell-outs',
  ),
  AssumptionRow('Cash balance today', '\$52,400', 'QuickBooks Online · synced'),
  AssumptionRow('Reserve floor', '\$20,000', 'your profile setting'),
];

final Map<String, Section> kSections = {
  'steps': Section.ttr('steps', 'Steps to take', [
    TtrCard(
      'STEP 1 OF 4',
      'Price the Friday shift before you post it',
      [
        'You are budgeting about \$950 a month loaded — one 8-hour Friday shift at roughly \$27/hour including the employer costs on top, across the month\u2019s Fridays. Experienced dough hands in the NYC weekend market run \$25–\$30/hour, so \$27 is realistic but not generous.',
        'How: ask your flour and cheese distributor reps who is looking, and post in Brooklyn pizza-maker groups before any listings site. Why it matters: every \$2/hour above plan adds about \$70 a month, and at \$32/hour the monthly margin on the recovered orders thins from ≈\$970 toward ≈\$800.',
      ],
      gate:
          'Gate: if every serious candidate wants Friday + Saturday at \$32/hour or more, rerun this scenario as a two-night hire before committing.',
    ),
    TtrCard(
      'STEP 2 OF 4',
      'Scale the dough on Wednesday, not Friday',
      [
        'Your cold-fermented dough needs 48–72 hours, so the week\u2019s extra ≈35 orders at the Fri–Sat peak are decided by Wednesday afternoon\u2019s dough plan. Add roughly 30% to the Wednesday mix — that is the \$180 a week in added flour, cheese, and prep time — and check the walk-in first: the extra dough trays need shelf space.',
        'Why it matters: if the dough is not scaled, the \$950-a-month hire stands next to an empty proofing rack — you carry the full cost and recover none of the ≈\$2,700.',
      ],
      gate:
          'Gate: if the walk-in cannot hold the extra trays, add speed racks and dough boxes (≈\$300 one-time) before the first scaled batch.',
    ),
    TtrCard(
      'STEP 3 OF 4 · CUSTOMER EXPERIENCE',
      'Bring back the customers you turned away',
      [
        'The ≈\$2,700 a month only lands if the people you turned away come back on a night you can serve them. When Friday sells out, take names and numbers — and text those customers first when the scaled Fridays start.',
        'For the first four scaled Fridays, Sal works the counter: greet the late crowd, and send a free order of garlic knots home with anyone who got turned away in February. A gift reads as care; a discount reads as an apology.',
      ],
    ),
    TtrCard(
      'STEP 4 OF 4',
      'Give it six weeks, then hold it to a number',
      [
        'Friday currently caps out around \$5,200 when the dough runs dry. Track Friday sales for the first six scaled weeks against one line: \$5,800 — the old cap plus enough recovered orders to cover the hire and prep with margin left.',
      ],
      gate:
          'Gate: if Friday revenue is not holding at \$5,800 or better by week 6, cut the added prep back to \$90 a week and make the shift seasonal.',
    ),
  ]),
  'pros': Section.wheel('pros', 'Pros — what you gain', 'Pros', [
    WheelNode(
      'Friday stops leaving money on the counter',
      '≈\$2,700/mo',
      ' recovered orders',
      'Ramps weeks 3–6',
      'Turn-aways are already running ≈35 orders a week after two hard Friday sell-outs this month. With dough scaled and a second pizzaiolo on the oven, every Friday runs to close instead of dying at 8pm.',
      'Text the captured sell-out list the day the first scaled Friday is confirmed.',
    ),
    WheelNode(
      'The weekend engine gets protected',
      '41%',
      ' of weekly revenue is Fri–Sat dinner',
      'Immediate insurance',
      'Friday–Saturday dinner is 41% of your week and running 14% ahead of last February. A single pizzaiolo is a single point of failure on your biggest nights.',
      'Cross-train the new hire on your dough recipe in week 1, not just the oven.',
    ),
    WheelNode(
      'Capacity you will need for spring anyway',
      '6',
      ' catering inquiries this month',
      'Pays again from April',
      'You took 2 of 6 catering inquiries this month, and school pizza-party season lands in spring. This hire is infrastructure for that revenue too.',
      'Route the next catering inquiry into a Friday-prep slot as a live test.',
    ),
  ]),
  'cons': Section.wheel('cons', 'Cons — what it costs you', 'Cons', [
    WheelNode(
      'You pay before you collect',
      '−\$1,800',
      ' cash dip by month 2',
      'Hits weeks 1–6',
      'The hire and prep cost about \$1,730 a month from day one, but recovered orders ramp over 3–6 weeks. Cash drifts down to ≈\$50,600 in month 2 before the curve turns — you stay \$30,600 above your \$20,000 floor.',
      'Judge the hire at week 6 against the \$5,800 Friday line, not at week 2.',
    ),
    WheelNode(
      'Recovered orders are an estimate, not a booking',
      '≈\$1,100/mo',
      ' gap if only 60% return',
      'Visible by month 3',
      'The ≈35 turned-away orders a week are inferred from two sell-outs. If only 60% come back, recovery is ≈\$1,600 a month, roughly break-even on the ≈\$1,730 cost until spring catering fills the gap.',
      'Run the step-3 win-back tactics from week 1 — they close the missing 40%.',
    ),
    WheelNode(
      'A bad hire costs quality, not just wages',
      '4.5★ · 212',
      ' reviews at stake',
      'Weeks 2–8 risk window',
      'Friday is your showcase night. A pizzaiolo who runs the oven hot or stretches inconsistent skins puts your 4.5-star, 212-review reputation at risk.',
      'Change one variable per week: hire first, hold the cheese switch until Friday quality is stable.',
    ),
  ]),
  'keep': Section.wheel('keep', 'Things to keep in mind', 'Keep', [
    WheelNode(
      'Dough decisions live three days early',
      '48–72h',
      ' cold-ferment lead time',
      'Every week',
      'Friday\u2019s ceiling is set on Wednesday. A snow forecast means you either eat the extra \$180 of prep or move it as Saturday squares.',
      'Put the Wednesday scale-up rule on the prep board so it survives Sal\u2019s day off.',
    ),
    WheelNode(
      'Friday-only shifts are hard to keep filled in NYC',
      '\$25–\$30/hr',
      ' weekend market rate',
      'Months 2–4 churn window',
      'The NYC weekend labor market is a seller\u2019s market for skilled dough hands. Plan to re-fill this role once; bundling Friday with Saturday or a paid Wednesday prep block moves the math toward ≈\$1,400 a month.',
      'Ask candidates what schedule keeps them for a year, not what they will take today.',
    ),
    WheelNode(
      'Success creates the next bottleneck',
      '22 seats',
      ' and one oven',
      'Month 3 and later',
      'If Fridays run full to close, the constraint moves from dough to oven deck and counter space. Watch quote times: past 25 minutes you start trading walk-ins for phone orders.',
      'Track Friday quote times from week 1 so you see the next wall before you hit it.',
    ),
  ]),
  'peer': Section.ttr('peer', 'Peer context', [
    TtrCard(
      'COMPARABLE-MARKET PATTERN',
      'What shops like yours see with a weekend capacity hire',
      [
        'Among single-location slice shops in outer-borough corridors comparable to yours, the typical pattern with a weekend production hire is a 3–6 week ramp, not an instant pop.',
        'Shops where it sticks share two traits: they scale dough and labor together, and they hold the hire to a specific weekly revenue line by a set date.',
      ],
    ),
    TtrCard('WHERE THIS COMES FROM', 'Read this as a pattern, not a promise', [
      'This is typical-pattern context from comparable NYC-borough pizzeria markets — your own Friday POS numbers will out-vote the pattern within six weeks.',
    ]),
  ]),
  'alt': Section.ttr('alt', 'Alternatives', [
    TtrCard('ALTERNATIVE 1 OF 3', 'Pre-orders instead of a hire', [
      'Cap Friday where it is and open Friday pre-orders Wednesday–Thursday through the box-top QR. Cost: roughly \$0. Recovers maybe \$800–\$1,000 a month but does nothing for the single-pizzaiolo risk.',
    ]),
    TtrCard('ALTERNATIVE 2 OF 3', 'Prep-only helper, no oven hire', [
      'A prep-shift helper (≈\$550/mo loaded) plus the \$180/wk of ingredients scales the dough without a second oven man. Recovers roughly 60–70% of the orders — ≈\$1,700–\$1,900 a month.',
    ]),
    TtrCard('ALTERNATIVE 3 OF 3', 'Go bigger: Friday + Saturday', [
      'Two nights at ≈\$1,900/mo loaded rides the whole weekend engine. Higher fixed cost, higher ceiling — treat it as the phase-2 upgrade, not the opening move.',
    ]),
  ]),
};

const kSectionOrder = ['steps', 'pros', 'cons', 'keep', 'peer', 'alt'];

const kTileIcons = {
  'steps': Icons.checklist_rtl_rounded,
  'pros': Icons.thumb_up_alt_outlined,
  'cons': Icons.thumb_down_alt_outlined,
  'keep': Icons.warning_amber_rounded,
  'peer': Icons.groups_2_outlined,
  'alt': Icons.share_outlined,
};
const kTileHints = {
  'steps': '4 steps · 3 decision gates',
  'pros': '3 upsides, each priced',
  'cons': '3 risks, each with a fix',
  'keep': '3 landmines advisors flag',
  'peer': 'What comparable shops see',
  'alt': '3 other routes, costed',
};
const kTileColors = {
  'steps': LS.accent,
  'pros': LS.sevResolved,
  'cons': LS.sevCritical,
  'keep': LS.sevBuilding,
  'peer': Color(0xFF7E8CE6),
  'alt': Color(0xFF3FB4C4),
};

const kChartLabels = ['Now', 'Mo 1', 'Mo 2', 'Mo 3', 'Mo 4', 'Mo 5', 'Mo 6'];
const List<double> kChartProj = [
  52400.0,
  51150.0,
  50600.0,
  50950.0,
  51700.0,
  52700.0,
  53650.0,
];
const List<double> kChartWorst = [
  52400.0,
  51000.0,
  49900.0,
  49500.0,
  49300.0,
  49400.0,
  49600.0,
];
const kFloor = 20000.0;
const kBreakEvenIdx = 5;
const kLowIdx = 2;

@immutable
class ScenarioLabState {
  final String? openSection;
  final Map<String, int> ttrIndex;
  final Map<String, Set<int>> revealedInk;
  final Set<String> exploredTiles;
  final Set<String> openTip;
  final bool assumeOpen;
  final Map<String, int?> wheelSelected;
  final Map<String, Set<int>> wheelSeen;
  final int? chartHoverIdx;

  const ScenarioLabState({
    this.openSection,
    this.ttrIndex = const {},
    this.revealedInk = const {},
    this.exploredTiles = const {},
    this.openTip = const {},
    this.assumeOpen = false,
    this.wheelSelected = const {},
    this.wheelSeen = const {},
    this.chartHoverIdx,
  });

  ScenarioLabState copyWith({
    String? openSection,
    bool clearOpenSection = false,
    Map<String, int>? ttrIndex,
    Map<String, Set<int>>? revealedInk,
    Set<String>? exploredTiles,
    Set<String>? openTip,
    bool? assumeOpen,
    Map<String, int?>? wheelSelected,
    Map<String, Set<int>>? wheelSeen,
    int? chartHoverIdx,
    bool clearChartHover = false,
  }) {
    return ScenarioLabState(
      openSection: clearOpenSection ? null : (openSection ?? this.openSection),
      ttrIndex: ttrIndex ?? this.ttrIndex,
      revealedInk: revealedInk ?? this.revealedInk,
      exploredTiles: exploredTiles ?? this.exploredTiles,
      openTip: openTip ?? this.openTip,
      assumeOpen: assumeOpen ?? this.assumeOpen,
      wheelSelected: wheelSelected ?? this.wheelSelected,
      wheelSeen: wheelSeen ?? this.wheelSeen,
      chartHoverIdx: clearChartHover
          ? null
          : (chartHoverIdx ?? this.chartHoverIdx),
    );
  }
}

class ScenarioLabNotifier extends StateNotifier<ScenarioLabState> {
  ScenarioLabNotifier() : super(const ScenarioLabState());

  void toggleTile(String key) {
    final explored = {...state.exploredTiles};
    if (state.openSection == key) {
      explored.add(key);
      state = state.copyWith(exploredTiles: explored, clearOpenSection: true);
      return;
    }
    if (state.openSection != null) explored.add(state.openSection!);
    final ttrIndex = {...state.ttrIndex};
    ttrIndex.putIfAbsent(key, () => 0);
    state = state.copyWith(
      exploredTiles: explored,
      openSection: key,
      ttrIndex: ttrIndex,
    );
  }

  void closePanel() {
    final explored = {...state.exploredTiles};
    if (state.openSection != null) explored.add(state.openSection!);
    state = state.copyWith(exploredTiles: explored, clearOpenSection: true);
  }

  void openSection(String key) {
    final ttrIndex = {...state.ttrIndex}..putIfAbsent(key, () => 0);
    state = state.copyWith(openSection: key, ttrIndex: ttrIndex);
  }

  void setTtrIndex(String key, int index) {
    final ttrIndex = {...state.ttrIndex, key: index};
    state = state.copyWith(ttrIndex: ttrIndex);
  }

  void revealInk(String key, int idx) {
    final revealed = {...state.revealedInk};
    revealed[key] = {...(revealed[key] ?? {}), idx};
    state = state.copyWith(revealedInk: revealed);
  }

  void toggleTip(String key) {
    final open = {...state.openTip};
    if (open.contains(key)) {
      open.remove(key);
    } else {
      open
        ..clear()
        ..add(key);
    }
    state = state.copyWith(openTip: open);
  }

  void dismissTip(String key) {
    final open = {...state.openTip}..remove(key);
    state = state.copyWith(openTip: open);
  }

  void toggleAssume() {
    state = state.copyWith(assumeOpen: !state.assumeOpen);
  }

  void wheelSelect(String sectionKey, int i) {
    final sel = {...state.wheelSelected, sectionKey: i};
    final seenMap = {...state.wheelSeen};
    seenMap[sectionKey] = {...(seenMap[sectionKey] ?? {}), i};
    state = state.copyWith(wheelSelected: sel, wheelSeen: seenMap);
  }

  void setChartHover(int? idx) {
    state = state.copyWith(chartHoverIdx: idx, clearChartHover: idx == null);
  }
}

final scenarioLabProvider =
    StateNotifierProvider.autoDispose<ScenarioLabNotifier, ScenarioLabState>((
      ref,
    ) {
      return ScenarioLabNotifier();
    });

class ScenariooLabScreen extends ConsumerStatefulWidget {
  const ScenariooLabScreen({super.key});

  @override
  ConsumerState<ScenariooLabScreen> createState() => _ScenarioLabScreenState();
}

class _ScenarioLabScreenState extends ConsumerState<ScenariooLabScreen> {
  final _scaffoldKey = GlobalKey<ScaffoldState>();

  // ---- drawer navigation, mirrors the pattern given for FinancialOverview
  static const _dashboardIndex = 0;
  static const _demandForecastIndex = 1;
  static const _financialOverviewIndex = 2;
  static const _businessHealthIndex = 3;
  static const _opportunitiesIndex = 4;
  static const _scenarioLabIndex = 5;
  static const _businessProfileIndex = 6;
  static const _settingsIndex = 7;

  void _onDrawerItemSelected(BuildContext context, int index) {
    openNavDestination(context, index, currentIndex: AppNavIndex.scenarioLab);
  }

  void _toggleTile(String key) =>
      ref.read(scenarioLabProvider.notifier).toggleTile(key);

  void _closePanel() => ref.read(scenarioLabProvider.notifier).closePanel();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: const CustomAppBar(
        title: 'Scenario Lab',
        hasUnreadNotifications: true,
      ),
      drawer: AppNavDrawer(
        selectedIndex: 5,
        onItemSelected: (index) {
          _onDrawerItemSelected(context, index);
        },
      ),
      body: GradientBackground(
        child: SafeArea(
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  _conversationBubble(),
                  const SizedBox(height: 12),
                  _verdictCard(),
                  const SizedBox(height: 18),
                  _eyebrow('Key numbers'),
                  const SizedBox(height: 10),
                  const KeyNumbersGrid(
                    numbers: [
                      KeyNumberData(
                        label: 'FRIDAY HIRE, LOADED',
                        value: '\$950/mo',
                        note: 'your question · NYC weekend rate check',
                        dotColor: Color(0xFFFFC24B),
                        showGlow: true,
                      ),
                      KeyNumberData(
                        label: 'ADDED DOUGH & PREP',
                        value: '\$180/wk',
                        note: 'estimated from your 400 lb/wk cheese usage',
                        dotColor: Color(0xFFFFC24B),
                        showGlow: true,
                      ),
                      KeyNumberData(
                        label: 'ORDERS RECOVERED',
                        value: '≈\$2,700/mo',
                        note: '≈35 orders/wk · \$19 ticket · Square POS',
                        dotColor: Color(0xFF6FDB6C),
                        showGlow: false,
                      ),
                      KeyNumberData(
                        label: 'CASH AT LOWEST POINT',
                        value: '\$50,600',
                        note: 'month 2 · floor is \$20,000',
                        dotColor: Color(0xFF6FDB6C),
                        showGlow: false,
                      ),
                    ],
                  ),

                  // _kpiGrid(),
                  const SizedBox(height: 18),
                  _eyebrow('Full analysis'),
                  const SizedBox(height: 10),
                  _sixTileSection(),
                  const SizedBox(height: 14),
                  // _assumptionsAccordion(),
                  const SizedBox(height: 18),
                  _chartCard(),
                  const SizedBox(height: 18),
                  _actionBar(),
                  const SizedBox(height: 14),
                  _disclaimer(),
                  const SizedBox(height: 14),
                  _followUpBar(),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _eyebrow(String text) => Align(
    alignment: Alignment.centerLeft,
    child: Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
      decoration: BoxDecoration(
        color: LS.scrimTop,
        borderRadius: BorderRadius.circular(999),
        border: Border.all(color: Colors.white.withOpacity(.18)),
      ),
      child: Row(
        children: [
          Text(
            text,
            style: AppTextStyles.body.copyWith(
              fontSize: 13,
              fontWeight: FontWeight.w600,
              color: Colors.white,
            ),
          ),
        ],
      ),
    ),
  );

  Widget _conversationBubble() {
    return Align(
      alignment: Alignment.centerLeft,
      child: ConstrainedBox(
        constraints: BoxConstraints(
          maxWidth: MediaQuery.of(context).size.width * .75,
        ),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 12),
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                Color.fromRGBO(8, 40, 56, 0.34),
                Color.fromRGBO(255, 255, 255, 0.04),
              ],
              stops: [0.0, 1.0],
            ),
            color: const Color(0xFF0D4A63), // optional base color
            border: Border.all(color: Colors.white.withOpacity(0.18), width: 1),
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(18),
              topRight: Radius.circular(18),
              bottomRight: Radius.circular(18),
              bottomLeft: Radius.circular(6),
            ),
          ),
          child: Text(
            'Can I hire a second pizzaiolo for Friday nights and scale dough production to stop the sell-outs?',
            style: AppTextStyles.body.copyWith(
              fontSize: 15,
              fontWeight: FontWeight.w500,
              color: Colors.white,
              height: 1.45,
            ),
          ),
        ),
      ),
    );
  }

  Widget _verdictCard() {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),

        // First Gradient
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          transform: GradientRotation(160 * pi / 180),
          colors: const [
            Color.fromRGBO(8, 40, 56, 0.24),
            Color.fromRGBO(8, 40, 56, 0.20),
          ],
        ),
      ),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),

          // Border
          border: Border.all(
            color: const Color.fromRGBO(255, 255, 255, 0.30),
            width: 1.25,
          ),

          // Second Gradient
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            transform: GradientRotation(160 * pi / 180),
            colors: const [
              Color.fromRGBO(255, 255, 255, 0.14),
              Color.fromRGBO(255, 255, 255, 0.05),
              Color.fromRGBO(255, 255, 255, 0.03),
            ],
            stops: const [
              0.0, // 0%
              0.4, // 40%
              1.0, // 100%
            ],
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Feasible',
              style: AppTextStyles.headline.copyWith(
                // fontFamily: _spaceGrotesk,
                fontSize: 29,
                fontWeight: FontWeight.w600,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 13),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                _pill('Decision', LS.accent, null),
                _pill(
                  'Confidence: High',
                  LS.sevBuilding,
                  'tip_conf',
                  'High because Square POS and QuickBooks Online are connected and current — 98% data coverage. These figures come from your books, not estimates.',
                ),
                _pill(
                  'Risk: Low',
                  LS.sevCritical,
                  'tip_risk',
                  'Low because the lowest projected cash is \$50,600 in month 2 — \$30,600 above your \$20,000 reserve floor — and even the worst case stays about \$29,300 above it.',
                ),
              ],
            ),
            const SizedBox(height: 6),
            Text(
              'The hire and the added prep cost about \$1,730 a month all-in, and the ≈35 orders a week you turn away at the sold-out Fri–Sat peak are worth ≈\$2,700 a month at your \$19 average ticket. '
              'Cash dips to about \$50,600 in month 2 while the recovered orders ramp, then climbs past where it started — it never comes within \$30,000 of your \$20,000 reserve floor, so this is a capacity decision, not a cash-risk decision.',
              style: AppTextStyles.body.copyWith(fontSize: 15, height: 1.65),
            ),
            const SizedBox(height: 14),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.white.withOpacity(.18)),
                color: Colors.white.withOpacity(.05),
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Icon(
                    Icons.warning_amber_rounded,
                    color: LS.sevBuilding,
                    size: 17,
                  ),
                  SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      'Timing note: the NYC public-school mid-winter recess (Feb 16–20) trims your school-lunch slice trade by about \$980 that week, so the first scaled Fridays will read soft. Judge the hire at week 6, not week 2.',
                      style: AppTextStyles.small.copyWith(
                        fontSize: 13,
                        color: LS.warn,
                        height: 1.5,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _pill(String label, Color dot, String? tipKey, [String? tip]) {
    final open =
        tipKey != null &&
        ref.watch(scenarioLabProvider).openTip.contains(tipKey);
    return GestureDetector(
      onTap: tipKey == null
          ? null
          : () {
              final notifier = ref.read(scenarioLabProvider.notifier);
              notifier.toggleTip(tipKey);
              if (!open) {
                Future.delayed(const Duration(seconds: 3), () {
                  if (mounted) notifier.dismissTip(tipKey);
                });
              }
            },
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 11, vertical: 5),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(999),
              border: Border.all(color: Colors.white.withOpacity(.22)),
              color: Colors.white.withOpacity(.08),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 8,
                  height: 8,
                  decoration: BoxDecoration(
                    color: dot,
                    borderRadius: BorderRadius.circular(4),
                  ),
                ),
                const SizedBox(width: 7),
                Text(
                  label,
                  style: AppTextStyles.small.copyWith(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
                  ),
                ),
                if (tipKey != null) ...[
                  const SizedBox(width: 4),
                  const Icon(
                    Icons.info_outline_rounded,
                    size: 13,
                    color: Colors.white,
                  ),
                ],
              ],
            ),
          ),
          if (open && tip != null)
            Container(
              margin: const EdgeInsets.only(top: 8),
              width: 238,
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
              decoration: BoxDecoration(
                color: const Color(0xF2063C46),
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: Colors.white.withOpacity(.18)),
              ),
              child: Text(
                tip,
                style: AppTextStyles.small.copyWith(
                  fontSize: 12,
                  // color: LS.soft,
                  height: 1.5,
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _sixTileSection() {
    final openSection = ref.watch(scenarioLabProvider).openSection;
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),

        // First Gradient
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          transform: GradientRotation(160 * pi / 180),
          colors: const [
            Color.fromRGBO(8, 40, 56, 0.24),
            Color.fromRGBO(8, 40, 56, 0.20),
          ],
        ),
      ),
      // radius: 20,
      padding: const EdgeInsets.all(14),
      child: LayoutBuilder(
        builder: (context, constraints) {
          final tiles = kSectionOrder;
          // build rows of 2, inserting the panel right after the row that
          // contains the open tile — mirrors placePanelUnder() in the HTML.
          final rows = <List<String>>[];
          for (var i = 0; i < tiles.length; i += 2) {
            rows.add(tiles.sublist(i, math.min(i + 2, tiles.length)));
          }
          int? openRow;
          if (openSection != null) {
            for (var r = 0; r < rows.length; r++) {
              if (rows[r].contains(openSection)) openRow = r;
            }
          }
          final children = <Widget>[];
          for (var r = 0; r < rows.length; r++) {
            children.add(
              Row(
                children: <Widget>[
                  for (var j = 0; j < rows[r].length; j++) ...[
                    Expanded(child: _tile(rows[r][j])),
                    if (j == 0 && rows[r].length > 1) const SizedBox(width: 11),
                  ],
                ],
              ),
            );
            if (r != rows.length - 1) children.add(const SizedBox(height: 11));
            if (openRow == r && openSection != null) {
              children.add(const SizedBox(height: 11));
              children.add(_panel(openSection));
            }
          }
          return Column(children: children);
        },
      ),
    );
  }

  Widget _tile(String key) {
    final labState = ref.watch(scenarioLabProvider);
    final isOpen = labState.openSection == key;
    final explored = labState.exploredTiles.contains(key);
    final color = kTileColors[key]!;
    final glow = !isOpen && !explored;
    return GestureDetector(
      onTap: () => _toggleTile(key),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 150),
        constraints: const BoxConstraints(minHeight: 106),
        padding: const EdgeInsets.all(13),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(14),
          color: color.withOpacity(.10),
          border: Border.all(color: color.withOpacity(.42)),
          boxShadow: glow
              ? [
                  BoxShadow(
                    color: const Color(0xB0E0F6FF).withOpacity(.1),
                    blurRadius: 2,
                    spreadRadius: .1,
                  ),
                  BoxShadow(
                    color: const Color(0x47C6ECFF).withOpacity(.1),
                    blurRadius: 2,
                    spreadRadius: .3,
                  ),
                ]
              : null,
        ),
        transform: isOpen
            ? (Matrix4.identity()..scale(.97))
            : Matrix4.identity(),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(
              kTileIcons[key],
              color: Colors.white.withOpacity(.95),
              size: 22,
            ),
            const SizedBox(height: 6),
            Text(
              kSections[key]!.label.split(' — ').first,
              style: AppTextStyles.body.copyWith(
                fontSize: 14.5,
                fontWeight: FontWeight.w600,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              kTileHints[key]!,
              style: AppTextStyles.body.copyWith(
                fontSize: 11.5,
                color: LS.soft,
                height: 1.35,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _panel(String key) {
    final section = kSections[key]!;
    if (section.kind == SectionKind.ttr) {
      return _ttrPanel(section);
    }
    return _wheelPanel(section);
  }

  Widget _ttrPanel(Section section) {
    final labState = ref.watch(scenarioLabProvider);
    final idx = labState.ttrIndex[section.key] ?? 0;
    final card = section.cards![idx];
    final revealed = (labState.revealedInk[section.key] ?? {}).contains(idx);

    return Container(
      key: ValueKey('panel_${section.key}'),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.white.withOpacity(.14)),
        color: Colors.white.withOpacity(.05),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  section.label,
                  style: AppTextStyles.headline.copyWith(
                    fontSize: 16.5,
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
                  ),
                ),
              ),
              IconButton(
                icon: const Icon(Icons.close_rounded, color: LS.soft, size: 18),
                onPressed: _closePanel,
              ),
            ],
          ),
          Row(
            children: List.generate(section.cards!.length, (i) {
              final done = i < idx, active = i == idx;
              return Expanded(
                child: Container(
                  margin: const EdgeInsets.symmetric(horizontal: 2.5),
                  height: 3,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(2),
                    color: done || active
                        ? Colors.white.withOpacity(active ? .92 : .45)
                        : Colors.white.withOpacity(.18),
                  ),
                ),
              );
            }),
          ),
          const SizedBox(height: 10),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: Colors.white.withOpacity(.12)),
              color: Colors.white.withOpacity(.04),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  card.eyebrow,
                  style: AppTextStyles.body.copyWith(
                    fontSize: 11.5,
                    fontWeight: FontWeight.w600,
                    letterSpacing: .5,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  card.title,
                  style: AppTextStyles.headline.copyWith(
                    fontSize: 17,
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
                    height: 1.3,
                  ),
                ),
                const SizedBox(height: 9),
                Stack(
                  alignment: Alignment.center,
                  children: [
                    // Base content. When not revealed, blur + dim it — mirrors
                    // the .ink.obscured { filter:blur(6px); opacity:.35 } rule.
                    revealed
                        ? _ttrBody(card)
                        : ImageFiltered(
                            imageFilter: ImageFilter.blur(sigmaX: 6, sigmaY: 6),
                            child: Opacity(opacity: .35, child: _ttrBody(card)),
                          ),
                    if (!revealed)
                      Positioned.fill(
                        child: GestureDetector(
                          onTap: () => ref
                              .read(scenarioLabProvider.notifier)
                              .revealInk(section.key, idx),
                          child: Container(
                            color: Colors.transparent,
                            alignment: Alignment.center,
                            child: Container(
                              width: 44,
                              height: 44,
                              decoration: BoxDecoration(
                                color: Colors.white.withOpacity(.15),
                                shape: BoxShape.circle,
                              ),
                              child: const Icon(
                                Icons.visibility_outlined,
                                color: Colors.white,
                                size: 20,
                              ),
                            ),
                          ),
                        ),
                      ),
                  ],
                ),
                const SizedBox(height: 13),
                if (card.gate != null)
                  Row(
                    children: [
                      Expanded(
                        child: _gatePill(
                          idx < section.cards!.length - 1
                              ? 'Continue to step ${idx + 2}'
                              : 'Got it',
                          true,
                          () {
                            if (idx < section.cards!.length - 1) {
                              ref
                                  .read(scenarioLabProvider.notifier)
                                  .setTtrIndex(section.key, idx + 1);
                            } else {
                              _closePanel();
                            }
                          },
                        ),
                      ),
                      const SizedBox(width: 9),
                      Expanded(
                        child: _gatePill('See alternatives', false, () {
                          ref
                              .read(scenarioLabProvider.notifier)
                              .openSection('alt');
                        }),
                      ),
                    ],
                  )
                else
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      _arrowBtn(
                        Icons.chevron_left_rounded,
                        idx > 0,
                        () => ref
                            .read(scenarioLabProvider.notifier)
                            .setTtrIndex(section.key, idx - 1),
                      ),
                      _arrowBtn(
                        Icons.chevron_right_rounded,
                        idx < section.cards!.length - 1,
                        () => ref
                            .read(scenarioLabProvider.notifier)
                            .setTtrIndex(section.key, idx + 1),
                      ),
                    ],
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _ttrBody(TtrCard card) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        for (final p in card.body) ...[
          Text(
            p,
            style: AppTextStyles.body.copyWith(
              fontSize: 14,
              color: LS.soft,
              height: 1.6,
            ),
          ),
          const SizedBox(height: 9),
        ],
        if (card.gate != null)
          Text(
            card.gate!,
            style: AppTextStyles.body.copyWith(
              fontSize: 14,
              color: LS.warnText,
              height: 1.6,
            ),
          ),
      ],
    );
  }

  Widget _gatePill(String label, bool primary, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 8),
        alignment: Alignment.center,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          border: Border.all(
            color: primary
                ? LS.accent.withOpacity(.55)
                : Colors.white.withOpacity(.22),
          ),
          color: primary
              ? LS.accent.withOpacity(.2)
              : Colors.white.withOpacity(.07),
        ),
        child: Text(
          label,
          textAlign: TextAlign.center,
          style: AppTextStyles.body.copyWith(
            fontSize: 13.5,
            fontWeight: FontWeight.w600,
            color: Colors.white,
          ),
        ),
      ),
    );
  }

  Widget _arrowBtn(IconData icon, bool enabled, VoidCallback onTap) {
    return GestureDetector(
      onTap: enabled ? onTap : null,
      child: Opacity(
        opacity: enabled ? 1 : .35,
        child: Container(
          width: 36,
          height: 36,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(color: Colors.white.withOpacity(.22)),
            color: Colors.white.withOpacity(.12),
          ),
          child: Icon(icon, color: Colors.white, size: 20),
        ),
      ),
    );
  }

  // ---- wheel (pros / cons / keep) panel ---------------------------------
  Widget _wheelPanel(Section section) {
    final labState = ref.watch(scenarioLabProvider);
    final nodes = section.nodes!;
    final selected = labState.wheelSelected[section.key];
    final seen = labState.wheelSeen[section.key] ?? {};
    return Container(
      key: ValueKey('panel_${section.key}'),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.white.withOpacity(.14)),
        color: Colors.white.withOpacity(.05),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  section.label,
                  style: AppTextStyles.headline.copyWith(
                    fontSize: 16.5,
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
                  ),
                ),
              ),
              IconButton(
                icon: const Icon(Icons.close_rounded, color: LS.soft, size: 18),
                onPressed: _closePanel,
              ),
            ],
          ),
          Center(
            child: SizedBox(
              width: 260,
              height: 260,
              child: GestureDetector(
                onTapUp: (details) {
                  final local = details.localPosition;
                  const cx = 130.0, cy = 130.0;
                  final dx = local.dx - cx, dy = local.dy - cy;
                  final dist = math.sqrt(dx * dx + dy * dy);
                  if (dist < 48 || dist > 118) return;
                  var angle =
                      math.atan2(dy, dx) * 180 / math.pi; // -180..180, 0=east
                  angle =
                      (angle + 90 + 360) %
                      360; // rotate so first segment starts at top
                  final n = nodes.length;
                  final segAngle = 360 / n;
                  final i = (angle / segAngle).floor().clamp(0, n - 1);
                  ref
                      .read(scenarioLabProvider.notifier)
                      .wheelSelect(section.key, i);
                },
                child: CustomPaint(
                  painter: _WheelPainter(
                    count: nodes.length,
                    color: kTileColors[section.key]!,
                    seen: seen,
                    labels: nodes.map((n) => n.title).toList(),
                  ),
                  child: Center(
                    child: Container(
                      width: 90,
                      height: 90,
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.white.withOpacity(.13),
                        border: Border.all(
                          color: Colors.white.withOpacity(.32),
                        ),
                      ),
                      child: Text(
                        section.wheelName ?? '',
                        textAlign: TextAlign.center,
                        style: AppTextStyles.headline.copyWith(
                          fontSize: 15,
                          fontWeight: FontWeight.w600,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(height: 10),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 15),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: Colors.white.withOpacity(.12)),
              color: Colors.white.withOpacity(.04),
            ),
            child: selected == null
                ? Text(
                    'Select a segment to reveal it.',
                    style: AppTextStyles.body.copyWith(
                      color: LS.soft,
                      fontSize: 13.5,
                    ),
                  )
                : _wheelDetail(nodes[selected]),
          ),
        ],
      ),
    );
  }

  Widget _wheelDetail(WheelNode n) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          n.title,
          style: AppTextStyles.headline.copyWith(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: Colors.white,
          ),
        ),
        const SizedBox(height: 6),
        RichText(
          text: TextSpan(
            style: AppTextStyles.body.copyWith(
              fontSize: 13,
              fontWeight: FontWeight.w600,
              color: LS.goodText,
            ),
            children: [
              TextSpan(text: n.kpi),
              TextSpan(
                text: n.kpiLabel,
                style: AppTextStyles.body.copyWith(
                  color: LS.soft,
                  fontWeight: FontWeight.w400,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 3),
        Text(
          'When: ${n.time}',
          style: AppTextStyles.body.copyWith(fontSize: 12, color: LS.warnText),
        ),
        const SizedBox(height: 7),
        Text(
          n.body,
          style: AppTextStyles.body.copyWith(
            fontSize: 14,
            color: LS.soft,
            height: 1.6,
          ),
        ),
        const SizedBox(height: 9),
        Text(
          '→ ${n.action}',
          style: AppTextStyles.body.copyWith(
            fontSize: 13,
            color: LS.soft,
            height: 1.5,
          ),
        ),
      ],
    );
  }

  Widget _chartCard() {
    final hoverIdx = ref.watch(scenarioLabProvider).chartHoverIdx;
    final notifier = ref.read(scenarioLabProvider.notifier);
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.white.withOpacity(.14)),
        color: Colors.white.withOpacity(.05),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _eyebrow('Cash position over time'),
          const SizedBox(height: 10),
          Wrap(
            spacing: 12,
            runSpacing: 6,
            children: [
              _legendSwatch(LS.accent, 'Projected'),
              _legendSwatch(LS.crit, 'Worst case', dashed: true),
              _legendSwatch(LS.warnText, 'Reserve floor', dashed: true),
              _legendSwatch(LS.sevResolved, 'Break-even', dot: true),
            ],
          ),
          const SizedBox(height: 8),
          SizedBox(
            height: 230,
            child: Builder(
              builder: (context) {
                return GestureDetector(
                  onPanUpdate: (d) => notifier.setChartHover(
                    _nearestChartIndex(
                      d.localPosition,
                      context.size ?? const Size(300, 230),
                    ),
                  ),
                  onPanEnd: (_) => notifier.setChartHover(null),
                  onTapUp: (d) => notifier.setChartHover(
                    _nearestChartIndex(
                      d.localPosition,
                      context.size ?? const Size(300, 230),
                    ),
                  ),
                  child: CustomPaint(
                    size: Size.infinite,
                    painter: _ChartPainter(hoverIdx: hoverIdx),
                  ),
                );
              },
            ),
          ),
          if (hoverIdx != null)
            Padding(
              padding: const EdgeInsets.only(top: 8),
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 11,
                  vertical: 8,
                ),
                decoration: BoxDecoration(
                  color: const Color(0xEB063C46),
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: Colors.white.withOpacity(.16)),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      kChartLabels[hoverIdx].toUpperCase(),
                      style: AppTextStyles.body.copyWith(
                        fontSize: 10,
                        color: LS.soft,
                        letterSpacing: .5,
                      ),
                    ),
                    Text(
                      '\$${kChartProj[hoverIdx].toStringAsFixed(0)} projected',
                      style: AppTextStyles.body.copyWith(
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                        color: LS.accent,
                      ),
                    ),
                    Text(
                      '\$${kChartWorst[hoverIdx].toStringAsFixed(0)} worst case',
                      style: AppTextStyles.body.copyWith(
                        fontSize: 12,
                        color: LS.soft,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          const SizedBox(height: 10),
          RichText(
            text: TextSpan(
              style: TextStyle(fontSize: 12.5, color: LS.soft, height: 1.55),
              children: [
                TextSpan(
                  text: 'Stress test: ',
                  style: AppTextStyles.body.copyWith(
                    fontWeight: FontWeight.w700,
                    color: Colors.white,
                  ),
                ),
                TextSpan(
                  text:
                      'the worst case assumes only ~60% of the turned-away orders return and prep runs \$60/wk over — cash flattens near \$49,300 but never threatens the \$20,000 floor. ',
                  style: AppTextStyles.body.copyWith(
                    fontWeight: FontWeight.w500,
                    color: Colors.white,
                    fontSize: 12.5,
                  ),
                ),
                TextSpan(
                  text: 'Break-even in month 5 ',
                  style: AppTextStyles.body.copyWith(
                    fontWeight: FontWeight.w700,
                    color: Colors.white,
                  ),
                ),
                TextSpan(
                  text:
                      'means the recovered Friday orders have by then paid back every dollar of hire and prep since launch; from there you run ≈\$970 a month ahead.',
                  style: AppTextStyles.body.copyWith(
                    fontWeight: FontWeight.w500,
                    color: Colors.white,
                    fontSize: 12.5,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  int _nearestChartIndex(Offset pos, Size size) {
    const x0 = 42.0, x1pad = 14.0;
    final x1 = size.width - x1pad;
    final n = kChartLabels.length;
    double best = double.infinity;
    int bestI = 0;
    for (var i = 0; i < n; i++) {
      final x = x0 + i * (x1 - x0) / (n - 1);
      final d = (x - pos.dx).abs();
      if (d < best) {
        best = d;
        bestI = i;
      }
    }
    return bestI;
  }

  Widget _legendSwatch(
    Color c,
    String label, {
    bool dashed = false,
    bool dot = false,
  }) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        if (dot)
          Container(
            width: 8,
            height: 8,
            decoration: BoxDecoration(color: c, shape: BoxShape.circle),
          )
        else
          Container(
            width: 14,
            height: 3,
            decoration: BoxDecoration(
              color: c,
              borderRadius: BorderRadius.circular(2),
            ),
          ),
        const SizedBox(width: 6),
        Text(
          label,
          style: AppTextStyles.body.copyWith(fontSize: 11, color: LS.soft),
        ),
      ],
    );
  }

  Widget _actionBar() {
    return Column(
      children: [
        SizedBox(
          width: double.infinity,
          height: 50,
          child: ElevatedButton(
            onPressed: () => _openSheet(_SheetKind.save),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.black.withOpacity(.05),
              side: BorderSide(color: LS.accent.withOpacity(.55)),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              elevation: 0,
            ),
            child: Text(
              'Save scenario',
              style: AppTextStyles.body.copyWith(
                fontSize: 15,
                fontWeight: FontWeight.w600,
                color: Colors.white,
              ),
            ),
          ),
        ),
        const SizedBox(height: 9),
        Row(
          children: [
            Expanded(
              child: _ghostBtn(
                'Adjust an assumption',
                () => _openSheet(_SheetKind.adjust),
              ),
            ),
            const SizedBox(width: 9),
            Expanded(
              child: _ghostBtn(
                'New scenario',
                () => _openSheet(_SheetKind.newScenario),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _ghostBtn(String label, VoidCallback onTap) {
    return SizedBox(
      height: 50,
      child: OutlinedButton(
        onPressed: onTap,
        style: OutlinedButton.styleFrom(
          backgroundColor: Colors.white.withOpacity(.06),
          side: BorderSide(color: Colors.white.withOpacity(.24)),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
        child: Text(
          label,
          style: AppTextStyles.body.copyWith(
            fontSize: 15,
            fontWeight: FontWeight.w500,
            color: LS.soft,
          ),
        ),
      ),
    );
  }

  Widget _disclaimer() {
    return Text(
      'These projections are based on your Square and QuickBooks data plus comparable-market research. '
      'No financing is involved, so there is no lender to confirm with — but review the wage and prep figures with your accountant before you extend an offer.',
      textAlign: TextAlign.center,
      style: AppTextStyles.body.copyWith(
        fontSize: 12,
        fontStyle: FontStyle.italic,
        color: Colors.white,
        height: 1.5,
      ),
    );
  }

  Widget _followUpBar() {
    final controller = TextEditingController();
    return Container(
      padding: const EdgeInsets.fromLTRB(16, 6, 6, 6),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(99),
        border: Border.all(color: Colors.white.withOpacity(.22)),
        color: LS.scrimTop,
      ),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: controller,
              style: AppTextStyles.body.copyWith(
                color: Colors.white,
                fontSize: 14.5,
              ),
              decoration: InputDecoration(
                border: InputBorder.none,
                hintText: 'Ask a follow-up — "What if only half come back?"',
                hintStyle: AppTextStyles.body.copyWith(
                  color: Color(0x8CCFEFFB),
                ),
              ),
            ),
          ),
          SizedBox(width: 6),
          Container(
            width: 32,
            height: 32,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(color: LS.accent.withOpacity(.55)),
              color: LS.accent.withOpacity(.2),
            ),
            child: IconButton(
              padding: EdgeInsets.zero,
              icon: const Icon(
                Icons.arrow_upward_rounded,
                size: 16,
                color: Colors.white,
              ),
              onPressed: () => controller.clear(),
            ),
          ),
          SizedBox(width: 6),
        ],
      ),
    );
  }

  void _openSheet(_SheetKind kind) {
    showModalBottomSheet(
      context: context,
      backgroundColor: const Color(0xFF08364C),
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(26)),
      ),
      builder: (ctx) => _buildSheet(kind, ctx),
    );
  }

  Widget _buildSheet(_SheetKind kind, BuildContext ctx) {
    Widget content;
    switch (kind) {
      case _SheetKind.save:
        content = _saveSheet(ctx);
        break;
      case _SheetKind.newScenario:
        content = _newSheet(ctx);
        break;
      case _SheetKind.adjust:
        content = _adjustSheet(ctx);
        break;
    }
    return Padding(
      padding: EdgeInsets.only(bottom: MediaQuery.of(ctx).viewInsets.bottom),
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(22, 10, 22, 24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 40,
                height: 5,
                margin: const EdgeInsets.only(bottom: 14),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(.3),
                  borderRadius: BorderRadius.circular(99),
                ),
              ),
              content,
            ],
          ),
        ),
      ),
    );
  }

  Widget _saveSheet(BuildContext ctx) {
    final controller = TextEditingController(
      text: 'Friday Pizzaiolo + Dough Scale-Up',
    );
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Save this scenario',
          style: AppTextStyles.headline.copyWith(
            // fontFamily: _spaceGrotesk,
            fontSize: 18.5,
            fontWeight: FontWeight.w600,
            color: Colors.white,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          "It stays in your Scenario Lab history with today's assumptions and chart.",
          style: AppTextStyles.body.copyWith(
            fontSize: 13.5,
            color: LS.soft,
            height: 1.5,
          ),
        ),
        const SizedBox(height: 14),
        TextField(
          controller: controller,
          style: AppTextStyles.body.copyWith(color: Colors.white, fontSize: 14),
          decoration: InputDecoration(
            filled: true,
            fillColor: Colors.white.withOpacity(.06),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: Colors.white.withOpacity(.18)),
            ),
          ),
        ),
        const SizedBox(height: 14),
        _sheetPrimaryBtn('Confirm save', () => Navigator.pop(ctx)),
        const SizedBox(height: 9),
        _sheetGhostBtn('Cancel', () => Navigator.pop(ctx)),
      ],
    );
  }

  Widget _newSheet(BuildContext ctx) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Start a new scenario?',
          style: AppTextStyles.headline.copyWith(
            fontSize: 18.5,
            fontWeight: FontWeight.w600,
            color: Colors.white,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          'Starting fresh clears these results. You can save this one first — it takes a second.',
          style: AppTextStyles.body.copyWith(
            fontSize: 13.5,
            color: LS.soft,
            height: 1.5,
          ),
        ),
        const SizedBox(height: 14),
        _sheetPrimaryBtn('Save this scenario first', () {
          Navigator.pop(ctx);
          Future.delayed(
            const Duration(milliseconds: 180),
            () => _openSheet(_SheetKind.save),
          );
        }),
        const SizedBox(height: 9),
        _sheetGhostBtn('Start fresh', () => Navigator.pop(ctx)),
      ],
    );
  }

  Widget _adjustSheet(BuildContext ctx) {
    return StatefulBuilder(
      builder: (context, setLocal) {
        int? selected;
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Adjust an assumption',
              style: AppTextStyles.headline.copyWith(
                fontSize: 18.5,
                fontWeight: FontWeight.w600,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Tap a value to change it, then rerun.',
              style: AppTextStyles.body.copyWith(
                fontSize: 13.5,
                color: LS.soft,
                height: 1.5,
              ),
            ),
            const SizedBox(height: 6),
            ...List.generate(kAssumptions.length, (i) {
              final r = kAssumptions[i];
              return Container(
                padding: const EdgeInsets.symmetric(vertical: 10),
                decoration: BoxDecoration(
                  border: Border(
                    bottom: BorderSide(
                      color: Colors.white.withOpacity(
                        i == kAssumptions.length - 1 ? 0 : .1,
                      ),
                    ),
                  ),
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            r.label,
                            style: AppTextStyles.body.copyWith(
                              fontSize: 13.5,
                              color: LS.soft,
                            ),
                          ),
                          Text(
                            r.source,
                            style: AppTextStyles.body.copyWith(
                              fontSize: 10,
                              color: LS.soft,
                            ),
                          ),
                        ],
                      ),
                    ),
                    GestureDetector(
                      onTap: () =>
                          setLocal(() => selected = selected == i ? null : i),
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 13,
                          vertical: 7,
                        ),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(999),
                          color: LS.scrimTop,
                          border: Border.all(
                            color: selected == i
                                ? LS.accent.withOpacity(.55)
                                : Colors.white.withOpacity(.18),
                          ),
                        ),
                        child: Text(
                          r.value,
                          style: AppTextStyles.body.copyWith(
                            fontSize: 13.5,
                            fontWeight: FontWeight.w600,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              );
            }),
            const SizedBox(height: 10),
            Text(
              'Adjusting reruns the scenario.',
              style: AppTextStyles.body.copyWith(
                fontSize: 12,
                color: LS.soft,
                height: 1.5,
              ),
            ),
            const SizedBox(height: 12),
            _sheetPrimaryBtn('Rerun scenario', () => Navigator.pop(ctx)),
            const SizedBox(height: 9),
            _sheetGhostBtn('Cancel', () => Navigator.pop(ctx)),
          ],
        );
      },
    );
  }

  Widget _sheetPrimaryBtn(String label, VoidCallback onTap) => SizedBox(
    width: double.infinity,
    height: 48,
    child: ElevatedButton(
      onPressed: onTap,
      style: ElevatedButton.styleFrom(
        backgroundColor: LS.accent.withOpacity(.22),
        side: BorderSide(color: LS.accent.withOpacity(.55)),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        elevation: 0,
      ),
      child: Text(
        label,
        style: AppTextStyles.body.copyWith(
          fontSize: 15,
          fontWeight: FontWeight.w600,
          color: Colors.white,
        ),
      ),
    ),
  );

  Widget _sheetGhostBtn(String label, VoidCallback onTap) => SizedBox(
    width: double.infinity,
    height: 48,
    child: OutlinedButton(
      onPressed: onTap,
      style: OutlinedButton.styleFrom(
        backgroundColor: Colors.white.withOpacity(.06),
        side: BorderSide(color: Colors.white.withOpacity(.24)),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
      child: Text(
        label,
        style: AppTextStyles.body.copyWith(
          fontSize: 15,
          fontWeight: FontWeight.w500,
          color: LS.soft,
        ),
      ),
    ),
  );

  // // ---- drawer ------------------------------------------------------
  // Widget _buildDrawer(BuildContext context) {
  //   final items = <_DrawerItem>[
  //     _DrawerItem(0, 'Dashboard', Icons.dashboard_outlined),
  //     _DrawerItem(1, 'Demand Forecast', Icons.show_chart_rounded),
  //     _DrawerItem(2, 'Financial Overview', Icons.account_balance_outlined),
  //     _DrawerItem(3, 'Business Health', Icons.favorite_border_rounded),
  //     _DrawerItem(4, 'Opportunities', Icons.lightbulb_outline_rounded),
  //     _DrawerItem(5, 'Scenario Lab', Icons.science_outlined),
  //     _DrawerItem(6, 'Business Profile', Icons.person_outline_rounded),
  //     _DrawerItem(7, 'Settings', Icons.settings_outlined),
  //   ];
  //   return Drawer(
  //     backgroundColor: const Color(0xFF073349),
  //     child: SafeArea(
  //       child: Padding(
  //         padding: const EdgeInsets.fromLTRB(16, 20, 16, 20),
  //         child: Column(
  //           crossAxisAlignment: CrossAxisAlignment.start,
  //           children: [
  //             const Padding(
  //               padding: EdgeInsets.symmetric(horizontal: 8, vertical: 8),
  //               child: Row(
  //                 children: [
  //                   Icon(Icons.bolt_rounded, color: Colors.white, size: 24),
  //                   SizedBox(width: 9),
  //                   Text(
  //                     'LightSignal',
  //                     style: TextStyle(
  //                       fontFamily: _spaceGrotesk,
  //                       fontWeight: FontWeight.w700,
  //                       fontSize: 18,
  //                       color: Colors.white,
  //                     ),
  //                   ),
  //                 ],
  //               ),
  //             ),
  //             const SizedBox(height: 10),
  //             Expanded(
  //               child: ListView(
  //                 children: items.map((it) {
  //                   final active = it.index == _scenarioLabIndex;
  //                   return Container(
  //                     margin: const EdgeInsets.symmetric(vertical: 2),
  //                     decoration: BoxDecoration(
  //                       borderRadius: BorderRadius.circular(12),
  //                       color: active
  //                           ? LS.accent.withOpacity(.15)
  //                           : Colors.transparent,
  //                     ),
  //                     child: ListTile(
  //                       leading: Icon(
  //                         it.icon,
  //                         color: active ? Colors.white : LS.soft,
  //                         size: 20,
  //                       ),
  //                       title: Text(
  //                         it.label,
  //                         style: TextStyle(
  //                           fontSize: 15,
  //                           fontWeight: FontWeight.w500,
  //                           color: active ? Colors.white : LS.soft,
  //                         ),
  //                       ),
  //                       onTap: () => _onDrawerItemSelected(context, it.index),
  //                     ),
  //                   );
  //                 }).toList(),
  //               ),
  //             ),
  //             ListTile(
  //               leading: const Icon(
  //                 Icons.logout_rounded,
  //                 color: LS.mute,
  //                 size: 20,
  //               ),
  //               title: const Text(
  //                 'Log out',
  //                 style: TextStyle(fontSize: 15, color: LS.mute),
  //               ),
  //               onTap: () {},
  //             ),
  //           ],
  //         ),
  //       ),
  //     ),
  //   );
  // }
}

enum _SheetKind { save, newScenario, adjust }

// class _DrawerItem {
//   final int index;
//   final String label;
//   final IconData icon;
//   _DrawerItem(this.index, this.label, this.icon);
// }

// ---------------------------------------------------------------------------
// WHEEL PAINTER — annular segments + outward labels, "seen" state dims glow
// ---------------------------------------------------------------------------
class _WheelPainter extends CustomPainter {
  final int count;
  final Color color;
  final Set<int> seen;
  final List<String> labels;
  _WheelPainter({
    required this.count,
    required this.color,
    required this.seen,
    required this.labels,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final cx = size.width / 2, cy = size.height / 2;
    const ro = 118.0, ri = 48.0;
    final segAngle = 360 / count;
    const gap = 4.0;
    for (var i = 0; i < count; i++) {
      final a0 = -90.0 - segAngle / 2 + i * segAngle + gap / 2;
      final a1 = -90.0 - segAngle / 2 + (i + 1) * segAngle - gap / 2;
      final path = Path();
      final startOuter = _polar(cx, cy, ro, a0);
      path.moveTo(startOuter.dx, startOuter.dy);
      path.arcTo(
        Rect.fromCircle(center: Offset(cx, cy), radius: ro),
        _rad(a0),
        _rad(a1 - a0),
        false,
      );
      final innerEnd = _polar(cx, cy, ri, a1);
      path.lineTo(innerEnd.dx, innerEnd.dy);
      path.arcTo(
        Rect.fromCircle(center: Offset(cx, cy), radius: ri),
        _rad(a1),
        _rad(a0 - a1),
        false,
      );
      path.close();

      final isSeen = seen.contains(i);
      final paint = Paint()
        ..style = PaintingStyle.fill
        ..color = const Color(0x400C1C28);
      if (!isSeen) {
        canvas.drawShadow(path, const Color(0xFFE0F6FF), 8, false);
      }
      canvas.drawPath(path, paint);
      final borderPaint = Paint()
        ..style = PaintingStyle.stroke
        ..strokeWidth = 1.25
        ..color = Colors.white.withOpacity(.42);
      canvas.drawPath(path, borderPaint);

      // label
      final mid = (a0 + a1) / 2;
      final lp = _polar(cx, cy, ro + 26, mid);
      final tp = TextPainter(
        text: TextSpan(
          text: labels[i].length > 30
              ? '${labels[i].substring(0, 28)}…'
              : labels[i],
          style: TextStyle(
            fontSize: 10.5,
            fontWeight: FontWeight.w600,
            color: LS.soft.withOpacity(isSeen ? .85 : 1),
          ),
        ),
        textAlign: TextAlign.center,
        textDirection: TextDirection.ltr,
        maxLines: 3,
      )..layout(maxWidth: 84);
      tp.paint(canvas, Offset(lp.dx - tp.width / 2, lp.dy - tp.height / 2));
    }
  }

  double _rad(double deg) => deg * math.pi / 180;
  Offset _polar(double cx, double cy, double r, double deg) {
    final a = _rad(deg);
    return Offset(cx + r * math.cos(a), cy + r * math.sin(a));
  }

  @override
  bool shouldRepaint(covariant _WheelPainter old) =>
      old.seen.length != seen.length;
}

// ---------------------------------------------------------------------------
// CHART PAINTER — projected line (glow), worst-case dashed, floor dashed,
// low-point + break-even markers, gridlines + axis labels.
// ---------------------------------------------------------------------------
class _ChartPainter extends CustomPainter {
  final int? hoverIdx;
  _ChartPainter({this.hoverIdx});

  double _y(double v, Size size) {
    const top = 14.0, bottom = 210.0, minV = 18000.0, maxV = 56000.0;
    final h = bottom - top;
    return bottom - ((v - minV) / (maxV - minV)) * h;
  }

  double _x(int i, Size size) {
    const x0 = 42.0, rightPad = 14.0;
    final x1 = size.width - rightPad;
    return x0 + i * (x1 - x0) / (kChartLabels.length - 1);
  }

  @override
  void paint(Canvas canvas, Size size) {
    final scaleY = size.height / 240;
    Offset p(int i, double v) => Offset(_x(i, size), _y(v, size) * scaleY);

    // gridlines
    final gridPaint = Paint()
      ..color = Colors.white.withOpacity(.08)
      ..strokeWidth = 1;
    for (final gv in [55000.0, 45000.0, 35000.0, 25000.0]) {
      final y = _y(gv, size) * scaleY;
      canvas.drawLine(Offset(42, y), Offset(size.width - 14, y), gridPaint);
      _text(
        canvas,
        '\$${(gv / 1000).round()}K',
        const Offset(2, 0),
        y,
        LS.soft,
        9.5,
        anchorLeft: true,
      );
    }

    // floor dashed line
    final floorY = _y(kFloor, size) * scaleY;
    _dashedLine(
      canvas,
      Offset(42, floorY),
      Offset(size.width - 14, floorY),
      LS.warnText,
      1.25,
    );
    _text(
      canvas,
      'Reserve floor \$20,000',
      const Offset(42, 0),
      floorY - 14,
      LS.warnText,
      10,
      anchorLeft: true,
    );

    // x labels
    for (var i = 0; i < kChartLabels.length; i++) {
      _text(
        canvas,
        kChartLabels[i],
        Offset(_x(i, size), 0),
        size.height - 8,
        LS.soft,
        9.5,
        center: true,
      );
    }

    // worst-case dashed red
    for (var i = 0; i < kChartWorst.length - 1; i++) {
      _dashedLine(
        canvas,
        p(i, kChartWorst[i]),
        p(i + 1, kChartWorst[i + 1]),
        LS.crit.withOpacity(.7),
        1.75,
      );
    }

    // projected glow line
    final projPath = Path()
      ..moveTo(p(0, kChartProj[0]).dx, p(0, kChartProj[0]).dy);
    for (var i = 1; i < kChartProj.length; i++) {
      projPath.lineTo(p(i, kChartProj[i]).dx, p(i, kChartProj[i]).dy);
    }
    canvas.drawPath(
      projPath,
      Paint()
        ..style = PaintingStyle.stroke
        ..strokeWidth = 2.25
        ..color = LS.accent
        ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 3)
        ..strokeCap = StrokeCap.round,
    );
    canvas.drawPath(
      projPath,
      Paint()
        ..style = PaintingStyle.stroke
        ..strokeWidth = 2.25
        ..color = LS.accent
        ..strokeCap = StrokeCap.round,
    );

    // low point marker
    final lowPt = p(kLowIdx, kChartProj[kLowIdx]);
    canvas.drawCircle(lowPt, 3.5, Paint()..color = LS.warnText);
    _text(
      canvas,
      'Low \$50.6K',
      Offset(lowPt.dx, 0),
      lowPt.dy + 13,
      LS.warnText,
      9.5,
      center: true,
    );

    // break-even marker
    final bePt = p(kBreakEvenIdx, kChartProj[kBreakEvenIdx]);
    canvas.drawCircle(bePt, 5, Paint()..color = LS.sevResolved);
    _text(
      canvas,
      'Break-even',
      Offset(bePt.dx, 0),
      bePt.dy - 9,
      LS.sevResolved,
      9.5,
      center: true,
    );

    // hover hairline + dot
    if (hoverIdx != null) {
      final hx = _x(hoverIdx!, size);
      canvas.drawLine(
        Offset(hx, 14),
        Offset(hx, 210 * scaleY),
        Paint()..color = Colors.white.withOpacity(.3),
      );
      final hp = p(hoverIdx!, kChartProj[hoverIdx!]);
      canvas.drawCircle(hp, 4, Paint()..color = LS.accent);
      canvas.drawCircle(
        hp,
        4,
        Paint()
          ..style = PaintingStyle.stroke
          ..strokeWidth = 1.5
          ..color = LS.ink,
      );
    }
  }

  void _dashedLine(
    Canvas canvas,
    Offset a,
    Offset b,
    Color color,
    double width,
  ) {
    const dashLen = 5.0, gapLen = 4.0;
    final total = (b - a).distance;
    if (total == 0) return;
    final dir = (b - a) / total;
    double dist = 0;
    final paint = Paint()
      ..color = color
      ..strokeWidth = width;
    while (dist < total) {
      final segEnd = math.min(dist + dashLen, total);
      canvas.drawLine(a + dir * dist, a + dir * segEnd, paint);
      dist += dashLen + gapLen;
    }
  }

  void _text(
    Canvas canvas,
    String text,
    Offset pos,
    double y,
    Color color,
    double size, {
    bool center = false,
    bool anchorLeft = false,
  }) {
    final tp = TextPainter(
      text: TextSpan(
        text: text,
        style: TextStyle(
          fontSize: size,
          color: color,
          fontFeatures: const [FontFeature.tabularFigures()],
        ),
      ),
      textDirection: TextDirection.ltr,
    )..layout();
    double dx;
    if (center) {
      dx = pos.dx - tp.width / 2;
    } else if (anchorLeft) {
      dx = pos.dx;
    } else {
      dx = pos.dx - tp.width;
    }
    tp.paint(canvas, Offset(dx, y - tp.height / 2));
  }

  @override
  bool shouldRepaint(covariant _ChartPainter old) => old.hoverIdx != hoverIdx;
}
