import 'package:flutter/material.dart';

import '../../../theme/app_theme.dart';

/// Shared status tone used by the headline eyebrow and every "THE FULL
/// READ" category badge (Pressing/Watch/Good/Steady).
enum StatusTone { pressing, watch, good, steady }

extension StatusToneStyle on StatusTone {
  String get badgeText => switch (this) {
    StatusTone.pressing => 'PRESSING',
    StatusTone.watch => 'WATCH',
    StatusTone.good => 'GOOD',
    StatusTone.steady => 'STEADY',
  };

  Color get color => switch (this) {
    StatusTone.pressing => AppColors.critDot,
    StatusTone.watch => AppColors.warnDot,
    StatusTone.good => AppColors.goodDot,
    StatusTone.steady => AppColors.faintText,
  };
}

/// One checklist item in the "Do this" panel.
class DoThisItem {
  const DoThisItem({
    required this.title,
    required this.dateLabel,
    required this.priority,
    required this.tag,
    required this.whyBody,
    this.whyDollarLine,
  });

  final String title;
  final String dateLabel;
  final String priority; // 'HIGH' | 'MEDIUM'
  final String tag;
  final String whyBody;
  final String? whyDollarLine;
}

/// One driver in the "What's moving demand" panel.
class ForceItem {
  const ForceItem({
    required this.title,
    required this.dateLabel,
    required this.deltaLabel,
    required this.positive,
    required this.body,
    required this.confidencePercent,
    required this.sourceLabel,
  });

  final String title;
  final String dateLabel;
  final String deltaLabel;
  final bool positive;
  final String body;
  final int confidencePercent;
  final String sourceLabel;
}

/// The four math rows in "How the number breaks down".
class BreakdownData {
  const BreakdownData({
    required this.committed,
    required this.expectedLosses,
    required this.unbookedDemand,
    required this.externalAdjustment,
  });

  final String committed;
  final String expectedLosses;
  final String unbookedDemand;
  final String externalAdjustment;
}

/// The single "World scan" item.
class WorldScanData {
  const WorldScanData({
    required this.title,
    required this.dateLabel,
    required this.body,
    required this.sourceLabel,
    this.doNow,
  });

  final String title;
  final String dateLabel;
  final String body;
  final String? doNow;
  final String sourceLabel;
}

/// Everything shown for one top tab (This weekend / Rest of month).
class ForecastTabData {
  const ForecastTabData({
    required this.status,
    required this.dateRangeLabel,
    required this.headline,
    required this.expectedLabel,
    required this.expectedValue,
    required this.normalValue,
    required this.deltaLabel,
    required this.deltaPositive,
    required this.confidencePercent,
    required this.confidenceLabel,
    required this.confidenceBody,
    required this.swingFactorBody,
    required this.doThisTone,
    required this.doThisSummary,
    required this.doThisIntro,
    required this.doThisItems,
    required this.movingTone,
    required this.movingSummary,
    required this.movingItems,
    this.breakdownTone = StatusTone.steady,
    required this.breakdownSummary,
    required this.breakdown,
    this.trackRecordTone = StatusTone.good,
    required this.trackRecordSummary,
    required this.trackRecordBody,
    required this.trackRecordFooter,
    required this.worldScanTone,
    this.worldScanCount,
    required this.worldScan,
  });

  final StatusTone status;
  final String dateRangeLabel;
  final String headline;
  final String expectedLabel;
  final String expectedValue;
  final String normalValue;
  final String deltaLabel;
  final bool deltaPositive;
  final int confidencePercent;
  final String confidenceLabel;
  final String confidenceBody;
  final String swingFactorBody;

  final StatusTone doThisTone;
  final String doThisSummary;
  final String doThisIntro;
  final List<DoThisItem> doThisItems;
  final StatusTone movingTone;
  final String movingSummary;
  final List<ForceItem> movingItems;
  final StatusTone breakdownTone;
  final String breakdownSummary;
  final BreakdownData breakdown;
  final StatusTone trackRecordTone;
  final String trackRecordSummary;
  final String trackRecordBody;
  final String trackRecordFooter;
  final StatusTone worldScanTone;
  final String? worldScanCount;
  final WorldScanData worldScan;
}

