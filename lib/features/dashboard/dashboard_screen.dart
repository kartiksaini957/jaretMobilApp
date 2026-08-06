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
import 'model/dashboardNumber.dart';
import 'model/dashboardTabsModel.dart';
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
                        error: (error, _) =>
                            'No insights available yet — check back once your data has synced.',
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
                'No reminders right now.',
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

/// Wraps a lower-tab section that reads from `dashboardInsightsProvider`:
/// eyebrow title first, then shimmer while loading, a retry row on error,
/// or an empty-state line when the API returns nothing for that field.
class _InsightsSection<T> extends ConsumerWidget {
  const _InsightsSection({
    super.key,
    required this.title,
    required this.select,
    required this.builder,
    required this.emptyText,
    this.shimmerCount = 3,
    this.shimmerHeight = 44,
  });

  final String title;
  final List<T> Function(BusinessHealthData data) select;
  final Widget Function(BuildContext context, List<T> items) builder;
  final String emptyText;
  final int shimmerCount;
  final double shimmerHeight;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final insights = ref.watch(dashboardInsightsProvider);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title, style: AppTextStyles.eyebrow),
        const SizedBox(height: 10),
        insights.when(
          loading: () => Column(
            children: [
              for (var i = 0; i < shimmerCount; i++) ...[
                if (i > 0) const SizedBox(height: 10),
                ShimmerBox(height: shimmerHeight, borderRadius: 14),
              ],
            ],
          ),
          error: (error, stackTrace) => _InsightsMessageTile(
            text: 'Couldn\'t load insights.',
            onRetry: () => ref.refresh(dashboardInsightsProvider),
          ),
          data: (response) {
            final items = select(response.data);
            if (items.isEmpty) {
              return _InsightsMessageTile(text: emptyText);
            }
            return builder(context, items);
          },
        ),
      ],
    );
  }
}

class _InsightsMessageTile extends StatelessWidget {
  const _InsightsMessageTile({required this.text, this.onRetry});
  final String text;
  final VoidCallback? onRetry;

  @override
  Widget build(BuildContext context) {
    return Container(
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
              text,
              style: AppTextStyles.body.copyWith(
                color: AppColors.faintText,
                fontSize: 13.5,
                fontWeight: FontWeight.w400,
              ),
            ),
          ),
          if (onRetry != null)
            TextButton(
              onPressed: onRetry,
              child: Text('Retry', style: AppTextStyles.body),
            ),
        ],
      ),
    );
  }
}

class _WhatToActOnSection extends StatelessWidget {
  const _WhatToActOnSection({super.key});
  @override
  Widget build(BuildContext context) {
    return _InsightsSection<InsightPair>(
      title: 'WHAT TO ACT ON',
      select: (data) => data.insightPairs,
      emptyText: 'Nothing needs action right now.',
      shimmerCount: 2,
      shimmerHeight: 92,
      builder: (context, pairs) => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          for (var i = 0; i < pairs.length; i++) ...[
            if (i > 0) const SizedBox(height: 20),
            InsightCard(
              dotColor: AppColors.warnDot,
              label: 'THE ISSUE',
              headline: pairs[i].problem,
            ),
            const SizedBox(height: 12),
            InsightCard(
              dotColor: AppColors.goodText,
              label: 'THE MOVE',
              body: pairs[i].solution,
              bodyColor: AppColors.goodText,
            ),
          ],
        ],
      ),
    );
  }
}

class _FlagsSection extends StatelessWidget {
  const _FlagsSection({super.key});

  /// Positive alerts read green regardless of severity; otherwise the
  /// severity drives the dot: high → red, medium → amber, low → soft.
  static Color _dotColorFor(AlertModel alert) {
    if (alert.type == 'positive') return AppColors.goodText;
    switch (alert.severity) {
      case 'high':
        return AppColors.critDot;
      case 'medium':
        return AppColors.warnDot;
      default:
        return AppColors.soft;
    }
  }

  @override
  Widget build(BuildContext context) {
    return _InsightsSection<AlertModel>(
      title: 'FLAGS',
      select: (data) => data.alerts,
      emptyText: 'No flags right now.',
      builder: (context, alerts) => Column(
        children: [
          for (var i = 0; i < alerts.length; i++) ...[
            if (i > 0) const SizedBox(height: 10),
            _FlagTile(
              dotColor: _dotColorFor(alerts[i]),
              // icon: alerts[i].icon,
              text: alerts[i].message,
            ),
          ],
        ],
      ),
    );
  }
}

class _FlagTile extends StatelessWidget {
  const _FlagTile({required this.dotColor, required this.text, this.icon});
  final Color dotColor;
  final String text;
  final String? icon;
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
          Container(
            width: 8,
            height: 8,
            margin: const EdgeInsets.only(top: 5),
            decoration: BoxDecoration(color: dotColor, shape: BoxShape.circle),
          ),
          const SizedBox(width: 10),
          if (icon != null && icon!.isNotEmpty) ...[
            Text(icon!, style: const TextStyle(fontSize: 13.5)),
            const SizedBox(width: 8),
          ],
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
    return _InsightsSection<String>(
      title: 'OPPORTUNITIES',
      select: (data) => data.opportunities,
      emptyText: 'No opportunities surfaced right now.',
      shimmerCount: 2,
      shimmerHeight: 76,
      builder: (context, items) => Column(
        children: [
          for (var i = 0; i < items.length; i++) ...[
            if (i > 0) const SizedBox(height: 12),
            InsightCard(
              dotColor: AppColors.accent,
              label: 'OPPORTUNITY',
              body: items[i],
            ),
          ],
        ],
      ),
    );
  }
}

