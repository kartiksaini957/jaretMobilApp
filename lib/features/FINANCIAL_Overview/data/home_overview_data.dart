import 'package:flutter/material.dart';
import 'package:flutter_application_1/features/FINANCIAL_Overview/model/financialOverviewModel.dart';
import '../../../theme/app_theme.dart';

enum HomeCardStatus { resolved, pressing, building, stable, worthKnowing }

extension HomeCardStatusStyle on HomeCardStatus {
  String get label => switch (this) {
    HomeCardStatus.resolved => 'RESOLVED',
    HomeCardStatus.pressing => 'PRESSING NOW',
    HomeCardStatus.building => 'BUILDING',
    HomeCardStatus.stable => 'STABLE',
    HomeCardStatus.worthKnowing => 'WORTH KNOWING',
  };

  Color get color => switch (this) {
    HomeCardStatus.resolved => AppColors.goodDot,
    HomeCardStatus.pressing => AppColors.critDot,
    HomeCardStatus.building => AppColors.warnDot,
    HomeCardStatus.stable => AppColors.faintText,
    HomeCardStatus.worthKnowing => AppColors.goodDot,
  };
}

class ExpectedOutcome {
  const ExpectedOutcome({
    required this.impactLabel,
    required this.impactDetail,
    required this.effort,
    required this.confidence,
    required this.primaryActionLabel,
    required this.secondaryActionLabel,
  });

  final String impactLabel;
  final String impactDetail;
  final String effort;
  final String confidence;
  final String primaryActionLabel;
  final String secondaryActionLabel;
}

class HomeStoryCard {
  HomeStoryCard({
    this.id = '',
    required this.status,
    required this.headline,
    required this.statLabel,
    required this.whatsGoingOn,
    required this.whyItMattersNow,
    required this.whatToDo,
    this.expectedOutcome,
    this.isAcknowledged = false,
    this.isSnoozed = false,
  });

  final String id;
  final HomeCardStatus status;
  final String headline;
  final String statLabel;
  final String whatsGoingOn;
  final String whyItMattersNow;
  final String whatToDo;
  final ExpectedOutcome? expectedOutcome;
  bool isAcknowledged;
  bool isSnoozed;
}

String homeSummaryEyebrow = '1 THING NEEDS YOU THIS WEEK';
String homeSummaryHeadlineLead = "You're ";
String homeSummaryHeadlineAccent = 'steady.';
String homeSummaryBody = '';

List<HomeStoryCard> homeStoryCards = [];

HomeCardStatus _statusFromPressingScore(int score) {
  if (score >= 80) return HomeCardStatus.pressing;
  if (score >= 55) return HomeCardStatus.building;
  return HomeCardStatus.worthKnowing;
}

String _accentFromBannerStatus(String status) {
  switch (status) {
    case 'above_average':
    case 'top_tier':
      return 'profitable.';
    case 'below_average':
      return 'stretched.';
    default:
      return 'steady.';
  }
}

String _effortLabel(String effort) {
  switch (effort) {
    case 'quick_win':
      return 'Quick win';
    case 'moderate':
      return 'Moderate';
    default:
      return effort.isEmpty ? '—' : effort;
  }
}

void applyFinancialOverviewToHome(FinancialOverviewResponse data) {
  final banner = data.insights.profitabilityBanner;
  final count = data.insights.items.length;

  homeSummaryEyebrow =
      '$count THING${count == 1 ? '' : 'S'} NEED${count == 1 ? 'S' : ''} YOU THIS WEEK';
  homeSummaryHeadlineAccent = _accentFromBannerStatus(banner.status);
  homeSummaryBody = banner.supportingText.isNotEmpty
      ? banner.supportingText
      : banner.headline;

  homeStoryCards = data.insights.items.map((item) {
    return HomeStoryCard(
      id: item.id.isNotEmpty ? item.id : 'margin_compression',
      status: _statusFromPressingScore(item.pressingScore),
      headline: item.headline,
      statLabel: item.expectedImpact.valueText,
      whatsGoingOn: item.whatsGoingOn,
      whyItMattersNow: item.whyItMattersNow,
      whatToDo: item.whatToDo,
      isAcknowledged: item.isRead || item.status == 'acknowledged',
      isSnoozed: item.isSnoozed || item.status == 'snoozed',
      expectedOutcome: ExpectedOutcome(
        impactLabel: item.expectedImpact.valueText,
        impactDetail: item.expectedImpact.calculationBasis,
        effort: _effortLabel(item.effort),
        confidence: item.confidence.isEmpty
            ? 'Medium'
            : item.confidence[0].toUpperCase() + item.confidence.substring(1),
        primaryActionLabel: 'Draft the supplier ask',
        secondaryActionLabel: 'Snooze',
      ),
    );
  }).toList();
}
