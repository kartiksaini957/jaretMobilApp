import 'package:flutter/material.dart';

import '../../../theme/app_theme.dart';
import '../data/demand_forecast_data.dart';

/// Checklist content for the "Do this" full-read panel: each item's checked
/// state comes from the server (item.completed) and toggling calls the API
/// via onToggleAction; each item also has an independent
/// "why this, why now" expand state.
class ForecastDoThisPanel extends StatefulWidget {
  const ForecastDoThisPanel({
    super.key,
    required this.intro,
    required this.items,
    required this.onToggleAction, // 🔧 NEW
  });

  final String intro;
  final List<DoThisItem> items;
  final Future<void> Function(String actionId, bool newValue)
  onToggleAction; // 🔧 NEW

  @override
  State<ForecastDoThisPanel> createState() => _ForecastDoThisPanelState();
}

class _ForecastDoThisPanelState extends State<ForecastDoThisPanel> {
  // 🔧 REMOVED: _checked set — checked state ab widget.items[i].completed
  // (server se aata hai) se aata hai, local tracking ki zaroorat nahi
  final Set<int> _expanded = {};
  late Set<String> _localCompleted;

  @override
  void initState() {
    super.initState();
    // 🔧 NEW: initial state widget.items se le lo
    _localCompleted = widget.items
        .where((it) => it.completed)
        .map((it) => it.id)
        .toSet();
  }

  @override
  void didUpdateWidget(covariant ForecastDoThisPanel oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.items != widget.items) {
      _expanded.clear();
      // 🔧 NEW: agar kabhi naya `items` list parent se aaya (rare case,
      // jaise sheet reopen), tab hi resync karo. Warna local state hi
      // source of truth rahega jab tak sheet khuli hai.
      _localCompleted = widget.items
          .where((it) => it.completed)
          .map((it) => it.id)
          .toSet();
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
              // 🔧 CHANGED: ab widget.items[i].completed ki jagah
              // local _localCompleted set se checked value liya
              checked: _localCompleted.contains(widget.items[i].id),
              expanded: _expanded.contains(i),
              onCheckToggle: () {
                final id = widget.items[i].id;
                final newValue = !_localCompleted.contains(id);

                // 🔧 NEW: turant local UI update — ye hi fix hai jo
                // "bottom sheet close-open" wali problem hata dega
                setState(() {
                  if (newValue) {
                    _localCompleted.add(id);
                  } else {
                    _localCompleted.remove(id);
                  }
                });

                // API call / parent state update background me chalta rahega
                widget.onToggleAction(id, newValue);
              },
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
                style: AppTextStyles.body.copyWith(
                  decoration: checked ? TextDecoration.lineThrough : null,
                  fontSize: 14.0,
                  fontWeight: FontWeight.w700,
                  color: Colors.white,
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
                    style: AppTextStyles.body.copyWith(
                      color: checked ? AppColors.faintText : AppColors.warnDot,
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
                      style: AppTextStyles.body.copyWith(
                        color: _priorityColor,
                        fontSize: 9.5,
                        fontWeight: FontWeight.w600,
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
                            color: AppColors.critDot,
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
                      color: Colors.white,
                      fontWeight: FontWeight.w600,
                      fontSize: 11.0,
                    ),
                  ),
                ),
              ),
              if (expanded) ...[
                Text(
                  item.whyBody,
                  style: TextStyle(
                    color: checked ? AppColors.faintText : AppColors.mutedText,
                    fontSize: 12.5,
                    height: 1.5,
                    decoration: checked ? TextDecoration.lineThrough : null,
                  ),
                ),
                if (item.whyDollarLine != null) ...[
                  const SizedBox(height: 6),
                  Text(
                    item.whyDollarLine!,
                    style: AppTextStyles.body.copyWith(
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
