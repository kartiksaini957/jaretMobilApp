import 'package:flutter/material.dart';
import '../../../theme/app_theme.dart';
import '../data/financial_overview_data.dart';
import 'financial_ask_ai_sheet.dart';
import 'financial_bar_chart.dart';
import 'financial_suggested_actions_sheet.dart';

class FinancialMetricDetailCard extends StatefulWidget {
  const FinancialMetricDetailCard({super.key, required this.metric});

  final MetricDetail metric;

  @override
  State<FinancialMetricDetailCard> createState() =>
      _FinancialMetricDetailCardState();
}

class _FinancialMetricDetailCardState extends State<FinancialMetricDetailCard> {
  bool _vsPeers = false;

  @override
  void didUpdateWidget(covariant FinancialMetricDetailCard oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.metric != widget.metric) _vsPeers = false;
  }

  Color get _toneColor => switch (widget.metric.tone) {
    MetricTone.good => AppColors.goodDot,
    MetricTone.neutral => AppColors.warnDot,
    MetricTone.bad => AppColors.critDot,
  };


  @override
  Widget build(BuildContext context) {
    final metric = widget.metric;
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.glassDark,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  metric.label,
                  style: AppTextStyles.headlineAccent.copyWith(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
                  ),
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 4),
                decoration: BoxDecoration(
                  color: _toneColor.withValues(alpha: 0.18),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  metric.statusLabel,
                  style: AppTextStyles.small.copyWith(color: _toneColor),
                ),
              ),
            ],
          ),
          const SizedBox(height: 6),
          Text(
            metric.value,
            style: AppTextStyles.headlineAccent.copyWith(
              fontSize: 38,
              fontWeight: FontWeight.w700,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 4),
          Text(metric.trendLabel, style: AppTextStyles.small),
          const SizedBox(height: 14),
          const MiniBarChart(),
          const SizedBox(height: 6),
          Text(
            metric.chartCaption,
            style: AppTextStyles.small.copyWith(fontSize: 11),
          ),
          const SizedBox(height: 14),
          Row(
            children: [
              _ToggleButton(
                label: 'Vs last month',
                selected: !_vsPeers,
                onTap: () => setState(() => _vsPeers = false),
              ),
              if (metric.hasPeerComparison) ...[
                const SizedBox(width: 8),
                _ToggleButton(
                  label: 'Vs peers',
                  selected: _vsPeers,
                  onTap: () => setState(() => _vsPeers = true),
                ),
              ],
            ],
          ),
          const SizedBox(height: 12),
          Text(
            _vsPeers ? metric.vsPeersBody : metric.vsLastMonthBody,
            style: AppTextStyles.small.copyWith(height: 1.5, fontSize: 13.5),
          ),
          const SizedBox(height: 12),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: AppColors.glassLight,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              children: [
                Icon(
                  _vsPeers
                      ? Icons.compare_arrows
                      : (metric.tone == MetricTone.bad
                            ? Icons.arrow_upward
                            : Icons.arrow_downward),
                  size: 16,
                  color: AppColors.white,
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    _vsPeers
                        ? metric.vsPeersDeltaLabel
                        : metric.vsLastMonthDeltaLabel,
                    style: AppTextStyles.small.copyWith(
                      color: AppColors.white,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 3,
                  ),
                  decoration: BoxDecoration(
                    color: _toneColor.withValues(alpha: 0.18),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    metric.statusLabel,
                    style: AppTextStyles.small.copyWith(color: _toneColor),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 18),
          Text("WHAT'S DRIVING IT", style: AppTextStyles.eyebrow),
          const SizedBox(height: 10),
          for (var i = 0; i < metric.drivingFactors.length; i++)
            Padding(
              padding: const EdgeInsets.only(bottom: 10),
              child: _DrivingRow(
                index: i + 1,
                factor: metric.drivingFactors[i],
              ),
            ),
          const SizedBox(height: 8),
          Row(
            children: [
              Expanded(
                child: OutlinedButton(
                  onPressed: () => FinancialSuggestedActionsSheet.show(
                    context,
                    metricLabel: metric.label,
                    actions: metric.suggestedActions,
                  ),
                  style: OutlinedButton.styleFrom(
                    side: const BorderSide(color: AppColors.glassBorder),
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: Text(
                    'Suggested actions  ${metric.suggestedActions.length}',
                    style: AppTextStyles.buttonLabel.copyWith(fontSize: 12.5),
                  ),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: OutlinedButton(
                  onPressed: () => FinancialAskAiSheet.show(
                    context,
                    metricLabel: metric.label,
                    seedTranscript: metric.askAiTranscript,
                  ),
                  style: OutlinedButton.styleFrom(
                    side: const BorderSide(color: AppColors.glassBorder),
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: Text(
                    'Ask AI',
                    style: AppTextStyles.buttonLabel.copyWith(fontSize: 12.5),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Text(
            'Confidence: High (98% data coverage) · Square POS synced '
            '2h ago',
            style: AppTextStyles.small.copyWith(fontSize: 11.5),
          ),
        ],
      ),
    );
  }
}

class _ToggleButton extends StatelessWidget {
  const _ToggleButton({
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
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 9),
          decoration: BoxDecoration(
            color: Colors.transparent,
            borderRadius: BorderRadius.circular(20),
            border: Border.all(
              color: selected ? const Color(0x805FE0FF) : AppColors.glassBorder,
            ),
          ),
          child: Text(
            label,
            style: AppTextStyles.small,
          ),
        ),
      ),
    );
  }
}

class _DrivingRow extends StatelessWidget {
  const _DrivingRow({required this.index, required this.factor});
  final int index;
  final DrivingFactor factor;
  Color get _impactColor => switch (factor.tone) {
    ImpactTone.positive => AppColors.goodText,
    ImpactTone.negative => AppColors.crit,
    ImpactTone.neutral => AppColors.faintText,
    ImpactTone.watch => AppColors.warnDot,
  };

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(width: 18, child: Text('$index', style: AppTextStyles.small)),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                factor.title,
                style: AppTextStyles.buttonLabel.copyWith(fontSize: 13),
              ),
              const SizedBox(height: 2),
              Text(
                factor.subtitle,
                style: AppTextStyles.small.copyWith(fontSize: 11),
              ),
            ],
          ),
        ),
        const SizedBox(width: 8),
        Text(
          factor.impact,
          style: TextStyle(
            color: _impactColor,
            fontSize: 13,
            fontWeight: FontWeight.w700,
          ),
        ),
      ],
    );
  }
}
