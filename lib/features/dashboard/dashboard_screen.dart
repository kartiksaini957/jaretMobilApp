import 'package:flutter/material.dart';
import 'package:flutter_application_1/features/auth/providers/login_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../bottombar/app_bottom_bar.dart';
import '../../theme/app_theme.dart';
import '../../widgets/app_nav_drawer.dart';
import '../../widgets/customAppbar.dart';
import '../../widgets/gradient_background.dart';
import '../../widgets/shimmer_box.dart';
import 'model/dashboardModel.dart';
import 'provider/dashboardProvider.dart';
import 'widgets/greeting_card.dart';
import 'widgets/health_score_tile.dart';
import 'widgets/insight_card.dart';
import 'widgets/metric_detail_sheet.dart';
import 'widgets/reminders_card.dart';
import 'widgets/stat_tile.dart';
import '../../utils/pref_utils.dart';
import '../../widgets/app_nav_destinations.dart';

class DashboardScreen extends ConsumerStatefulWidget {
  const DashboardScreen({
    super.key,
    this.initialTabIndex = 0,
    this.initialDrawerIndex = 0,
  });

  final int initialTabIndex;
  final int initialDrawerIndex;

  @override
  ConsumerState<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends ConsumerState<DashboardScreen> {
  static const _bottomItems = [
    BottomBarItem(icon: Icons.check_circle_outline, badgeCount: 1),
    BottomBarItem(icon: Icons.flag_outlined, badgeCount: 3),
    BottomBarItem(image: 'assets/images/light.png', badgeCount: 1),
    BottomBarItem(image: 'assets/images/infniti.png', badgeCount: 3),
    BottomBarItem(icon: Icons.bar_chart, badgeCount: 5),
    BottomBarItem(icon: Icons.chat),
  ];

  late int _selectedTab = widget.initialTabIndex;
  String? _cachedName;

  @override
  void initState() {
    super.initState();
    PrefUtils.getUserName().then((name) {
      if (mounted && name != null && name.isNotEmpty) {
        setState(() => _cachedName = name);
      }
    });
  }

  void _onDrawerItemSelected(int index) {
    openNavDestination(context, index, currentIndex: AppNavIndex.dashboard);
  }

  Widget _buildLowerSection() {
    switch (_selectedTab) {
      case 1:
        return const _FlagsSection(key: ValueKey('flags'));
      case 2:
        return const _OpportunitiesSection(key: ValueKey('opportunities'));
      case 3:
        return const _TrendsSection(key: ValueKey('trends'));
      case 4:
        return const _NumbersSection(key: ValueKey('numbers'));
      case 5:
        return const _AskAiSection(key: ValueKey('ask_ai'));
      default:
        return const _WhatToActOnSection(key: ValueKey('actions'));
    }
  }

  @override
  Widget build(BuildContext context) {
    final dashboardInsights = ref.watch(dashboardInsightsProvider);
    return Scaffold(
      extendBody: true,
      appBar: const CustomAppBar(
        title: 'Dashboard',
        hasUnreadNotifications: true,
      ),
      drawer: AppNavDrawer(
        selectedIndex: widget.initialDrawerIndex,
        onItemSelected: _onDrawerItemSelected,
      ),
      body: GradientBackground(
        child: SafeArea(
          top: false,
          child: Stack(
            children: [
              SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(20, 16, 20, 110),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    GreetingCard(
                      name:
                          ref.watch(loginControllerProvider).user?.name ??
                          _cachedName ??
                          '',
                      summary: dashboardInsights.when(
                        loading: () => 'Loading...',
                        error: (error, _) => 'Unable to load summary.',
                        data: (data) => data.data.summary,
                      ),
                    ),
                    const SizedBox(height: 20),
                    Text('UPCOMING REMINDERS', style: AppTextStyles.eyebrow),
                    const SizedBox(height: 10),
                    const _RemindersSection(),
                    const SizedBox(height: 20),
                    AnimatedSwitcher(
                      duration: const Duration(milliseconds: 160),
                      switchInCurve: Curves.easeOut,
                      switchOutCurve: Curves.easeIn,
                      child: _buildLowerSection(),
                    ),
                  ],
                ),
              ),
              Positioned(
                left: 20,
                right: 20,
                bottom: 16,
                child: AppBottomBar(
                  items: _bottomItems,
                  selectedIndex: _selectedTab,
                  onTap: (index) => setState(() => _selectedTab = index),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _RemindersSection extends ConsumerWidget {
  const _RemindersSection();
  Color _dotColorFor(String priority) {
    switch (priority) {
      case 'critical':
        return AppColors.crit;
      case 'high':
        return AppColors.warnDot;
      default:
        return Color(0x80FFFFFF);
    }
  }

  String _subtitleFor(ActionItem item) {
    final daysPart = item.daysUntilDue < 0
        ? 'overdue by ${-item.daysUntilDue} days'
        : item.daysUntilDue == 0
        ? 'today'
        : 'in ${item.daysUntilDue} days';
    if (item.category.isNotEmpty) {
      return '$daysPart · ${item.category}';
    }
    return daysPart;
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final reminders = ref.watch(dashboardRemindersProvider);
    return reminders.when(
      loading: () => const Column(
        children: [
          ShimmerBox(height: 44, borderRadius: 14),
          SizedBox(height: 10),
          ShimmerBox(height: 44, borderRadius: 14),
          SizedBox(height: 10),
          ShimmerBox(height: 44, borderRadius: 14),
        ],
      ),
      error: (error, stackTrace) => Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        decoration: BoxDecoration(
          color: AppColors.glassDark,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: AppColors.glassBorder),
        ),
        child: Row(
          children: [
            Expanded(
              child: Text(
                'Couldn\'t load reminders.',
                style: AppTextStyles.body.copyWith(color: AppColors.faintText),
              ),
            ),
            TextButton(
              onPressed: () => ref.refresh(dashboardRemindersProvider),
              child: Text('Retry', style: AppTextStyles.body),
            ),
          ],
        ),
      ),
      data: (items) {
        if (items.isEmpty) {
          return Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
            decoration: BoxDecoration(
              color: AppColors.glassDark,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: AppColors.glassBorder),
            ),
            child: Text(
              'Nothing pending right now.',
              style: AppTextStyles.body.copyWith(
                color: AppColors.faintText,
                fontSize: 13.5,
                fontWeight: FontWeight.w400,
              ),
            ),
          );
        }
        return RemindersCard(
          reminders: [
            for (final item in items)
              ReminderData(
                dotColor: _dotColorFor(item.priority),
                title: item.label,
                subtitle: _subtitleFor(item),
                subtitleColor: item.priority == 'critical'
                    ? AppColors.urgent
                    : null,
              ),
          ],
        );
      },
    );
  }
}

class _WhatToActOnSection extends StatelessWidget {
  const _WhatToActOnSection({super.key});
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('WHAT TO ACT ON', style: AppTextStyles.eyebrow),
        const SizedBox(height: 10),
        const InsightCard(
          dotColor: AppColors.warnDot,
          label: 'THE ISSUE',
          headline:
              'Food cost crept to 31% of revenue — 3 pts above your '
              'healthy range, driven by produce price spikes.',
        ),
        const SizedBox(height: 12),
        const InsightCard(
          dotColor: Color(0xFFA6F5DC),
          label: 'THE MOVE',
          body:
              'Lock a produce contract. Restaurant Depot is \$42/case on '
              'avocados vs your current \$49.',
          bodyColor: Color(0xFFA6F5DC),
        ),
      ],
    );
  }
}

