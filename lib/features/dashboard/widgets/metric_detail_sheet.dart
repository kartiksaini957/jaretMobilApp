import 'package:flutter/material.dart';

import '../../../theme/app_theme.dart';
import '../../../widgets/gradient_background.dart';

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
    required this.isPositive,
  });

  final String title;
  final String subtitle;
  final String delta;
  final bool isPositive;
}

class SuggestedAction {
  const SuggestedAction({required this.severity, required this.text});

  final ActionSeverity severity;
  final String text;
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
  final bool changeIsPositive;
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

Future<void> showMetricDetailSheet(BuildContext context, MetricDetail detail) {
  return showModalBottomSheet(
    context: context,
    backgroundColor: Colors.transparent,
    isScrollControlled: true,
    builder: (context) => MetricDetailSheet(detail: detail),
  );
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
                                comparison.changeIsPositive
                                    ? Icons.arrow_upward
                                    : Icons.arrow_downward,
                                size: 16,
                                color: comparison.changeIsPositive
                                    ? AppColors.goodText
                                    : AppColors.yellow,
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
                const SizedBox(height: 2),
                Text(
                  driver.subtitle,
                  style: AppTextStyles.small.copyWith(
                    color: AppColors.faintText,
                    fontSize: 11.0,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 8),
          Text(
            driver.delta,
            style: AppTextStyles.body.copyWith(
              color: driver.isPositive ? Color(0xFFA6F5DC) : Color(0xFFFFD466),
            ),
            //  TextStyle(
            //   color: driver.isPositive ? AppColors.goodText : AppColors.yellow,
            //   fontSize: 13.5,
            //   fontWeight: FontWeight.w700,
            // ),
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
                child: Text(
                  action.text,
                  style: AppTextStyles.body.copyWith(color: AppColors.white),
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
