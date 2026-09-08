import 'package:flutter/material.dart';

import '../../../core/api_services.dart';
import '../../../theme/app_theme.dart';
import '../../../utils/pref_utils.dart';
import '../../../widgets/gradient_background.dart';
import '../../../widgets/shimmer_box.dart';
import '../model/dashboardNumberDetail.dart' as kpi_detail;
import '../provider/dashboardProvider.dart';

enum ActionSeverity { high, med, low }

extension on ActionSeverity {
  String get label => switch (this) {
    ActionSeverity.high => 'HIGH',
    ActionSeverity.med => 'MED',
    ActionSeverity.low => 'LOW',
  };

  Color get color => switch (this) {
    ActionSeverity.high => AppColors.urgent,
    ActionSeverity.med => AppColors.yellow,
    ActionSeverity.low => AppColors.accent,
  };
}

class MetricDriver {
  const MetricDriver({
    required this.title,
    required this.subtitle,
    required this.delta,
    this.isPositive,
  });

  final String title;
  final String subtitle;
  final String delta;
  final bool? isPositive;
}

class SuggestedAction {
  const SuggestedAction({
    required this.severity,
    required this.text,
    this.effort,
  });

  final ActionSeverity severity;
  final String text;
  final String? effort;
}
class ComparisonView {
  const ComparisonView({
    required this.label,
    required this.body,
    required this.changeText,
    this.changeIsPositive = true,
  });

  final String label;
  final String body;
  final String changeText;
  final bool? changeIsPositive;
}

/// Everything needed to render a [MetricDetailSheet] for one stat tile.
class MetricDetail {
  const MetricDetail({
    required this.title,
    required this.value,
    required this.badgeLabel,
    required this.badgeColor,
    required this.comparisons,
    required this.drivers,
    required this.actions,
    required this.confidence,
  });

  final String title;
  final String value;
  final String badgeLabel;
  final Color badgeColor;
  final List<ComparisonView> comparisons;
  final List<MetricDriver> drivers;
  final List<SuggestedAction> actions;
  final String confidence;
}

Future<void> showMetricDetailSheet(
  BuildContext context, {
  required String title,
  required String value,
  required KpiExplainArgs args,
}) {
  return showModalBottomSheet(
    context: context,
    backgroundColor: Colors.transparent,
    isScrollControlled: true,
    builder: (context) =>
        _MetricDetailLoader(title: title, value: value, args: args),
  );
}

MetricDetail _toMetricDetail({
  required String title,
  required String value,
  required kpi_detail.RevenueInsightData data,
}) {
  final lastPeriod = data.comparison.vsLastPeriod;
  final comparisons = <ComparisonView>[
    ComparisonView(
      label: 'Vs Last Month',
      body: data.verdict,
      changeText: lastPeriod.changeText,
      changeIsPositive: switch (lastPeriod.direction) {
        'up' => true,
        'down' => false,
        _ => null,
      },
    ),
  ];

  final peers = data.comparison.vsPeers;
  final peerGap = peers.gapText?.toString();
  if (peerGap != null && peerGap.isNotEmpty) {
    comparisons.add(
      ComparisonView(
        label: 'Vs Peers',
        body: data.verdict,
        changeText: peerGap,
        changeIsPositive: null,
      ),
    );
  }

  final target = data.comparison.vsTarget;
  final targetGap = target.gapText?.toString();
  if (targetGap != null && targetGap.isNotEmpty) {
    comparisons.add(
      ComparisonView(
        label: 'Vs Target',
        body: data.verdict,
        changeText: targetGap,
        changeIsPositive: switch (target.onTrack) {
          true => true,
          false => false,
          _ => null,
        },
      ),
    );
  }

  final confidence = data.dataConfidence;
  return MetricDetail(
    title: title,
    value: value,
    badgeLabel: _statusLabel(data.status),
    badgeColor: _statusColor(data.status),
    comparisons: comparisons,
    drivers: [
      for (final driver in data.drivers)
        MetricDriver(
          title: driver.description,
          subtitle: driver.category,
          delta: driver.impact,
        ),
    ],
    actions: [
      for (final action in data.actions)
        SuggestedAction(
          severity: _severityOf(action.priority),
          text: action.description,
          effort: action.effort,
        ),
    ],
    confidence: confidence.label.isEmpty
        ? '${confidence.score}% data coverage'
        : '${confidence.label} (${confidence.score}% data coverage)',
  );
}

String _statusLabel(String status) =>
    status.isEmpty ? '—' : status.replaceAll('_', ' ').toUpperCase();

Color _statusColor(String status) => switch (status) {
  'critical' => AppColors.urgent,
  'watch' => AppColors.yellow,
  'good' || 'healthy' || 'strong' => AppColors.goodText,
  'insufficient_data' => AppColors.faintText,
  _ => AppColors.accent,
};