class _FlagsSection extends StatelessWidget {
  const _FlagsSection({super.key});
  static const _flags = [
    (AppColors.goodText, 'Revenue ahead of target by 12%'),
    (AppColors.warnDot, 'Food cost up 3.1 pts vs Dec'),
    (AppColors.warnDot, '17 invoices overdue (\$9,240)'),
  ];
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('FLAGS', style: AppTextStyles.eyebrow),
        const SizedBox(height: 10),
        for (var i = 0; i < _flags.length; i++) ...[
          if (i > 0) const SizedBox(height: 10),
          _FlagTile(dotColor: _flags[i].$1, text: _flags[i].$2),
        ],
      ],
    );
  }
}

class _FlagTile extends StatelessWidget {
  const _FlagTile({required this.dotColor, required this.text});
  final Color dotColor;
  final String text;
  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      decoration: BoxDecoration(
        color: AppColors.glassDark,
        borderRadius: BorderRadius.circular(14),
      ),
      child: Row(
        children: [
          Container(
            width: 8,
            height: 8,
            decoration: BoxDecoration(color: dotColor, shape: BoxShape.circle),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              text,
              style: AppTextStyles.body.copyWith(
                fontSize: 13.5,
                color: Colors.white,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _OpportunitiesSection extends StatelessWidget {
  const _OpportunitiesSection({super.key});
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('OPPORTUNITIES', style: AppTextStyles.eyebrow),
        const SizedBox(height: 10),
        const InsightCard(
          dotColor: Color(0xFF5FE0FF),
          label: 'OPPORTUNITY',
          headline: 'Catering inquiries up 40%',
          body:
              'A fixed catering menu could capture demand you\'re turning '
              'away.',
        ),
      ],
    );
  }
}

class _TrendsSection extends StatelessWidget {
  const _TrendsSection({super.key});
  static const _changes = [
    ('Revenue', '+\$7,080 vs Jan, led by weekend dinner covers'),
    ('Food cost', '+3.1 pts on produce'),
    ('Overdue', '17 clients moved past 30 days'),
  ];
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('WHAT CHANGED', style: AppTextStyles.eyebrow),
        const SizedBox(height: 10),
        for (var i = 0; i < _changes.length; i++) ...[
          if (i > 0) const SizedBox(height: 10),
          _ChangeTile(label: _changes[i].$1, detail: _changes[i].$2),
        ],
      ],
    );
  }
}

