import 'package:flutter/material.dart';

import '../theme/business_health_colors.dart';

class SnapshotEntry {
  const SnapshotEntry({
    required this.label,
    required this.score,
    this.isCurrent = false,
  });

  final String label;
  final int score;
  final bool isCurrent;
}

/// Bottom sheet opened from the "Snapshot · Feb 11" pill: snapshot
/// history list plus a "Compare with …" action for the picked one.
class SnapshotHistorySheet extends StatefulWidget {
  const SnapshotHistorySheet({super.key, required this.entries});

  final List<SnapshotEntry> entries;

  static Future<void> show(BuildContext context, List<SnapshotEntry> entries) {
    return showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (_) => SnapshotHistorySheet(entries: entries),
    );
  }

  @override
  State<SnapshotHistorySheet> createState() => _SnapshotHistorySheetState();
}

class _SnapshotHistorySheetState extends State<SnapshotHistorySheet> {
  late int _compareIndex = widget.entries.indexWhere((e) => !e.isCurrent);

  @override
  Widget build(BuildContext context) {
    final compareLabel = _compareIndex >= 0
        ? widget.entries[_compareIndex].label
        : '';

    return SafeArea(
      top: false,
      child: Container(
        margin: const EdgeInsets.fromLTRB(0, 0, 0, 0),
        padding: const EdgeInsets.fromLTRB(20, 12, 20, 20),
        decoration: const BoxDecoration(
          color: BusinessHealthColors.sheetBg,
          borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Container(
                width: 36,
                height: 4,
                decoration: BoxDecoration(
                  color: BusinessHealthColors.cardBorder,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),
            const SizedBox(height: 18),
            const Text(
              'Snapshots',
              style: TextStyle(
                color: BusinessHealthColors.white,
                fontSize: 19,
                fontWeight: FontWeight.w800,
              ),
            ),
            const SizedBox(height: 16),
            const Text(
              'SNAPSHOT HISTORY',
              style: TextStyle(
                color: BusinessHealthColors.faintText,
                fontSize: 11,
                fontWeight: FontWeight.w700,
                letterSpacing: 0.8,
              ),
            ),
            const SizedBox(height: 10),
            for (var i = 0; i < widget.entries.length; i++)
              _SnapshotRow(
                entry: widget.entries[i],
                selected: i == _compareIndex && !widget.entries[i].isCurrent,
                onTap: widget.entries[i].isCurrent
                    ? null
                    : () => setState(() => _compareIndex = i),
              ),
            const SizedBox(height: 18),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: compareLabel.isEmpty
                    ? null
                    : () => Navigator.of(context).pop(),
                style: ElevatedButton.styleFrom(
                  backgroundColor: BusinessHealthColors.pillGoodBg,
                  foregroundColor: BusinessHealthColors.white,
                  elevation: 0,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(24),
                  ),
                ),
                child: Text(
                  'Compare with $compareLabel →',
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _SnapshotRow extends StatelessWidget {
  const _SnapshotRow({
    required this.entry,
    required this.selected,
    required this.onTap,
  });

  final SnapshotEntry entry;
  final bool selected;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      borderRadius: BorderRadius.circular(12),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Container(
          width: double.infinity,
          margin: const EdgeInsets.only(bottom: 8),
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
          decoration: BoxDecoration(
            color: (entry.isCurrent || selected)
                ? BusinessHealthColors.cardFill
                : Colors.transparent,
            borderRadius: BorderRadius.circular(12),
            border: entry.isCurrent
                ? Border.all(color: BusinessHealthColors.cardBorder)
                : null,
          ),
          child: Row(
            children: [
              Text(
                entry.label,
                style: TextStyle(
                  color: BusinessHealthColors.white,
                  fontSize: 14,
                  fontWeight: entry.isCurrent ? FontWeight.w800 : FontWeight.w600,
                ),
              ),
              const Spacer(),
              Text(
                '${entry.score}',
                style: const TextStyle(
                  color: BusinessHealthColors.mutedText,
                  fontSize: 14,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
