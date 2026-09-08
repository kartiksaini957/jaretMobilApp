import 'package:flutter/material.dart';

import '../theme/financial_colors.dart';
import 'status_pill.dart';

class MetricData {
  const MetricData({
    required this.label,
    required this.value,
    required this.statusLabel,
    required this.statusColor,
  });

  final String label;
  final String value;
  final String statusLabel;
  final Color statusColor;
}

class KeyMetricsGrid extends StatefulWidget {
  const KeyMetricsGrid({super.key, required this.metrics});

  final List<MetricData> metrics;

  @override
  State<KeyMetricsGrid> createState() => _KeyMetricsGridState();
}

class _KeyMetricsGridState extends State<KeyMetricsGrid> {
  late final List<MetricData> _visible = List.of(widget.metrics);
  final Set<String> _starred = {};

  @override
  Widget build(BuildContext context) {
    if (_visible.isEmpty) {
      return const Text(
        'All metrics dismissed.',
        style: TextStyle(color: FinancialColors.faintText, fontSize: 12.5),
      );
    }
    return Wrap(
      spacing: 12,
      runSpacing: 12,
      children: [
        for (final metric in _visible)
          SizedBox(
            width: (MediaQuery.of(context).size.width - 20 * 2 - 12) / 2,
            child: _MetricTile(
              metric: metric,
              starred: _starred.contains(metric.label),
              onStar: () => setState(() {
                if (_starred.contains(metric.label)) {
                  _starred.remove(metric.label);
                } else {
                  _starred.add(metric.label);
                }
              }),
              onDismiss: () => setState(() => _visible.remove(metric)),
            ),
          ),
      ],
    );
  }
}

class _MetricTile extends StatelessWidget {
  const _MetricTile({
    required this.metric,
    required this.starred,
    required this.onStar,
    required this.onDismiss,
  });

  final MetricData metric;
  final bool starred;
  final VoidCallback onStar;
  final VoidCallback onDismiss;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: FinancialColors.cardDarkFill,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: FinancialColors.cardBorder),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  metric.label,
                  style: const TextStyle(
                    color: FinancialColors.faintText,
                    fontSize: 10.5,
                    fontWeight: FontWeight.w700,
                    letterSpacing: 0.4,
                  ),
                ),
              ),
              InkWell(
                onTap: onStar,
                child: Icon(
                  starred ? Icons.star : Icons.star_border,
                  size: 15,
                  color: starred
                      ? FinancialColors.statusNeutral
                      : FinancialColors.faintText,
                ),
              ),
              const SizedBox(width: 6),
              InkWell(
                onTap: onDismiss,
                child: const Icon(
                  Icons.close,
                  size: 15,
                  color: FinancialColors.faintText,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          StatusPill(label: metric.statusLabel, color: metric.statusColor),
          const SizedBox(height: 8),
          Text(
            metric.value,
            style: const TextStyle(
              color: FinancialColors.white,
              fontSize: 22,
              fontWeight: FontWeight.w800,
            ),
          ),
          const SizedBox(height: 2),
          const Icon(
            Icons.keyboard_arrow_down,
            size: 16,
            color: FinancialColors.faintText,
          ),
        ],
      ),
    );
  }
}