class _TrendsSection extends StatelessWidget {
  const _TrendsSection({super.key});
  @override
  Widget build(BuildContext context) {
    return _InsightsSection<String>(
      title: 'WHAT CHANGED',
      select: (data) => data.whatChanged,
      emptyText: 'Nothing changed since the last period.',
      builder: (context, items) => Column(
        children: [
          for (var i = 0; i < items.length; i++) ...[
            if (i > 0) const SizedBox(height: 10),
            _ChangeTile(detail: items[i]),
          ],
        ],
      ),
    );
  }
}

class _ChangeTile extends StatelessWidget {
  const _ChangeTile({required this.detail});
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
          Container(
            width: 8,
            height: 8,
            margin: const EdgeInsets.only(top: 5),
            decoration: const BoxDecoration(
              color: AppColors.accent,
              shape: BoxShape.circle,
            ),
          ),
          const SizedBox(width: 10),
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

/// Formats a KPI amount as `$45,230` / `-$1,240` — no `intl` dependency in
/// this project, so the thousands separators are grouped by hand.
String _formatCurrency(num amount) {
  final rounded = amount.round();
  final digits = rounded.abs().toString();
  final buffer = StringBuffer();
  for (var i = 0; i < digits.length; i++) {
    if (i > 0 && (digits.length - i) % 3 == 0) buffer.write(',');
    buffer.write(digits[i]);
  }
  return '${rounded < 0 ? '-' : ''}\$$buffer';
}

String _formatSignedCurrency(num amount) =>
    amount >= 0 ? '+${_formatCurrency(amount)}' : _formatCurrency(amount);

String _formatSigned(num value, String suffix, {int decimals = 1}) {
  final text = value.abs().toStringAsFixed(decimals);
  return '${value < 0 ? '-' : '+'}$text$suffix';
}

class _NumbersSection extends ConsumerWidget {
  const _NumbersSection({super.key});

  /// Percent change vs the prior period. Returns null when the prior value
  /// is zero, since there's no meaningful base to compare against.
  static String? _percentDelta(KpiValue kpi) {
    if (kpi.priorValue == 0) return null;
    final change = (kpi.value - kpi.priorValue) / kpi.priorValue.abs() * 100;
    return '${_formatSigned(change, '%')} vs prior';
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final kpis = ref.watch(dashboardKpisProvider);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('NUMBERS', style: AppTextStyles.eyebrow),
        const SizedBox(height: 10),
        kpis.when(
          loading: () => const Column(
            children: [
              Row(
                children: [
                  Expanded(child: ShimmerBox(height: 92, borderRadius: 14)),
                  SizedBox(width: 12),
                  Expanded(child: ShimmerBox(height: 92, borderRadius: 14)),
                ],
              ),
              SizedBox(height: 12),
              Row(
                children: [
                  Expanded(child: ShimmerBox(height: 92, borderRadius: 14)),
                  SizedBox(width: 12),
                  Expanded(child: ShimmerBox(height: 92, borderRadius: 14)),
                ],
              ),
              SizedBox(height: 12),
              ShimmerBox(height: 72, borderRadius: 14),
            ],
          ),
          error: (error, stackTrace) => _InsightsMessageTile(
            text: 'No KPI data available yet.',
            onRetry: () => ref.refresh(dashboardKpisProvider),
          ),
          data: (response) => _buildTiles(context, response.data.kpis),
        ),
      ],
    );
  }

  Widget _buildTiles(BuildContext context, DashboardKpis kpis) {
    final margin = kpis.netMarginPct;
    final runway = kpis.runwayMonths;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Expanded(
              child: StatTile(
                label: 'REVENUE MTD',
                value: _formatCurrency(kpis.revenueMtd.value),
                delta: _percentDelta(kpis.revenueMtd) ?? 'no prior period',
                onTap: () => showMetricDetailSheet(context, _revenue),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: StatTile(
                label: 'NET MARGIN',
                value: '${margin.value.toStringAsFixed(1)}%',
                delta: _formatSigned(margin.value - margin.priorValue, ' pts'),
                tagLabel: margin.value >= margin.priorValue
                    ? 'Ahead of prior'
                    : 'Below prior',
                tagColor: margin.value >= margin.priorValue
                    ? AppColors.goodText
                    : AppColors.yellow,
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
                label: 'CASH',
                value: _formatCurrency(kpis.cash.value),
                delta:
                    '${_formatSignedCurrency(kpis.cash.value - kpis.cash.priorValue)} vs prior',
                onTap: () => showMetricDetailSheet(context, _cashFlow),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: StatTile(
                label: 'RUNWAY',
                value: '${runway.value.toStringAsFixed(1)} mo',
                delta: 'at current burn',
                tagLabel: runway.value < 3 ? 'Watch cash' : null,
                tagColor: runway.value < 3 ? AppColors.yellow : null,
                onTap: () => showMetricDetailSheet(context, _runway),
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        HealthScoreTile(
          label: 'HEALTH SCORE',
          value: kpis.aiHealthScore.value.round().toString(),
          rangeLabel: '0–100 overall',
        ),
      ],
    );
  }

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