const thisWeekendForecast = ForecastTabData(
  status: StatusTone.pressing,
  dateRangeLabel: 'FEB 13–15',
  headline:
      "Valentine's Saturday is your biggest night of the quarter — "
      'dough is the only thing that can spoil it.',
  expectedLabel: 'THIS WEEKEND',
  expectedValue: '~\$14,700',
  normalValue: 'vs your normal \$13,400',
  deltaLabel: '+10%',
  deltaPositive: true,
  confidencePercent: 84,
  confidenceLabel: 'MODERATE CONFIDENCE',
  confidenceBody:
      'Three Februaries of Square POS history and pie pre-orders '
      'already coming in make the Saturday call solid; the open '
      'question is Friday — whether dough production scales before '
      'the rush.',
  swingFactorBody:
      "Friday dough. Scale Thursday's prep past the ≈\$5,200 cap and "
      "the weekend runs toward \$15,000; sell out by 8pm again — it's "
      'happened twice this month — and ≈\$330 walks (≈17 orders at '
      'your \$19 ticket), nearer \$14,400.',
  doThisTone: StatusTone.pressing,
  doThisSummary:
      "Scale Friday's dough past the \$5,200 cap, take Valentine's "
      'pre-orders at the counter, add a Saturday counter hand',
  doThisIntro:
      'Three moves, all decided by Thursday — the why and the dollar '
      'logic are under each one.',
  doThisItems: [
    DoThisItem(
      title: "Scale Friday's dough past the \$5,200 cap",
      dateLabel: "set Thursday's prep by Feb 12",
      priority: 'HIGH',
      tag: 'Friday dough cap',
      whyBody:
          'Fridays have sold out by 8pm twice this month — turn-aways '
          'are running ≈35 orders a week at the Fri–Sat peak, and '
          "Valentine's spillover starts Friday. The cap is production, "
          'not demand — a bigger Thursday batch is the whole fix.',
      whyDollarLine:
          '≈\$180/week of added dough and ingredient prep against '
          '≈\$330 recovered this Friday — and every Friday after.',
    ),
    DoThisItem(
      title: "Take Valentine's pie pre-orders at the counter and on "
          'the box-top QR',
      dateLabel: 'start today, Feb 11',
      priority: 'MEDIUM',
      tag: "Valentine's on a Saturday",
      whyBody:
          'Pre-orders smooth the Saturday oven line, and every direct '
          'pre-order skips the ~24% delivery-app commission on what '
          'will be the biggest night of the quarter.',
      whyDollarLine:
          'A pre-ordered pie taken direct keeps the ~\$7 the apps '
          'would take from a \$31 delivery ticket.',
    ),
    DoThisItem(
      title: 'Add a second counter hand Saturday 5–10pm',
      dateLabel: 'post the shift by Thu Feb 12',
      priority: 'MEDIUM',
      tag: "Valentine's on a Saturday",
      whyBody:
          'Your counter is the bottleneck on big nights, not the 22 '
          'seats. One extra hand keeps the slice line moving while '
          'the ovens run whole pies.',
      whyDollarLine:
          '~\$100 of labor for the five hours against a ≈\$1,900 '
          'Saturday lift.',
    ),
  ],
  movingTone: StatusTone.good,
  movingSummary:
      "Valentine's Saturday adds +\$1,900, the Friday dough cap "
      'risks -\$330, a cold snap risks -\$300',
  movingItems: [
    ForceItem(
      title: "Valentine's on a Saturday",
      dateLabel: 'Sat Feb 14',
      deltaLabel: '+\$1,900',
      positive: true,
      body:
          "Feb 14 falls on your strongest service of the week for the "
          "first time since 2015. Couples trade slices for whole "
          "specialty pies, and last year's midweek Valentine's still "
          'added \$1,400. Expect the strongest single night of Q1 — '
          'the constraint is the oven line, not your 22 seats.',
      confidencePercent: 82,
      sourceLabel: 'your Square history',
    ),
    ForceItem(
      title: 'Friday dough cap',
      dateLabel: 'Fri Feb 13',
      deltaLabel: '-\$330',
      positive: false,
      body:
          'Dough production currently caps Friday at ≈\$5,200, and '
          "you've sold out by 8pm twice this month. Valentine's "
          'spillover starts Friday; without a bigger batch, ≈17 '
          'orders (≈\$330 at your \$19 ticket) walk again — across '
          'the Fri–Sat peak that\'s ≈35 a week, ≈\$2,700 a month.',
      confidencePercent: 75,
      sourceLabel: 'your history (2 sell-outs this month)',
    ),
    ForceItem(
      title: 'Cold snap lingering into Friday',
      dateLabel: 'Fri Feb 13',
      deltaLabel: '-\$300',
      positive: false,
      body:
          'Single-digit wind chills forecast midweek may hold into '
          'Friday. Cold nights shift slice traffic to the delivery '
          'apps — 14% of your orders at ≈24% commission — so the '
          'same demand nets less, and some walk-in trade stays home.',
      confidencePercent: 45,
      sourceLabel: 'live web (forecast) + your history',
    ),
  ],
  breakdownSummary:
      "\$770 committed, walk-ins ~95% of the weekend, Valentine's "
      'nets +\$1,900',
  breakdown: BreakdownData(
    committed:
        '≈\$770 already on the books — Valentine\'s whole-pie '
        'pre-orders plus two catering trays (half \$45 / full \$85)',
    expectedLosses:
        'no reservations to no-show — the risk is supply-side: a '
        'Friday dough sell-out costs ≈\$330',
    unbookedDemand:
        'walk-in slices and pies are ~95% of the weekend — Fri–Sat '
        'dinner alone runs 41% of your week',
    externalAdjustment:
        "Valentine's on a Saturday nets ≈+\$1,900 over a normal "
        'weekend',
  ),
  trackRecordSummary: 'Last 5 forecasts within 9% — safe to commit on this',
  trackRecordBody:
      'Your last 5 weekly forecasts landed within 9% of actual — '
      'including the two Fridays this read flagged as sell-out '
      'risks. When it says scale dough, it has been right.',
  trackRecordFooter:
      "Safe to commit on Thursday's dough order and the Saturday "
      'schedule on this.',
  worldScanTone: StatusTone.watch,
  worldScanCount: '1 watch',
  worldScan: WorldScanData(
    title: 'Mid-winter recess starts Monday Feb 16',
    dateLabel: 'next week',
    body:
        'Your school-lunch slice trade — NYC public schools are out '
        "Feb 16–20, which takes ≈\$980 out of next week's weekday "
        'lunch. It comes back Feb 23.',
    doNow:
        "Do now: trim next week's lunch prep when you place Sunday's "
        'dough and mozzarella order.',
    sourceLabel: 'NYC DOE calendar (live web) + your Square history',
  ),
);

