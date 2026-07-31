import 'package:flutter/material.dart';

import '../../../theme/app_theme.dart';
import '../data/demand_forecast_data.dart';

/// Checklist content for the "Do this" full-read panel: each item has an
/// independent checked state (strikes it through) and an independent
/// "why this, why now" expand state.
class ForecastDoThisPanel extends StatefulWidget {
  const ForecastDoThisPanel({super.key, required this.intro, required this.items});

  final String intro;
  final List<DoThisItem> items;

  @override
  State<ForecastDoThisPanel> createState() => _ForecastDoThisPanelState();
}

class _ForecastDoThisPanelState extends State<ForecastDoThisPanel> {
  final Set<int> _checked = {};
  final Set<int> _expanded = {};

  @override
  void didUpdateWidget(covariant ForecastDoThisPanel oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.items != widget.items) {
      _checked.clear();
      _expanded.clear();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(widget.intro, style: AppTextStyles.small.copyWith(height: 1.45)),
        const SizedBox(height: 12),
        for (var i = 0; i < widget.items.length; i++)
          Padding(
            padding: const EdgeInsets.only(bottom: 14),
            child: _DoThisRow(
              item: widget.items[i],
              checked: _checked.contains(i),
              expanded: _expanded.contains(i),
              onCheckToggle: () => setState(() {
                _checked.contains(i) ? _checked.remove(i) : _checked.add(i);
              }),
              onExpandToggle: () => setState(() {
                _expanded.contains(i) ? _expanded.remove(i) : _expanded.add(i);
              }),
            ),
          ),
      ],
    );
  }
}

class _DoThisRow extends StatelessWidget {
  const _DoThisRow({
    required this.item,
    required this.checked,
    required this.expanded,
    required this.onCheckToggle,
    required this.onExpandToggle,
  });

  final DoThisItem item;
  final bool checked;
  final bool expanded;
  final VoidCallback onCheckToggle;
  final VoidCallback onExpandToggle;

  Color get _priorityColor =>
      item.priority == 'HIGH' ? AppColors.critDot : AppColors.warnDot;

  @override
  Widget build(BuildContext context) {
    final textColor = checked ? AppColors.faintText : AppColors.white;
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        InkWell(
          onTap: onCheckToggle,
          borderRadius: BorderRadius.circular(6),
          child: Container(
            width: 20,
            height: 20,
            margin: const EdgeInsets.only(top: 2),
            decoration: BoxDecoration(
              color: checked ? AppColors.goodDot : Colors.transparent,
              borderRadius: BorderRadius.circular(6),
              border: Border.all(
                color: checked ? AppColors.goodDot : AppColors.glassBorder,
                width: 1.4,
              ),
            ),
            child: checked
                ? const Icon(Icons.check, size: 14, color: AppColors.ink)
                : null,
          ),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                item.title,
                style: TextStyle(
                  color: textColor,
                  fontSize: 13.5,
                  fontWeight: FontWeight.w700,
                  height: 1.35,
                  decoration: checked ? TextDecoration.lineThrough : null,
                  decorationColor: AppColors.faintText,
                ),
              ),
              const SizedBox(height: 5),
              Wrap(
                crossAxisAlignment: WrapCrossAlignment.center,
                spacing: 8,
                runSpacing: 4,
                children: [
                  Text(
                    item.dateLabel,
                    style: TextStyle(
                      color: checked
                          ? AppColors.faintText
                          : AppColors.warnDot,
                      fontSize: 11.5,
                      fontWeight: FontWeight.w600,
                      decoration: checked ? TextDecoration.lineThrough : null,
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 7,
                      vertical: 2,
                    ),
                    decoration: BoxDecoration(
                      color: _priorityColor.withValues(alpha: 0.18),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      item.priority,
                      style: TextStyle(
                        color: _priorityColor,
                        fontSize: 9.5,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 3,
                    ),
                    decoration: BoxDecoration(
                      color: AppColors.glassLight,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Container(
                          width: 5,
                          height: 5,
                          decoration: const BoxDecoration(
                            color: AppColors.goodDot,
                            shape: BoxShape.circle,
                          ),
                        ),
                        const SizedBox(width: 4),
                        Text(
                          item.tag,
                          style: AppTextStyles.small.copyWith(fontSize: 10.5),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 4),
              InkWell(
                onTap: onExpandToggle,
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 4),
                  child: Text(
                    '${expanded ? '▾' : '▸'} why this, why now',
                    style: AppTextStyles.small.copyWith(
                      color: AppColors.accent,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
              if (expanded) ...[
                Text(
                  item.whyBody,
                  style: TextStyle(
                    color: checked
                        ? AppColors.faintText
                        : AppColors.mutedText,
                    fontSize: 12.5,
                    height: 1.5,
                    decoration: checked ? TextDecoration.lineThrough : null,
                  ),
                ),
                if (item.whyDollarLine != null) ...[
                  const SizedBox(height: 6),
                  Text(
                    item.whyDollarLine!,
                    style: TextStyle(
                      color: checked
                          ? AppColors.faintText
                          : AppColors.mutedText,
                      fontSize: 12.5,
                      height: 1.5,
                      decoration: checked ? TextDecoration.lineThrough : null,
                    ),
                  ),
                ],
              ],
            ],
          ),
        ),
      ],
    );
  }
}
