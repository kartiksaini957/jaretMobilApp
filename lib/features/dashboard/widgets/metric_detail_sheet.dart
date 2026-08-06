import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../theme/app_theme.dart';
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

  /// Null when the source has no direction for this driver (the KPI-explain
  /// API describes impact in prose), which renders the text neutral.
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

/// One "Vs Last Month" / "Vs Peers" view: its own body copy and change
/// indicator, swapped in when its chip is tapped.
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

  /// Null means flat — shown with a dash instead of an up/down arrow.
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

/// Opens the metric sheet for [args] and fetches its explanation from
/// `/dashboard/kpi-explain` — the request only fires here, on tap.
/// [title] and [value] are the tile's own label and formatted number, shown
/// immediately so the header isn't blank while the call is in flight.
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

/// Maps one KPI-explain response onto the sheet's render model.
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

  // Peer and target blocks come back all-null when the backend has no
  // benchmark for this KPI — skip the chip entirely in that case. The
  // verdict stays put across chips; only the change row below swaps.
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

/// Holds the sheet chrome steady while the explanation loads, so the header
/// and close button are usable from the first frame.
class _MetricDetailLoader extends ConsumerWidget {
  const _MetricDetailLoader({
    required this.title,
    required this.value,
    required this.args,
  });

  final String title;
  final String value;
  final KpiExplainArgs args;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final explanation = ref.watch(kpiExplainProvider(args));
    return explanation.when(
      loading: () => _MetricSheetShell(
        title: title,
        value: value,
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
      ),
      error: (error, stackTrace) => _MetricSheetShell(
        title: title,
        value: value,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Couldn\'t load this metric right now.',
              style: AppTextStyles.body.copyWith(color: AppColors.faintText),
            ),
            const SizedBox(height: 10),
            OutlinedButton(
              onPressed: () => ref.invalidate(kpiExplainProvider(args)),
              style: OutlinedButton.styleFrom(
                side: const BorderSide(color: AppColors.glassBorder),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
              ),
              child: Text(
                'Retry',
                style: AppTextStyles.body.copyWith(color: AppColors.white),
              ),
            ),
          ],
        ),
      ),
      data: (response) => MetricDetailSheet(
        detail: _toMetricDetail(
          title: title,
          value: value,
          data: response.data,
        ),
      ),
    );
  }
}

/// The sheet's outer frame (rounded gradient panel, grab handle, title and
/// value header) reused by the loading and error states.
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
                          // const TextStyle(
                          //   color: AppColors.white,
                          //   fontSize: 30,
                          //   fontWeight: FontWeight.w800,
                          // ),
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
                                  // const TextStyle(
                                  //   color: AppColors.white,
                                  //   fontSize: 13,
                                  //   fontWeight: FontWeight.w600,
                                  // ),
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
        // TextStyle(
        //   color: color,
        //   fontSize: 11,
        //   fontWeight: FontWeight.w700,
        // ),
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
            // TextStyle(
            //   color: selected ? AppColors.white : AppColors.faintText,
            //   fontSize: 12.5,
            //   fontWeight: selected ? FontWeight.w700 : FontWeight.w600,
            // ),
          ),
        ),
      ),
    );
  }
}

/// Tappable header that expands/collapses [children] below it, with the
/// chevron rotating to reflect the current state.
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
                    //  const TextStyle(
                    //   color: AppColors.white,
                    //   fontSize: 14.5,
                    //   fontWeight: FontWeight.w700,
                    // ),
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
      // decoration: BoxDecoration(
      // color: AppColors.glassDark,
      // borderRadius: BorderRadius.circular(14),
      // border: Border.all(color: AppColors.glassBorder),
      // ),
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
                  // const TextStyle(
                  //   color: AppColors.white,
                  //   fontSize: 13.5,
                  //   fontWeight: FontWeight.w700,
                  // ),
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
          // The API describes impact in prose, so this side needs to wrap
          // rather than sit as a short right-aligned delta.
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
              //  TextStyle(
              //   color: driver.isPositive ? AppColors.goodText : AppColors.yellow,
              //   fontSize: 13.5,
              //   fontWeight: FontWeight.w700,
              // ),
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
      // padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      // decoration: BoxDecoration(
      //   color: AppColors.glassDark,
      //   borderRadius: BorderRadius.circular(14),
      //   border: Border.all(color: AppColors.glassBorder),
      // ),
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
          // SizedBox(height: 10),
          Divider(thickness: .1, color: Colors.white),
        ],
      ),
    );
  }
}
