import 'package:flutter/material.dart';

import '../../../theme/app_theme.dart';
import '../data/home_overview_data.dart';
import 'home_detail_card.dart';
import 'home_story_carousel.dart';

/// "Pressing now" category tab: just the items that still need
/// attention (Pressing / Building), reusing the Home carousel + detail
/// card but filtered down to those two statuses.
class PressingNowTab extends StatefulWidget {
  const PressingNowTab({super.key});

  @override
  State<PressingNowTab> createState() => _PressingNowTabState();
}

class _PressingNowTabState extends State<PressingNowTab> {
  static final List<HomeStoryCard> _cards = homeStoryCards
      .where(
        (card) =>
            card.status == HomeCardStatus.pressing ||
            card.status == HomeCardStatus.building,
      )
      .toList();

  int _selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    if (_cards.isEmpty) {
      return Container(
        width: double.infinity,
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: AppColors.glassDark,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: AppColors.glassBorder),
        ),
        child: Text(
          "Nothing pressing right now — you're caught up.",
          style: AppTextStyles.small,
        ),
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          '${_cards.length} things need you this week',
          style: AppTextStyles.buttonLabel.copyWith(fontSize: 14),
        ),
        const SizedBox(height: 12),
        HomeStoryCarousel(
          cards: _cards,
          selectedIndex: _selectedIndex,
          onSelect: (index) => setState(() => _selectedIndex = index),
        ),
        const SizedBox(height: 16),
        HomeDetailCard(card: _cards[_selectedIndex]),
      ],
    );
  }
}
