import 'package:flutter/material.dart';
import '../data/home_overview_data.dart';
import 'home_summary_card.dart';

class HomeOverviewTab extends StatelessWidget {
  const HomeOverviewTab({super.key, required this.onViewPressingTap});

  final VoidCallback onViewPressingTap;

  @override
  Widget build(BuildContext context) {
    if (homeStoryCards.isEmpty) {
      return const SizedBox.shrink();
    }

    final topCard = homeStoryCards.firstWhere(
      (card) => card.status == HomeCardStatus.pressing,
      orElse: () => homeStoryCards.first,
    );

    return HomeSummaryCard(
      topCard: topCard,
      onTopCardTap: onViewPressingTap,
    );
  }
}
