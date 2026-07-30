import 'package:flutter/material.dart';

import '../data/full_read_data.dart';
import '../theme/business_health_colors.dart';

/// One expandable row inside a "The Full Read" category card: tapping the
/// title reveals the explanation (plus optional causes / "why now" line),
/// and tapping the action pill reveals the recommended fix underneath it.
class ReadItemTile extends StatefulWidget {
  const ReadItemTile({super.key, required this.item});

  final ReadItemData item;

  @override
  State<ReadItemTile> createState() => _ReadItemTileState();
}

class _ReadItemTileState extends State<ReadItemTile> {
  bool _expanded = false;
  bool _actionExpanded = false;

  @override
  Widget build(BuildContext context) {
    final item = widget.item;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        InkWell(
          onTap: () => setState(() => _expanded = !_expanded),
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 10),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Text(
                    item.title,
                    style: const TextStyle(
                      color: BusinessHealthColors.white,
                      fontSize: 13.5,
                      fontWeight: FontWeight.w700,
                      height: 1.35,
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                Icon(
                  _expanded ? Icons.keyboard_arrow_down : Icons.chevron_right,
                  size: 20,
                  color: BusinessHealthColors.faintText,
                ),
              ],
            ),
          ),
        ),
        if (_expanded) ...[
          if (item.body.isNotEmpty)
            Text(
              item.body,
              style: const TextStyle(
                color: BusinessHealthColors.mutedText,
                fontSize: 13,
                height: 1.5,
              ),
            ),
          if (item.whyNowText != null) ...[
            const SizedBox(height: 8),
            RichText(
              text: TextSpan(
                style: const TextStyle(
                  color: BusinessHealthColors.mutedText,
                  fontSize: 13,
                  height: 1.5,
                ),
                children: [
                  const TextSpan(
                    text: 'Why now: ',
                    style: TextStyle(
                      color: BusinessHealthColors.warnColor,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  TextSpan(text: item.whyNowText),
                ],
              ),
            ),
          ],
          if (item.possibleCauses != null) ...[
            const SizedBox(height: 10),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: BusinessHealthColors.trackFill,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'POSSIBLE CAUSES',
                    style: TextStyle(
                      color: BusinessHealthColors.faintText,
                      fontSize: 10.5,
                      fontWeight: FontWeight.w700,
                      letterSpacing: 0.6,
                    ),
                  ),
                  const SizedBox(height: 8),
                  for (final cause in item.possibleCauses!)
                    Padding(
                      padding: const EdgeInsets.only(bottom: 6),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Padding(
                            padding: EdgeInsets.only(top: 5),
                            child: Icon(
                              Icons.circle,
                              size: 4,
                              color: BusinessHealthColors.faintText,
                            ),
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Text(
                              cause,
                              style: const TextStyle(
                                color: BusinessHealthColors.mutedText,
                                fontSize: 12,
                                height: 1.45,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                ],
              ),
            ),
          ],
          const SizedBox(height: 10),
          InkWell(
            onTap: () => setState(() => _actionExpanded = !_actionExpanded),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
              decoration: BoxDecoration(
                border: Border.all(
                  color: _actionExpanded
                      ? BusinessHealthColors.white
                      : BusinessHealthColors.cardBorder,
                ),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    item.actionLabel,
                    style: const TextStyle(
                      color: BusinessHealthColors.white,
                      fontSize: 11,
                      fontWeight: FontWeight.w800,
                      letterSpacing: 0.4,
                    ),
                  ),
                  const SizedBox(width: 4),
                  Icon(
                    _actionExpanded
                        ? Icons.keyboard_arrow_down
                        : Icons.chevron_right,
                    size: 16,
                    color: BusinessHealthColors.white,
                  ),
                ],
              ),
            ),
          ),
          if (_actionExpanded) ...[
            const SizedBox(height: 10),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: BusinessHealthColors.trackFill,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: BusinessHealthColors.cardBorder),
              ),
              child: Text(
                item.actionBody,
                style: const TextStyle(
                  color: BusinessHealthColors.mutedText,
                  fontSize: 12.5,
                  height: 1.5,
                ),
              ),
            ),
          ],
          const SizedBox(height: 4),
        ],
        Container(height: 1, color: BusinessHealthColors.cardBorder),
      ],
    );
  }
}
