import 'package:flutter/material.dart';

import '../theme/business_health_colors.dart';

/// One expandable row inside a [ReadCategoryData] card: a title, the AI's
/// explanation, an optional "possible causes" breakdown, an optional
/// "why now" lead-in (used by alerts), and a recommended action.
class ReadItemData {
  const ReadItemData({
    required this.title,
    required this.body,
    this.possibleCauses,
    this.whyNowText,
    this.actionLabel = 'DO THIS',
    required this.actionBody,
  });

  final String title;
  final String body;
  final List<String>? possibleCauses;
  final String? whyNowText;
  final String actionLabel;
  final String actionBody;
}

/// One tab of "The Full Read": Working for you / Dragging you down /
/// Priority watch areas / Active health alerts.
class ReadCategoryData {
  const ReadCategoryData({
    required this.tabLabel,
    required this.badgeText,
    required this.badgeColor,
    required this.cardTitle,
    required this.countLabel,
    required this.items,
  });

  final String tabLabel;
  final String badgeText;
  final Color badgeColor;
  final String cardTitle;
  final String countLabel;
  final List<ReadItemData> items;

  int get count => items.length;
}

const fullReadCategories = [
  ReadCategoryData(
    tabLabel: 'Working for you',
    badgeText: 'WORKING',
    badgeColor: BusinessHealthColors.dotGood,
    cardTitle: 'Working for you',
    countLabel: 'items',
    items: [
      ReadItemData(
        title: 'Weekend dinner is carrying the month',
        body:
            "Friday and Saturday dinner is running 14% ahead of last "
            "February — about \$3,240 of the month's \$3,610 revenue "
            'gain — while the school-lunch slice trade holds weekday '
            "lunch steady. It's the single biggest reason Growth leads "
            'your categories.',
        actionBody:
            'Fix Friday dough production before the rush — dough has '
            'sold out by 8pm twice this month, and turn-aways are '
            'running ≈35 orders a week at the Fri–Sat peak, roughly '
            '\$2,700 a month at your \$19 average ticket. Have extra '
            'dough proofed for Saturday February 14; it should be the '
            'strongest night of Q1.',
      ),
      ReadItemData(
        title: 'Customers keep coming back — 4.5★ across 212 Google reviews',
        body:
            'Your Google rating holds at 4.5 stars across 212 reviews, '
            'and the recent ones name the square slices and Friday '
            'pies specifically. The repeat trade shows up in the '
            "register too — the school-lunch slice run added \$980 to "
            "weekday lunch this month. That's what holds Customers "
            'above average.',
        actionBody:
            'Reply to the latest reviews that mention Friday sell-outs '
            "and say the dough fix is coming — it turns your one "
            'recurring complaint into proof you listen. Watch review '
            'pace through the Feb 16–20 recess week, when the school '
            'trade pauses.',
      ),
    ],
  ),
  ReadCategoryData(
    tabLabel: 'Dragging you down',
    badgeText: 'DRAGGING',
    badgeColor: BusinessHealthColors.warnColor,
    cardTitle: 'Dragging you down',
    countLabel: 'items',
    items: [
      ReadItemData(
        title: 'Cheese costs are leaking margin — about \$780 a month recoverable',
        body:
            'Mozzarella is up 8% since December, pushing food cost to '
            '33% of sales — 3 points above your 30% target — and '
            'taking 1.1 points of net margin. At your 400 lb/week '
            'usage, the gap between the \$4.85/lb you pay and the '
            '\$4.40/lb Restaurant Depot on Hamilton Ave lists is about '
            '\$780 a month.',
        actionBody:
            'Switch your mozzarella order to Restaurant Depot on '
            'Hamilton Ave at \$4.40/lb — lock in a 4-week supply so the '
            'price holds through the next delivery cycle, recovering '
            'roughly \$780 a month back into margin.',
      ),
      ReadItemData(
        title: 'Cash cushion sits below the peer line',
        body:
            'Runway slipped from 7.9 to 7.5 months after the walk-in '
            'compressor replacement and winter gas running \$310 a '
            'month higher. That\'s below the 10-month median for '
            'single-location pizzerias — bottom third on cushion — '
            "with July's slow weeks ahead.",
        actionBody:
            'Ring-fence the \$780 monthly cheese saving and the \$1,140 '
            'in overdue catering invoices straight into the cash '
            'buffer instead of general operating funds, to rebuild '
            'runway before the summer slow weeks.',
      ),
    ],
  ),
  ReadCategoryData(
    tabLabel: 'Watch areas',
    badgeText: 'WATCH',
    badgeColor: BusinessHealthColors.warnColor,
    cardTitle: 'Priority watch areas',
    countLabel: 'watches',
    items: [
      ReadItemData(
        title: 'Two catering invoices are past due',
        body:
            '\$1,140 across two catering clients is past due this '
            'week. Small against \$41,870 of month-to-date revenue, '
            'but up-front catering deposits are what\'s holding cash '
            'flow at +\$6,240 — letting the back half slip undercuts '
            'that.',
        possibleCauses: [
          'Both invoices went out without a printed due date — the '
              'clients may be assuming net-30. — your QuickBooks '
              'invoice copies',
          'One client is a school office that pays on a district PO '
              'cycle, which typically runs 3–4 weeks. — your invoice '
              'history',
        ],
        actionBody:
            'Send a same-day follow-up on both invoices with a printed '
            'due date and payment link, and flag the school-office '
            'client\'s PO cycle so future catering invoices go out '
            'earlier against that 3–4 week turnaround.',
      ),
      ReadItemData(
        title: 'Delivery-app fees are creeping into your margin',
        body:
            'Delivery apps took 14% of your orders this month at '
            'roughly 24% average commission — that channel mix alone '
            'cost 0.6 points of margin. The read is that regulars are '
            'shifting to the apps rather than new customers arriving '
            'through them.',
        actionLabel: 'CONFIRM FOR ME',
        actionBody:
            'Add a "order direct and save 10%" card to delivery-app '
            'orders and point regulars to your own ordering link — '
            'shifting even a third of that 14% back in-house recovers '
            'most of the 0.6-point margin hit.',
      ),
    ],
  ),
  ReadCategoryData(
    tabLabel: 'Alerts',
    badgeText: 'ACT NOW',
    badgeColor: BusinessHealthColors.negativeText,
    cardTitle: 'Active health alerts',
    countLabel: 'active',
    items: [
      ReadItemData(
        title:
            'Cash runway crossed below 8 months — 7.5 at the current '
            'burn — heading into the summer slow weeks.',
        body: '',
        whyNowText:
            'the walk-in repair and higher gas bills already took 0.4 '
            'months this quarter. Your \$52,400 balance against '
            '≈\$6,950 in fixed monthly obligations is the 7.5-month '
            'read, and the \$20,000 reserve floor is the line not to '
            'cross — rebuilding cushion takes months, not weeks.',
        actionBody:
            'This week — collect the \$1,140 in overdue catering '
            'invoices, keep the \$1,750 tax set-aside ring-fenced, and '
            'route the \$780 monthly cheese saving straight into the '
            'buffer. Target: back above 8 months by April.',
      ),
    ],
  ),
];
