import 'package:flutter/material.dart';

import '../data/home_overview_data.dart';
import 'home_summary_card.dart';

/// "Home" category tab: just the weekly summary card. Its preview row
/// jumps to the "Pressing now" tab, which has the full carousel/detail.
class HomeOverviewTab extends StatelessWidget {
  const HomeOverviewTab({super.key, required this.onViewPressingTap});

  final VoidCallback onViewPressingTap;

  static final HomeStoryCard _topCard = homeStoryCards.firstWhere(
    (card) => card.status == HomeCardStatus.pressing,
  );

  @override
  Widget build(BuildContext context) {
    return HomeSummaryCard(
      topCard: _topCard,
      onTopCardTap: onViewPressingTap,
    );
  }
}
