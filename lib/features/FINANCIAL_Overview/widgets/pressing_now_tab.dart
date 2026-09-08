import 'package:flutter/material.dart';
import '../../../theme/app_theme.dart';
import '../data/home_overview_data.dart';
import 'home_detail_card.dart';
import 'home_story_carousel.dart';

class PressingNowTab extends StatefulWidget {
  const PressingNowTab({super.key});

  @override
  State<PressingNowTab> createState() => _PressingNowTabState();
}

class _PressingNowTabState extends State<PressingNowTab> {
  int _selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    final pressingCards = homeStoryCards
        .where(
          (card) =>
              card.status == HomeCardStatus.pressing ||
              card.status == HomeCardStatus.building,
        )
        .toList();
    final cards = pressingCards.isNotEmpty ? pressingCards : homeStoryCards;

    if (cards.isEmpty) {
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

    final currentIndex = _selectedIndex < cards.length ? _selectedIndex : 0;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        HomeStoryCarousel(
          cards: cards,
          selectedIndex: currentIndex,
          onSelect: (index) => setState(() => _selectedIndex = index),
        ),
        const SizedBox(height: 16),
        HomeDetailCard(card: cards[currentIndex]),
      ],
    );
  }
}
