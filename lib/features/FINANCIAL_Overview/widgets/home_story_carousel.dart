import 'package:flutter/material.dart';

import '../../../theme/app_theme.dart';
import '../data/home_overview_data.dart';

/// Horizontally scrollable row of story chips; the selected one drives
/// the detail card below.
class HomeStoryCarousel extends StatelessWidget {
  const HomeStoryCarousel({
    super.key,
    required this.cards,
    required this.selectedIndex,
    required this.onSelect,
  });

  final List<HomeStoryCard> cards;
  final int selectedIndex;
  final ValueChanged<int> onSelect;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 78,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: cards.length,
        separatorBuilder: (_, _) => const SizedBox(width: 10),
        itemBuilder: (context, index) {
          final card = cards[index];
          final selected = index == selectedIndex;
          return Material(
            color: AppColors.glassDark,
            borderRadius: BorderRadius.circular(14),
            child: InkWell(
              onTap: () => onSelect(index),
              borderRadius: BorderRadius.circular(14),
              child: Container(
                width: 160,
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(
                    color: selected ? card.status.color : AppColors.glassBorder,
                    width: selected ? 1.4 : 1,
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Container(
                          width: 6,
                          height: 6,
                          decoration: BoxDecoration(
                            color: card.status.color,
                            shape: BoxShape.circle,
                          ),
                        ),
                        const SizedBox(width: 5),
                        Expanded(
                          child: Text(
                            card.status.label,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              color: card.status.color,
                              fontSize: 9.5,
                              fontWeight: FontWeight.w800,
                              letterSpacing: 0.3,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 6),
                    Expanded(
                      child: Text(
                        card.headline,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: AppTextStyles.buttonLabel.copyWith(
                          fontSize: 12.5,
                          height: 1.25,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
