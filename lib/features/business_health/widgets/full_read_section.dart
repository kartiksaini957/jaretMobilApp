import 'package:flutter/material.dart';

import '../data/full_read_data.dart';
import '../theme/business_health_colors.dart';
import 'read_item_tile.dart';

/// "THE FULL READ" section: a scrollable tab row (Working for you /
/// Dragging you down / Watch areas / Alerts) and the expandable item
/// list for whichever tab is selected.
class FullReadSection extends StatefulWidget {
  const FullReadSection({super.key});

  @override
  State<FullReadSection> createState() => _FullReadSectionState();
}

class _FullReadSectionState extends State<FullReadSection> {
  int _selected = 0;

  @override
  Widget build(BuildContext context) {
    final category = fullReadCategories[_selected];
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'THE FULL READ',
          style: TextStyle(
            color: BusinessHealthColors.faintText,
            fontSize: 11.5,
            fontWeight: FontWeight.w700,
            letterSpacing: 0.8,
          ),
        ),
        const SizedBox(height: 10),
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: [
              for (var i = 0; i < fullReadCategories.length; i++) ...[
                if (i != 0) const SizedBox(width: 8),
                _TabPill(
                  data: fullReadCategories[i],
                  selected: i == _selected,
                  onTap: () => setState(() => _selected = i),
                ),
              ],
            ],
          ),
        ),
        const SizedBox(height: 12),
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: BusinessHealthColors.cardFill,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: BusinessHealthColors.cardBorder),
          ),
          child: Column(
            key: ValueKey(_selected),
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 3,
                    ),
                    decoration: BoxDecoration(
                      color: category.badgeColor.withValues(alpha: 0.18),
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: Text(
                      category.badgeText,
                      style: TextStyle(
                        color: category.badgeColor,
                        fontSize: 10,
                        fontWeight: FontWeight.w800,
                        letterSpacing: 0.4,
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      category.cardTitle,
                      style: const TextStyle(
                        color: BusinessHealthColors.white,
                        fontSize: 14.5,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                  ),
                  Text(
                    '${category.count} ${category.countLabel}',
                    style: const TextStyle(
                      color: BusinessHealthColors.faintText,
                      fontSize: 11.5,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 6),
              for (final item in category.items) ReadItemTile(item: item),
            ],
          ),
        ),
      ],
    );
  }
}

class _TabPill extends StatelessWidget {
  const _TabPill({
    required this.data,
    required this.selected,
    required this.onTap,
  });

  final ReadCategoryData data;
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
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          decoration: BoxDecoration(
            color: selected
                ? data.badgeColor.withValues(alpha: 0.16)
                : BusinessHealthColors.cardFill,
            borderRadius: BorderRadius.circular(20),
            border: Border.all(
              color: selected ? data.badgeColor : BusinessHealthColors.cardBorder,
            ),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 6,
                height: 6,
                decoration: BoxDecoration(
                  color: data.badgeColor,
                  shape: BoxShape.circle,
                ),
              ),
              const SizedBox(width: 6),
              Text(
                '${data.tabLabel} ${data.count}',
                style: TextStyle(
                  color: selected
                      ? BusinessHealthColors.white
                      : BusinessHealthColors.faintText,
                  fontSize: 12,
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