const restOfMonthForecast = ForecastTabData(
  status: StatusTone.watch,
  dateRangeLabel: 'FEB 16–28',
  headline:
      "Recess takes your lunch line next week — trim the prep and "
      'the month stays on pace.',
  expectedLabel: 'REST OF MONTH',
  expectedValue: '~\$48,100',
  normalValue: 'vs your normal \$49,500',
  deltaLabel: '-3%',
  deltaPositive: false,
  confidencePercent: 87,
  confidenceLabel: 'HIGH CONFIDENCE',
  confidenceBody:
      'The dent is a calendar fact — the DOE recess dates are '
      "published — and your February baseline has been steady for "
      'three years; the only soft spot is how hard the cold snap '
      'bites.',
  swingFactorBody:
      'the Tue–Thu cold snap. A mild week keeps the dip to ≈\$980 '
      '(recess only); single digits all three days pushes it nearer '
      '-\$1,600 against normal.',
  doThisTone: StatusTone.watch,
  doThisSummary:
      'Trim recess-week prep ~15% (order by Sun), lock the bigger '
      'Friday dough batch, QR the cold-snap deliveries',
  doThisIntro: "A soft week you can see coming — here's how to spend less through it.",
  doThisItems: [
    DoThisItem(
      title: 'Trim Feb 16–20 lunch prep about 15%',
      dateLabel: 'order by Sun Feb 15',
      priority: 'HIGH',
      tag: 'Mid-winter recess',
      whyBody:
          'NYC public schools are out all week, and the school-lunch '
          'slice line goes with them. Ordering to the lighter demand '
          'avoids waste on flour, cheese, and prepped dough that '
          "won't sell.",
      whyDollarLine:
          '≈\$980 less lunch demand for the week — trimming 15% '
          'keeps waste from eating the savings.',
    ),
    DoThisItem(
      title: 'Use the quiet week to lock the bigger Friday dough batch',
      dateLabel: 'week of Feb 16',
      priority: 'MEDIUM',
      tag: 'Mid-winter recess',
      whyBody:
          'The slowest lunch week of the month is the cheapest time '
          'to test scaled-up Friday production before it matters — '
          'turn-aways are running ≈35 orders a week at the peak.',
      whyDollarLine:
          '≈\$180/week of added prep against the ≈\$620/week '
          '(\$2,700/month) walking away at the Friday–Saturday peak '
          '— and it compounds every Friday.',
    ),
    DoThisItem(
      title: 'Put the box-top QR on every cold-snap delivery',
      dateLabel: 'Feb 17–19',
      priority: 'MEDIUM',
      tag: 'Midweek cold snap',
      whyBody:
          'Cold nights push orders to the apps at ~24% commission. '
          'The QR nudges customers to order direct next time — the '
          'cheapest fix for a weather week.',
      whyDollarLine:
          'Every shifted order keeps ~\$7 of a \$31 delivery ticket '
          'in the shop.',
    ),
  ],
  movingTone: StatusTone.watch,
  movingSummary:
      'Recess takes -\$980 of lunch, the cold snap risks -\$650, '
      '\$260 of catering lands at month-end',
  movingItems: [
    ForceItem(
      title: 'Mid-winter recess',
      dateLabel: 'Feb 16–20',
      deltaLabel: '-\$980',
      positive: false,
      body:
          'NYC public schools are out all week, and the '
          'school-lunch slice line goes with them — the same trade '
          "that added \$980 to weekday lunch this month. It returns "
          'Monday Feb 23. Dinner is untouched.',
      confidencePercent: 88,
      sourceLabel: 'NYC DOE calendar (live web) + your Square history',
    ),
    ForceItem(
      title: 'Midweek cold snap',
      dateLabel: 'Feb 17–19',
      deltaLabel: '-\$650',
      positive: false,
      body:
          'Single-digit wind chills forecast Tue–Thu shift slice '
          'traffic to the delivery apps — 14% of your orders at '
          '≈24% commission — so the same demand nets less, and some '
          'walk-in trade stays home entirely.',
      confidencePercent: 55,
      sourceLabel: 'live web (forecast) + your history',
    ),
    ForceItem(
      title: 'Catering trays on the books',
      dateLabel: 'Feb 26–27',
      deltaLabel: '+\$260',
      positive: true,
      body:
          'The two sheet-pan orders you accepted this month (of six '
          'inquiries) land at month-end — two full trays and two '
          'halves at \$85/\$45, batched into slow weekday afternoons.',
      confidencePercent: 90,
      sourceLabel: 'orders on the books',
    ),
  ],
  breakdownSummary:
      '\$260 catering committed, walk-ins ~97%, recess -\$980 with '
      'dinner untouched',
  breakdown: BreakdownData(
    committed:
        '\$260 in catering already on the books for Feb 26–27',
    expectedLosses:
        '≈\$980 of weekday lunch during recess, plus up to ≈\$650 '
        'more if the cold snap runs cold',
    unbookedDemand:
        'walk-in slices and pies are ~97% of the month outside '
        'committed catering, with dinner untouched by recess',
    externalAdjustment:
        'no calendar tailwind this stretch — recess and the cold '
        'snap both net negative',
  ),
  trackRecordSummary: 'Last 5 forecasts within 9% — fine to cut the order on this',
  trackRecordBody:
      'Your last 5 weekly forecasts landed within 9% of actual — '
      'fine to cut the order on this.',
  trackRecordFooter:
      'Trimming to a calendar-confirmed dip like recess is the '
      'lowest-risk call this read makes all month.',
  worldScanTone: StatusTone.steady,
  worldScan: WorldScanData(
    title: 'Spring watch: school pizza-party season books 3–4 weeks '
        'ahead',
    dateLabel: 'looking ahead',
    body:
        'Once recess clears, spring class-party bookings typically '
        'start landing — worth flagging to regulars now so March '
        "isn't a scramble.",
    sourceLabel: 'your booking history (last 2 springs)',
  ),
);