ActionSeverity _severityOf(String priority) => switch (priority) {
  'high' || 'critical' || 'urgent' => ActionSeverity.high,
  'medium' || 'med' => ActionSeverity.med,
  _ => ActionSeverity.low,
};

class _MetricDetailLoader extends StatefulWidget {
  const _MetricDetailLoader({
    required this.title,
    required this.value,
    required this.args,
  });

  final String title;
  final String value;
  final KpiExplainArgs args;

  @override
  State<_MetricDetailLoader> createState() => _MetricDetailLoaderState();
}

class _MetricDetailLoaderState extends State<_MetricDetailLoader> {
  late Future<kpi_detail.dashboardNumberDetail> _future;

  @override
  void initState() {
    super.initState();
    _future = _fetchKpiExplain();
  }

  Future<kpi_detail.dashboardNumberDetail> _fetchKpiExplain() async {
    final token = await PrefUtils.getAccessToken();
    if (token == null || token.isEmpty) {
      throw ApiException('Not signed in.');
    }
    return ApiService().getKpiExplain(
      accessToken: token,
      kpiName: widget.args.kpiName,
      currentValue: widget.args.currentValue,
      priorValue: widget.args.priorValue,
      formatType: widget.args.formatType,
    );
  }

  void _retry() {
    setState(() {
      _future = _fetchKpiExplain();
    });
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<kpi_detail.dashboardNumberDetail>(
      future: _future,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return _MetricSheetShell(
            title: widget.title,
            value: widget.value,
            child: const Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ShimmerBox(height: 72, borderRadius: 14),
                SizedBox(height: 14),
                ShimmerBox(height: 36, borderRadius: 20),
                SizedBox(height: 14),
                ShimmerBox(height: 52, borderRadius: 14),
                SizedBox(height: 18),
                ShimmerBox(height: 96, borderRadius: 14),
              ],
            ),
          );
        }

        if (snapshot.hasError || !snapshot.hasData) {
          final error = snapshot.error;
          final errMsg = error is ApiException
              ? error.message
              : (error != null
                  ? error.toString().replaceAll('Exception: ', '')
                  : 'Couldn\'t load this metric right now.');

          return _MetricSheetShell(
            title: widget.title,
            value: widget.value,
            child: Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 24),
              decoration: BoxDecoration(
                color: AppColors.glassDark,
                borderRadius: BorderRadius.circular(18),
                border: Border.all(
                  color: AppColors.yellow.withValues(alpha: 0.3),
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: AppColors.yellow.withValues(alpha: 0.12),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.warning_amber_rounded,
                      color: AppColors.yellow,
                      size: 32,
                    ),
                  ),
                  const SizedBox(height: 14),
                  Text(
                    'Analysis Unavailable',
                    textAlign: TextAlign.center,
                    style: AppTextStyles.headlineAccent.copyWith(
                      color: AppColors.white,
                      fontWeight: FontWeight.w700,
                      fontSize: 16.0,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    errMsg,
                    textAlign: TextAlign.center,
                    style: AppTextStyles.body.copyWith(
                      color: AppColors.mutedText,
                      fontSize: 13.0,
                      height: 1.45,
                    ),
                  ),
                  const SizedBox(height: 18),
                  InkWell(
                    onTap: _retry,
                    borderRadius: BorderRadius.circular(10),
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 22,
                        vertical: 10,
                      ),
                      decoration: BoxDecoration(
                        color: AppColors.accent.withValues(alpha: 0.15),
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(
                          color: AppColors.accent.withValues(alpha: 0.4),
                        ),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Icon(
                            Icons.refresh_rounded,
                            size: 18,
                            color: AppColors.accent,
                          ),
                          const SizedBox(width: 8),
                          Text(
                            'Try Again',
                            style: AppTextStyles.small.copyWith(
                              color: AppColors.accent,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        }

        return MetricDetailSheet(
          detail: _toMetricDetail(
            title: widget.title,
            value: widget.value,
            data: snapshot.data!.data,
          ),
        );
      },
    );
  }
}

class _MetricSheetShell extends StatelessWidget {
  const _MetricSheetShell({
    required this.title,
    required this.value,
    required this.child,
  });

