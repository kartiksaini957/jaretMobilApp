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

  /// Opens the metric sheet for one KPI — this is what triggers the
  /// `/dashboard/kpi-explain` call.
  static void _openDetail(
    BuildContext context, {
    required String title,
    required String value,
    required String kpiName,
    required KpiValue kpi,
    required String formatType,
  }) {
    showMetricDetailSheet(
      context,
      title: title,
      value: value,
      args: KpiExplainArgs(
        kpiName: kpiName,
        currentValue: kpi.value,
        priorValue: kpi.priorValue,
        formatType: formatType,
      ),
    );
  }

  Widget _buildTiles(BuildContext context, DashboardKpis kpis) {
    final margin = kpis.netMarginPct;
    final runway = kpis.runwayMonths;
    final revenueValue = _formatCurrency(kpis.revenueMtd.value);
    final marginValue = '${margin.value.toStringAsFixed(1)}%';
    final cashValue = _formatCurrency(kpis.cash.value);
    final runwayValue = '${runway.value.toStringAsFixed(1)} mo';
    final healthValue = kpis.aiHealthScore.value.round().toString();
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Expanded(
              child: StatTile(
                label: 'REVENUE MTD',
                value: revenueValue,
                delta: _percentDelta(kpis.revenueMtd) ?? 'no prior period',
                onTap: () => _openDetail(
                  context,
                  title: 'Revenue MTD',
                  value: revenueValue,
                  kpiName: 'revenue_mtd',
                  kpi: kpis.revenueMtd,
                  formatType: 'currency',
                ),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: StatTile(
                label: 'NET MARGIN',
                value: marginValue,
                delta: _formatSigned(margin.value - margin.priorValue, ' pts'),
                tagLabel: margin.value >= margin.priorValue
                    ? 'Ahead of prior'
                    : 'Below prior',
                tagColor: margin.value >= margin.priorValue
                    ? AppColors.goodText
                    : AppColors.yellow,
                onTap: () => _openDetail(
                  context,
                  title: 'Net Margin %',
                  value: marginValue,
                  kpiName: 'net_margin_pct',
                  kpi: margin,
                  formatType: 'percent',
                ),
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
                value: cashValue,
                delta:
                    '${_formatSignedCurrency(kpis.cash.value - kpis.cash.priorValue)} vs prior',
                onTap: () => _openDetail(
                  context,
                  title: 'Cash',
                  value: cashValue,
                  kpiName: 'cash',
                  kpi: kpis.cash,
                  formatType: 'currency',
                ),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: StatTile(
                label: 'RUNWAY',
                value: runwayValue,
                delta: 'at current burn',
                tagLabel: runway.value < 3 ? 'Watch cash' : null,
                tagColor: runway.value < 3 ? AppColors.yellow : null,
                onTap: () => _openDetail(
                  context,
                  title: 'Runway',
                  value: runwayValue,
                  kpiName: 'runway_months',
                  kpi: runway,
                  formatType: 'number',
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        HealthScoreTile(
          label: 'HEALTH SCORE',
          value: healthValue,
          rangeLabel: '0–100 overall',
          onTap: () => _openDetail(
            context,
            title: 'Health Score',
            value: healthValue,
            kpiName: 'ai_health_score',
            kpi: kpis.aiHealthScore,
            formatType: 'number',
          ),
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