class _ChangeTile extends StatelessWidget {
  const _ChangeTile({required this.label, required this.detail});
  final String label;
  final String detail;
  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      decoration: BoxDecoration(
        color: AppColors.glassDark,
        borderRadius: BorderRadius.circular(14),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 82,
            child: Text(
              label,
              style: AppTextStyles.eyebrow.copyWith(
                fontSize: 13.5,
                color: AppColors.mutedText,
              ),
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              detail,
              style: AppTextStyles.body.copyWith(
                color: AppColors.mutedText,
                fontSize: 13.5,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _NumbersSection extends StatelessWidget {
  const _NumbersSection({super.key});
  static const _revenue = MetricDetail(
    title: 'Revenue MTD',
    value: '\$45,230',
    badgeLabel: 'Top tier',
    badgeColor: AppColors.goodText,
    comparisons: [
      ComparisonView(
        label: 'Vs Last Month',
        body:
            'Revenue is pacing 18.5% ahead of January and on track for a '
            'record month, carried by weekend dinner covers.',
        changeText: 'Up \$7,080 (\$38.2K → \$45.2K)',
      ),
      ComparisonView(
        label: 'Vs Peer.s',
        body:
            'At \$45.2K month-to-date you\'re running ahead of the \$38K '
            'median for similar businesses by size and industry — top '
            'quartile for the month so far.',
        changeText: '\$45.2K vs \$38K peer median · top quartile',
      ),
    ],
    drivers: [
      MetricDriver(
        title: 'Weekend dinner covers up 22%',
        subtitle: 'Traffic mix',
        delta: '+\$5,100',
        isPositive: true,
      ),
      MetricDriver(
        title: 'Catering pickup orders',
        subtitle: 'New channel',
        delta: '+\$1,600',
        isPositive: true,
      ),
      MetricDriver(
        title: 'Two soft weekday lunches',
        subtitle: 'Daypart',
        delta: '-\$620',
        isPositive: false,
      ),
    ],
    actions: [
      SuggestedAction(
        severity: ActionSeverity.high,
        text:
            'Lock in the weekend staffing that\'s driving covers before '
            'demand outruns the kitchen.',
      ),
      SuggestedAction(
        severity: ActionSeverity.med,
        text:
            'Formalize catering as a standing menu line — it\'s already material.',
      ),
    ],
    confidence: 'High (98% data coverage · POS synced 2h ago)',
  );

  static const _netMargin = MetricDetail(
    title: 'Net Margin %',
    value: '13.8%',
    badgeLabel: 'Above avg',
    badgeColor: AppColors.goodText,
    comparisons: [
      ComparisonView(
        label: 'Vs Last Month',
        body:
            'Net margin rose 1.2 points to 13.8% — above your target '
            'band, as revenue growth outpaced cost creep.',
        changeText: 'Up 1.2 pts (12.6% → 13.8%)',
      ),
      ComparisonView(
        label: 'Vs Peers',
        body:
            'Your 13.8% net margin sits above the 11.5% median for '
            'similar businesses by size and industry — top third for '
            'the category.',
        changeText: '13.8% vs 11.5% peer median · top third',
      ),
    ],
    drivers: [
      MetricDriver(
        title: 'Revenue grew faster than fixed cost',
        subtitle: 'Operating leverage',
        delta: '+1.6 pts',
        isPositive: true,
      ),
      MetricDriver(
        title: 'Produce price spikes',
        subtitle: 'Food cost',
        delta: '-0.7 pts',
        isPositive: false,
      ),
      MetricDriver(
        title: 'Lower card-processing fees',
        subtitle: 'Payments',
        delta: '+0.3 pts',
        isPositive: true,
      ),
    ],
    actions: [
      SuggestedAction(
        severity: ActionSeverity.med,
        text:
            'Hold the line on food cost — it\'s the only thing pulling margin down.',
      ),
      SuggestedAction(
        severity: ActionSeverity.low,
        text: 'Bank the processing-fee win; renegotiate again at renewal.',
      ),
    ],
    confidence: 'High (95% data coverage)',
  );

  static const _cashFlow = MetricDetail(
    title: 'Cash Flow MTD',
    value: '+\$8,410',
    badgeLabel: 'Above avg',
    badgeColor: AppColors.goodText,
    comparisons: [
      ComparisonView(
        label: 'Vs Last Month',
        body:
            'Cash flow is positive at +\$8,410 month-to-date, with '
            'collections outpacing outflows even after payroll.',
        changeText: 'Up \$6,120 (+\$2,290 → +\$8,410)',
      ),
    ],
    drivers: [
      MetricDriver(
        title: 'Faster customer collections',
        subtitle: 'Receivables',
        delta: '+\$5,400',
        isPositive: true,
      ),
      MetricDriver(
        title: 'Deferred a supplier payment',
        subtitle: 'Payables timing',
        delta: '+\$2,100',
        isPositive: true,
      ),
      MetricDriver(
        title: 'Quarterly tax set-aside',
        subtitle: 'Reserve',
        delta: '-\$1,900',
        isPositive: false,
      ),
    ],
    actions: [
      SuggestedAction(
        severity: ActionSeverity.med,
        text: 'Keep the collections cadence that pulled receivables in early.',
      ),
      SuggestedAction(
        severity: ActionSeverity.low,
        text:
            'Set the tax reserve aside weekly so it doesn\'t bunch up at quarter-end.',
      ),
    ],
    confidence: 'High (96% data coverage)',
  );

  static const _runway = MetricDetail(
    title: 'Runway',
    value: '8.0 mo',
    badgeLabel: 'Below avg',
    badgeColor: AppColors.yellow,
    comparisons: [
      ComparisonView(
        label: 'Vs Last Month',
        body:
            'At the current burn you have about 8 months of runway — '
            'workable, but thinner than the cushion most peers carry, so '
            'keep an eye on it.',
        changeText: 'Down 0.6 mo (8.6 → 8.0 mo)',
        changeIsPositive: false,
      ),
      ComparisonView(
        label: 'Vs Peers',
        body:
            'Your 8.0 months of runway is below the 10.5-month median '
            'most peers in your category carry — worth tightening up.',
        changeText: '8.0 mo vs 10.5 mo peer median · below avg',
        changeIsPositive: false,
      ),
    ],
    drivers: [
      MetricDriver(
        title: 'Burn ticked up on seasonal hiring',
        subtitle: 'Payroll',
        delta: '-0.5 mo',
        isPositive: false,
      ),
      MetricDriver(
        title: 'One-off equipment purchase',
        subtitle: 'Capex',
        delta: '-0.3 mo',
        isPositive: false,
      ),
      MetricDriver(
        title: 'Positive cash flow offset some',
        subtitle: 'Operations',
        delta: '+0.2 mo',
        isPositive: true,
      ),
    ],
    actions: [
      SuggestedAction(
        severity: ActionSeverity.high,
        text:
            'Rebuild the buffer toward 10–11 months before the next slow season.',
      ),
      SuggestedAction(
        severity: ActionSeverity.med,
        text: 'Convert the equipment spend to a lease to smooth the hit.',
      ),
    ],
    confidence: 'High (97% data coverage)',
  );

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('NUMBERS', style: AppTextStyles.eyebrow),
        const SizedBox(height: 10),
        Row(
          children: [
            Expanded(
              child: StatTile(
                label: 'REVENUE MTD',
                value: '\$45,230',
                delta: '+18.5% vs Jan',
                onTap: () => showMetricDetailSheet(context, _revenue),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: StatTile(
                label: 'NET MARGIN',
                value: '13.8%',
                delta: '+1.2 pts',
                tagLabel: 'Ahead of target',
                tagColor: AppColors.goodText,
                onTap: () => showMetricDetailSheet(context, _netMargin),
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            Expanded(
              child: StatTile(
                label: 'CASH FLOW MTD',
                value: '+\$8,410',
                delta: 'inflow positive',
                onTap: () => showMetricDetailSheet(context, _cashFlow),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: StatTile(
                label: 'RUNWAY',
                value: '8.0 mo',
                delta: 'at current burn',
                tagLabel: 'Watch cash',
                tagColor: AppColors.yellow,
                onTap: () => showMetricDetailSheet(context, _runway),
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        const HealthScoreTile(
          label: 'HEALTH SCORE',
          value: '78',
          rangeLabel: '0–100 overall',
        ),
      ],
    );
  }
}

class _AskAiSection extends StatelessWidget {
  const _AskAiSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('ASK AI', style: AppTextStyles.eyebrow),
        const SizedBox(height: 14),
        Row(
          children: [
            OutlinedButton.icon(
              onPressed: () {},
              icon: const Icon(
                Icons.chat_outlined,
                size: 15,
                color: AppColors.white,
              ),
              label: Text(
                'Chats',
                style: AppTextStyles.body.copyWith(
                  fontSize: 13.0,
                  color: AppColors.white,
                  // fontSize: 13,
                  fontWeight: FontWeight.w600,
                ),
              ),
              style: OutlinedButton.styleFrom(
                side: const BorderSide(color: AppColors.glassBorder),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
              ),
            ),
            const Spacer(),
            OutlinedButton.icon(
              onPressed: () {},
              icon: const Icon(Icons.add, size: 15, color: AppColors.white),
              label: Text(
                'New',
                style: AppTextStyles.body.copyWith(
                  fontSize: 13.0,
                  color: AppColors.white,
                  // fontSize: 13,
                  fontWeight: FontWeight.w600,
                ),
              ),
              style: OutlinedButton.styleFrom(
                side: const BorderSide(color: AppColors.glassBorder),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 36),
        Center(
          child: Text(
            'Ask anything about your business to start a conversation. '
            'Follow-ups stay in the same thread.',
            textAlign: TextAlign.center,
            style: AppTextStyles.body.copyWith(color: Color(0xFFA7DCF0)),
          ),
        ),
        const SizedBox(height: 36),
      ],
    );
  }
}