  final String title;
  final String value;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return FractionallySizedBox(
      heightFactor: 0.86,
      child: ClipRRect(
        borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
        child: GradientBackground(
          child: SafeArea(
            top: false,
            child: Column(
              children: [
                const SizedBox(height: 10),
                Container(
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(
                    color: AppColors.glassBorder,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
                Expanded(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.fromLTRB(20, 16, 20, 24),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          title,
                          style: AppTextStyles.headlineAccent.copyWith(
                            color: Colors.white,
                            fontWeight: FontWeight.w600,
                            fontSize: 15.0,
                          ),
                        ),
                        const SizedBox(height: 6),
                        Text(
                          value,
                          style: AppTextStyles.headline.copyWith(fontSize: 38.0),
                        ),
                        const SizedBox(height: 16),
                        child,
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class MetricDetailSheet extends StatefulWidget {
  const MetricDetailSheet({super.key, required this.detail});

  final MetricDetail detail;

  @override
  State<MetricDetailSheet> createState() => _MetricDetailSheetState();
}

class _MetricDetailSheetState extends State<MetricDetailSheet> {
  int _selectedComparison = 0;

  @override
  Widget build(BuildContext context) {
    final detail = widget.detail;
    final comparison = detail.comparisons[_selectedComparison];
    return FractionallySizedBox(
      heightFactor: 0.86,
      child: ClipRRect(
        borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
        child: GradientBackground(
          child: SafeArea(
            top: false,
            child: Column(
              children: [
                const SizedBox(height: 10),
                Container(
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(
                    color: AppColors.glassBorder,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
                Expanded(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.fromLTRB(20, 16, 20, 24),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Expanded(
                              child: Text(
                                detail.title,
                                style: AppTextStyles.headlineAccent.copyWith(
                                  color: Colors.white,
                                  fontWeight: FontWeight.w600,
                                  fontSize: 15.0,
                                ),
                              ),
                            ),
                            _Badge(
                              label: detail.badgeLabel,
                              color: detail.badgeColor,
                            ),
                          ],
                        ),
                        const SizedBox(height: 6),
                        Text(
                          detail.value,
                          style: AppTextStyles.headline.copyWith(
                            fontSize: 38.0,
                          ),
                        ),
                        const SizedBox(height: 10),
                        Text(
                          comparison.body,
                          style: AppTextStyles.body.copyWith(
                            color: AppColors.white,
                          ),
                        ),
                        const SizedBox(height: 14),
                        Row(
                          children: [
                            for (var i = 0; i < detail.comparisons.length; i++)
                              Padding(
                                padding: EdgeInsets.only(
                                  right: i == detail.comparisons.length - 1
                                      ? 0
                                      : 8,
                                ),
                                child: _CompareChip(
                                  label: detail.comparisons[i].label,
                                  selected: i == _selectedComparison,
                                  onTap: () =>
                                      setState(() => _selectedComparison = i),
                                ),
                              ),
                          ],
                        ),
                        const SizedBox(height: 14),
                        Container(
                          width: double.infinity,
                          padding: const EdgeInsets.symmetric(
                            horizontal: 14,
                            vertical: 12,
                          ),
                          decoration: BoxDecoration(
                            color: AppColors.glassDark,
                            borderRadius: BorderRadius.circular(14),
                            // border: Border.all(color: AppColors.glassBorder),
                          ),
                          child: Row(
                            children: [
                              Icon(
                                switch (comparison.changeIsPositive) {
                                  true => Icons.arrow_upward,
                                  false => Icons.arrow_downward,
                                  null => Icons.remove,
                                },
                                size: 16,
                                color: switch (comparison.changeIsPositive) {
                                  true => AppColors.goodText,
                                  false => AppColors.yellow,
                                  null => AppColors.faintText,
                                },
                              ),
                              const SizedBox(width: 8),
                              Expanded(
                                child: Text(
                                  comparison.changeText,
                                  style: AppTextStyles.body.copyWith(
                                    color: AppColors.white,
                                    fontSize: 13.5,
                                  ),
                                ),
                              ),
                              const SizedBox(width: 8),
                              _Badge(
                                label: detail.badgeLabel,
                                color: detail.badgeColor,
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 16),
                        Divider(thickness: .1, color: Colors.white),
                        _CollapsibleSection(
                          title: 'Top drivers',
                          count: detail.drivers.length,
                          children: [
                            for (var i = 0; i < detail.drivers.length; i++)
                              _DriverRow(
                                index: i + 1,
                                driver: detail.drivers[i],
                              ),
                          ],
                        ),
                        Divider(thickness: .1, color: Colors.white),
                        const SizedBox(height: 12),
                        Divider(thickness: .1, color: Colors.white),
                        _CollapsibleSection(
                          title: 'Suggested actions',
                          count: detail.actions.length,
                          children: [
                            for (final action in detail.actions)
                              _ActionRow(action: action),
                          ],
                        ),
                        const SizedBox(height: 18),
                        Text(
                          'Confidence: ${detail.confidence}',
                          style: AppTextStyles.small.copyWith(
                            color: AppColors.faintText,
                            fontSize: 11.5,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _Badge extends StatelessWidget {
  const _Badge({required this.label, required this.color});

  final String label;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.18),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        label,
        style: AppTextStyles.body.copyWith(color: color, fontSize: 12.5),
      ),
    );
  }
}

class _CompareChip extends StatelessWidget {
  const _CompareChip({
    required this.label,
    required this.selected,
    required this.onTap,
  });

  final String label;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      borderRadius: BorderRadius.circular(20),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(20),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
          decoration: BoxDecoration(
            color: selected ? AppColors.glassLight : Colors.transparent,
            borderRadius: BorderRadius.circular(20),
            border: Border.all(
              color: selected ? AppColors.accent : AppColors.glassBorderSoft,
              width: selected ? 1.4 : 1,
            ),
          ),
          child: Text(
            label,
            style: AppTextStyles.body.copyWith(
              color: selected ? AppColors.white : AppColors.faintText,
            ),
          ),
        ),
      ),
    );
  }
}

class _CollapsibleSection extends StatefulWidget {
  const _CollapsibleSection({
    required this.title,
    required this.count,
    required this.children,
  });

  final String title;
  final int count;
  final List<Widget> children;

  @override
  State<_CollapsibleSection> createState() => _CollapsibleSectionState();
}

class _CollapsibleSectionState extends State<_CollapsibleSection> {
  bool _expanded = true;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        InkWell(
          onTap: () => setState(() => _expanded = !_expanded),
          borderRadius: BorderRadius.circular(8),
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 4),
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    widget.title,
                    style: AppTextStyles.logo.copyWith(fontSize: 14.5),
                  ),
                ),
                Container(
                  width: 20,
                  height: 20,
                  alignment: Alignment.center,
                  decoration: const BoxDecoration(
                    color: AppColors.glassLight,
                    shape: BoxShape.circle,
                  ),
                  child: Text(
                    '${widget.count}',
                    style: const TextStyle(
                      color: AppColors.white,
                      fontSize: 11,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
                const SizedBox(width: 6),
                AnimatedRotation(
                  turns: _expanded ? 0.5 : 0,
                  duration: const Duration(milliseconds: 200),
                  child: const Icon(
                    Icons.keyboard_arrow_down,
                    size: 18,
                    color: AppColors.faintText,
                  ),
                ),
              ],
            ),
          ),
        ),
        AnimatedSize(
          duration: const Duration(milliseconds: 200),
          curve: Curves.easeInOut,
          alignment: Alignment.topCenter,
          child: !_expanded
              ? const SizedBox(width: double.infinity)
              : Padding(
                  padding: const EdgeInsets.only(top: 10),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      for (var i = 0; i < widget.children.length; i++) ...[
                        if (i > 0) const SizedBox(height: 10),
                        widget.children[i],
                      ],
                    ],
                  ),
                ),
        ),
      ],
    );
  }
}

class _DriverRow extends StatelessWidget {
  const _DriverRow({required this.index, required this.driver});

  final int index;
  final MetricDriver driver;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 18,
            height: 18,
            alignment: Alignment.center,
            margin: const EdgeInsets.only(top: 1),
            decoration: BoxDecoration(
              color: AppColors.glassLight,
              shape: BoxShape.circle,
            ),
            child: Text(
              '$index',
              style: const TextStyle(
                color: AppColors.white,
                fontSize: 10.5,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  driver.title,
                  style: AppTextStyles.body.copyWith(color: AppColors.white),
                ),
                if (driver.subtitle.isNotEmpty) ...[
                  const SizedBox(height: 2),
                  Text(
                    driver.subtitle,
                    style: AppTextStyles.small.copyWith(
                      color: AppColors.faintText,
                      fontSize: 11.0,
                    ),
                  ),
                ],
              ],
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              driver.delta,
              style: AppTextStyles.body.copyWith(
                color: switch (driver.isPositive) {
                  true => const Color(0xFFA6F5DC),
                  false => const Color(0xFFFFD466),
                  null => AppColors.mutedText,
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _ActionRow extends StatelessWidget {
  const _ActionRow({required this.action});

  final SuggestedAction action;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      child: Column(
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _Badge(
                label: action.severity.label,
                color: action.severity.color,
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      action.text,
                      style: AppTextStyles.body.copyWith(
                        color: AppColors.white,
                      ),
                    ),
                    if (action.effort != null && action.effort!.isNotEmpty) ...[
                      const SizedBox(height: 2),
                      Text(
                        'Effort: ${action.effort}',
                        style: AppTextStyles.small.copyWith(
                          color: AppColors.faintText,
                          fontSize: 11.0,
                        ),
                      ),
                    ],
                  ],
                ),
              ),
            ],
          ),
          Divider(thickness: .1, color: Colors.white),
        ],
      ),
    );
  }
}
