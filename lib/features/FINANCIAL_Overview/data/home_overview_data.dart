import 'package:flutter/material.dart';

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

/// The "Expected outcome" block + action buttons, only present on items
/// that have already been actioned (currently just the resolved repair).
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

/// One card in the Home carousel + its expandable detail.
class HomeStoryCard {
  const HomeStoryCard({
    required this.status,
    required this.headline,
    required this.statLabel,
    required this.whatsGoingOn,
    required this.whyItMattersNow,
    required this.whatToDo,
    this.expectedOutcome,
  });

  final HomeCardStatus status;
  final String headline;
  final String statLabel;
  final String whatsGoingOn;
  final String whyItMattersNow;
  final String whatToDo;
  final ExpectedOutcome? expectedOutcome;
}

const homeSummaryEyebrow = '1 THING NEEDS YOU THIS WEEK';
const homeSummaryHeadlineLead = "You're ";
const homeSummaryHeadlineAccent = 'profitable.';
const homeSummaryBody =
    'Net margin 11.6% — above your 10.5% target — and February pacing '
    '9.4% ahead of January.';

const homeStoryCards = [
  HomeStoryCard(
    status: HomeCardStatus.resolved,
    headline: 'Walk-in repair is paid off — the cash hit is behind you',
    statLabel: '\$2,100 · paid in full',
    whatsGoingOn:
        'The walk-in compressor died in January and was replaced for '
        '\$2,100, paid in full from operating cash — no financing, no '
        'lingering monthly payment.',
    whyItMattersNow:
        "It's why runway dipped from 7.9 to 7.5 months. The hit is "
        'one-time: nothing else on the cooler line is flagged, so the '
        'buffer can rebuild from here.',
    whatToDo:
        'Nothing required. Before the next equipment failure, get a '
        "lease-vs-own quote so a single repair doesn't take 0.3 months "
        'of runway again.',
    expectedOutcome: ExpectedOutcome(
      impactLabel: 'Closed — no ongoing cost',
      impactDetail:
          '\$2,100 replacement + ≈\$6,950 fixed monthly obligations = '
          '0.3 months of runway, taken once.',
      effort: 'Done',
      confidence: 'High',
      primaryActionLabel: 'View the paid repair',
      secondaryActionLabel: 'Snooze',
    ),
  ),
  HomeStoryCard(
    status: HomeCardStatus.pressing,
    headline: 'Cheese is eating a point of your margin',
    statLabel: '\$4.85/lb · 33% food cost',
    whatsGoingOn:
        'Mozzarella is up 8% since December to \$4.85/lb. At 400 '
        'lb/week, cheese alone is 11.2% of sales, and food cost hit '
        '33% — 3 points above your 30% target.',
    whyItMattersNow:
        "It's taking about 1.1 points of net margin — the gap between "
        'your \$4.85/lb price and the \$4.40/lb Restaurant Depot rate '
        'is real money, not noise.',
    whatToDo:
        'Switch your mozzarella order to Restaurant Depot on Hamilton '
        'Ave at \$4.40/lb — lock in a 4-week supply to recover about '
        '\$780 a month back into margin.',
    expectedOutcome: ExpectedOutcome(
      impactLabel: 'Recoverable — ≈\$780/month',
      impactDetail:
          '\$4.40/lb Restaurant Depot rate vs your \$4.85/lb — at 400 '
          'lb/week usage that\'s about \$780 a month back into margin, '
          'closing most of the 1.1-point margin hit.',
      effort: '15 min',
      confidence: 'High',
      primaryActionLabel: 'Draft the supplier ask',
      secondaryActionLabel: 'Snooze',
    ),
  ),
  HomeStoryCard(
    status: HomeCardStatus.building,
    headline: 'Friday dough sell-outs cap your best night',
    statLabel: '≈35 orders/wk · \$2,700/mo',
    whatsGoingOn:
        'Friday dinner sold out of dough by 8pm twice this month, and '
        'turn-aways are running ≈35 orders a week across the Fri–Sat '
        'peak. Dough capacity currently caps Friday at about \$5,200 '
        'of revenue.',
    whyItMattersNow:
        'The cap is production, not demand — every sell-out night '
        'walks ≈17 orders (≈\$330) at your \$19 ticket, and across the '
        'week that\'s ≈\$2,700 a month.',
    whatToDo:
        "Scale Thursday's prep past the \$5,200 cap — about \$180/week "
        'of added dough and ingredient cost against \$330+ recovered '
        'every Friday.',
    expectedOutcome: ExpectedOutcome(
      impactLabel: 'Recoverable — ≈\$330+/week',
      impactDetail:
          '≈\$180/week of added dough and ingredient prep against '
          '≈\$330 recovered this Friday — and every Friday after, '
          'roughly \$2,700/month at the full Fri–Sat peak.',
      effort: 'Thu prep call',
      confidence: 'High',
      primaryActionLabel: "Scale Thursday's batch",
      secondaryActionLabel: 'Snooze',
    ),
  ),
  HomeStoryCard(
    status: HomeCardStatus.building,
    headline: 'Two catering invoices are past due',
    statLabel: '\$1,140 · 2 clients',
    whatsGoingOn:
        'Two catering clients owe a combined \$1,140, both from '
        'January sheet-pan jobs. Small next to a ~\$114.7K February '
        "pace, but it's the only receivable aging on the books.",
    whyItMattersNow:
        "Small against pace, but it's the only receivable aging on "
        'the books — worth clearing before it becomes a pattern.',
    whatToDo:
        'Send a same-day follow-up on both invoices with a printed '
        "due date and payment link, and flag the school-office "
        "client's PO cycle for next time.",
    expectedOutcome: ExpectedOutcome(
      impactLabel: 'Collectible — \$1,140',
      impactDetail:
          'Both invoices are from January sheet-pan jobs — a printed '
          'due date and payment link typically closes small aging '
          'like this within a week.',
      effort: '10 min',
      confidence: 'Medium',
      primaryActionLabel: 'Send the follow-up',
      secondaryActionLabel: 'Snooze',
    ),
  ),
  HomeStoryCard(
    status: HomeCardStatus.stable,
    headline: 'Cash steady at \$52,400 — 7.5 months of cushion',
    statLabel: '\$52,400 · 7.5 mo',
    whatsGoingOn:
        'Operating cash sits at \$52,400 against ≈\$6,950 of fixed '
        'monthly obligations — about 7.5 months of cushion, with '
        'February cash flow positive at +\$6,240.',
    whyItMattersNow:
        '7.5 months sits right at the line business health flags as '
        'the reserve floor — steady, but not a lot of room to absorb '
        'another surprise repair.',
    whatToDo:
        'Nothing required this week. Keep routing the \$780/month '
        'cheese saving and the \$1,140 in overdue invoices straight '
        'into the buffer.',
  ),
  HomeStoryCard(
    status: HomeCardStatus.worthKnowing,
    headline: 'Weekend dinner is carrying the month — up 14%',
    statLabel: '+14% YoY · 41% of weekly revenue',
    whatsGoingOn:
        'Friday–Saturday dinner is running 14% ahead of last February '
        'and now makes up about 41% of weekly revenue — it\'s what '
        'has the month pacing 9.4% over January.',
    whyItMattersNow:
        "Weekend dinner alone is 41% of your week — it's the single "
        'biggest lever on whether February closes ahead or behind '
        'pace.',
    whatToDo:
        "Nothing required — keep an eye on Friday dough capacity so "
        "this strength doesn't get capped by sell-outs.",
  ),
];
