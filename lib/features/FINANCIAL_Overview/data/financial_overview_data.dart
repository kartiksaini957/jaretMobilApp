/// Status tone reused for pills/dots across Financial Overview.
enum MetricTone { good, neutral, bad }

/// Color tone for a "WHAT'S DRIVING IT" line — not every driver is a
/// clean plus/minus (some read "steady" or "watch").
enum ImpactTone { positive, negative, neutral, watch }

/// One "WHAT'S DRIVING IT" line under a metric.
class DrivingFactor {
  const DrivingFactor({
    required this.title,
    required this.subtitle,
    required this.impact,
    required this.tone,
  });

  final String title;
  final String subtitle;
  final String impact; // '+2.4 pts' | 'steady' | 'watch' | ...
  final ImpactTone tone;
}

/// One "Suggested actions" item.
class SuggestedAction {
  const SuggestedAction({required this.priority, required this.body});

  final String priority; // 'HIGH' | 'MED'
  final String body;
}

/// One exchange in the "Ask AI" seed transcript.
class AskAiMessage {
  const AskAiMessage({required this.fromAi, required this.text});

  final bool fromAi;
  final String text;
}

/// Full detail behind one metric pill.
class MetricDetail {
  const MetricDetail({
    required this.label,
    required this.value,
    required this.statusLabel,
    required this.tone,
    required this.trendLabel,
    required this.chartValues,
    required this.chartCaption,
    required this.vsLastMonthBody,
    required this.vsLastMonthDeltaLabel,
    this.hasPeerComparison = true,
    this.vsPeersBody = '',
    this.vsPeersDeltaLabel = '',
    required this.drivingFactors,
    required this.suggestedActions,
    required this.askAiTranscript,
  });

  final String label;
  final String value;
  final String statusLabel;
  final MetricTone tone;
  final String trendLabel;

  /// Relative bar heights (0..1), oldest to newest.
  final List<double> chartValues;
  final String chartCaption;

  final String vsLastMonthBody;
  final String vsLastMonthDeltaLabel;

  /// Some metrics (e.g. Cash Flow MTD) have no meaningful peer benchmark.
  final bool hasPeerComparison;
  final String vsPeersBody;
  final String vsPeersDeltaLabel;

  final List<DrivingFactor> drivingFactors;
  final List<SuggestedAction> suggestedActions;
  final List<AskAiMessage> askAiTranscript;
}

const financialCategories = ['Home', 'Pressing now', 'Ratios', 'Expenses'];

const metricDetails = [
  MetricDetail(
    label: 'Food Cost %',
    value: '33.0%',
    statusLabel: 'Below avg',
    tone: MetricTone.bad,
    trendLabel: '↑ 3.0 pts vs Dec',
    chartValues: [0.55, 0.6, 0.62, 0.66, 1.0],
    chartCaption: 'Food Cost % · last 5 months',
    vsLastMonthBody:
        'Food cost hit 33% of sales — 3 points above your 30% target, '
        'meaning \$3 of every \$100 in sales that should be profit is '
        'going to ingredients, almost all cheese.',
    vsLastMonthDeltaLabel: 'Up 3.0 pts (30.0% → 33.0%)',
    vsPeersBody:
        'At 33% you spend more of each sales dollar on food than the '
        '~30% typical for slice shops your size — the gap is the '
        'cheese creep, not waste.',
    vsPeersDeltaLabel: '33.0% vs 30–31% peer median · above the typical range',
    drivingFactors: [
      DrivingFactor(
        title: 'Mozzarella up 8% since Dec (\$4.85/lb)',
        subtitle: 'Cheese · 11.2% of sales',
        impact: '+2.4 pts',
        tone: ImpactTone.negative,
      ),
      DrivingFactor(
        title: 'Delivery packaging on app orders',
        subtitle: 'Supplies',
        impact: '+0.4 pts',
        tone: ImpactTone.negative,
      ),
      DrivingFactor(
        title: 'Flour + produce drift',
        subtitle: 'Rest of basket',
        impact: '+0.2 pts',
        tone: ImpactTone.negative,
      ),
    ],
    suggestedActions: [
      SuggestedAction(
        priority: 'HIGH',
        body:
            'Lock the \$4.40/lb Restaurant Depot contract — ≈\$780/month '
            'back at your 400 lb/week usage.',
      ),
      SuggestedAction(
        priority: 'MED',
        body:
            'Run a two-week cheese portion audit on whole pies — an '
            'ounce of drift per pie compounds at your volume.',
      ),
    ],
    askAiTranscript: [
      AskAiMessage(
        fromAi: true,
        text:
            'Scoped to Food Cost % — ask anything and the answer uses '
            "Nonna Rosa's February numbers.",
      ),
      AskAiMessage(fromAi: false, text: 'hii'),
      AskAiMessage(
        fromAi: true,
        text:
            'Short version: your numbers support it. Revenue is pacing '
            '+9.4% and margin is holding at 11.6% — the watch-item is '
            'the 7.5-month runway.',
      ),
    ],
  ),
  MetricDetail(
    label: 'Labor %',
    value: '28.7%',
    statusLabel: 'Above avg',
    tone: MetricTone.good,
    trendLabel: '↓ 0.9 pts since Oct',
    chartValues: [0.75, 0.7, 0.68, 0.62, 0.5],
    chartCaption: 'Labor % · last 5 months',
    vsLastMonthBody:
        'Labor runs 28.7% of sales — lean for a counter-service shop, '
        'and that efficiency is what added 2.1 points of margin this '
        'month.',
    vsLastMonthDeltaLabel: 'Down 0.9 pts (29.6% → 28.7%)',
    vsPeersBody:
        'Your 28.7% is lean against the ~30–32% band for '
        'counter-service slice shops your size.',
    vsPeersDeltaLabel: '28.7% vs 30–32% peer median · below the typical range',
    drivingFactors: [
      DrivingFactor(
        title: 'Counter service, no floor staff',
        subtitle: 'Model',
        impact: '+2.1 pts',
        tone: ImpactTone.positive,
      ),
      DrivingFactor(
        title: '4 FT / 5 PT staffing mix',
        subtitle: 'Schedule fit',
        impact: 'steady',
        tone: ImpactTone.neutral,
      ),
      DrivingFactor(
        title: 'Fri–Sat dinner rush strain',
        subtitle: 'Capacity',
        impact: 'watch',
        tone: ImpactTone.watch,
      ),
    ],
    suggestedActions: [
      SuggestedAction(
        priority: 'MED',
        body:
            'Keep the current schedule through February — no action '
            'needed while labor tracks lean of the peer band.',
      ),
    ],
    askAiTranscript: [
      AskAiMessage(
        fromAi: true,
        text:
            'Scoped to Labor % — ask anything and the answer uses '
            "Nonna Rosa's February numbers.",
      ),
    ],
  ),
  MetricDetail(
    label: 'Net Margin',
    value: '11.6%',
    statusLabel: 'Above avg',
    tone: MetricTone.good,
    trendLabel: '↑ 0.4 pts',
    chartValues: [0.5, 0.52, 0.55, 0.58, 0.85],
    chartCaption: 'Net Margin · last 5 months',
    vsLastMonthBody:
        'Net margin rose 0.4 points to 11.6% — above your 10.5% '
        'target, with counter-service labor efficiency outrunning '
        'cheese-cost creep.',
    vsLastMonthDeltaLabel: 'Up 0.4 pts (11.2% → 11.6%)',
    vsPeersBody:
        'Your 11.6% sits above the 10–10.5% typical range for '
        'independent slice shops your size.',
    vsPeersDeltaLabel: '11.6% vs 10.5% peer median · above the typical range',
    drivingFactors: [
      DrivingFactor(
        title: 'Counter-service labor efficiency',
        subtitle: 'Labor',
        impact: '+2.1 pts',
        tone: ImpactTone.positive,
      ),
      DrivingFactor(
        title: 'Mozzarella up 8% since Dec',
        subtitle: 'Food cost',
        impact: '-1.1 pts',
        tone: ImpactTone.negative,
      ),
      DrivingFactor(
        title: 'Delivery-app order mix',
        subtitle: 'Channel fees',
        impact: '-0.6 pts',
        tone: ImpactTone.negative,
      ),
    ],
    suggestedActions: [
      SuggestedAction(
        priority: 'MED',
        body:
            'Recover the \$780/month cheese saving to push margin '
            'toward 13%.',
      ),
    ],
    askAiTranscript: [
      AskAiMessage(
        fromAi: true,
        text:
            'Scoped to Net Margin — ask anything and the answer uses '
            "Nonna Rosa's February numbers.",
      ),
    ],
  ),
  MetricDetail(
    label: 'Revenue MTD',
    value: '\$41,870',
    statusLabel: 'Top tier',
    tone: MetricTone.good,
    trendLabel: '↑ 9.4% vs Jan',
    chartValues: [0.45, 0.5, 0.55, 0.65, 1.0],
    chartCaption: 'Revenue MTD · last 5 months',
    vsLastMonthBody:
        'Revenue is pacing 9.4% ahead of January, carried by Friday '
        'and Saturday dinner and the school-lunch slice trade.',
    vsLastMonthDeltaLabel: 'Up \$3,610 (\$38.3K → \$41.9K)',
    vsPeersBody:
        'Growth this strong is well above the low-single-digit pace '
        'typical for slice shops your size this time of year.',
    vsPeersDeltaLabel: '+9.4% vs ~3% peer median · well above typical range',
    drivingFactors: [
      DrivingFactor(
        title: 'Friday–Saturday dinner up 14%',
        subtitle: 'Daypart',
        impact: '+\$3,240',
        tone: ImpactTone.positive,
      ),
      DrivingFactor(
        title: 'School-lunch slice trade',
        subtitle: 'Weekday lunch',
        impact: '+\$980',
        tone: ImpactTone.positive,
      ),
      DrivingFactor(
        title: 'Snow closure Tuesday the 4th',
        subtitle: 'One-off',
        impact: '-\$1,410',
        tone: ImpactTone.negative,
      ),
    ],
    suggestedActions: [
      SuggestedAction(
        priority: 'HIGH',
        body:
            "Scale Friday's dough production so the weekend momentum "
            "doesn't sell out early.",
      ),
    ],
    askAiTranscript: [
      AskAiMessage(
        fromAi: true,
        text:
            'Scoped to Revenue MTD — ask anything and the answer uses '
            "Nonna Rosa's February numbers.",
      ),
    ],
  ),
  MetricDetail(
    label: 'Cash Flow MTD',
    value: '+\$6,240',
    statusLabel: 'Above avg',
    tone: MetricTone.good,
    trendLabel: '↑ \$4,090 vs Jan',
    chartValues: [0.3, 0.4, 0.45, 0.55, 0.9],
    chartCaption: 'Cash Flow MTD · last 5 months',
    vsLastMonthBody:
        'Cash flow is positive at +\$6,240 month-to-date — catering '
        'deposits landed early and outflows stayed on schedule.',
    vsLastMonthDeltaLabel: 'Up \$4,090 (\$2,150 → \$6,240)',
    hasPeerComparison: false,
    drivingFactors: [
      DrivingFactor(
        title: 'Catering deposits collected up front',
        subtitle: 'Receivables',
        impact: '+\$2,300',
        tone: ImpactTone.positive,
      ),
      DrivingFactor(
        title: 'Flour order timed after the 1st',
        subtitle: 'Payables timing',
        impact: '+\$1,200',
        tone: ImpactTone.positive,
      ),
      DrivingFactor(
        title: 'Quarterly sales-tax set-aside',
        subtitle: 'Reserve',
        impact: '-\$1,750',
        tone: ImpactTone.negative,
      ),
    ],
    suggestedActions: [
      SuggestedAction(
        priority: 'HIGH',
        body:
            'Collect the \$1,140 in overdue catering invoices before '
            'they slip further past net-30.',
      ),
    ],
    askAiTranscript: [
      AskAiMessage(
        fromAi: true,
        text:
            'Scoped to Cash Flow MTD — ask anything and the answer uses '
            "Nonna Rosa's February numbers.",
      ),
    ],
  ),
  MetricDetail(
    label: 'Runway',
    value: '7.5 mo',
    statusLabel: 'Below avg',
    tone: MetricTone.bad,
    trendLabel: '↓ 0.4 mo',
    chartValues: [0.9, 0.85, 0.8, 0.7, 0.6],
    chartCaption: 'Runway · last 5 months',
    vsLastMonthBody:
        'At the current burn you have about 7.5 months of cushion — '
        'workable, but the walk-in repair took a bite, so keep an eye '
        'on it.',
    vsLastMonthDeltaLabel: 'Down 0.4 mo (7.9 → 7.5)',
    vsPeersBody:
        '7.5 months is below the 10-month median for single-location '
        'pizzerias — bottom third on cash cushion.',
    vsPeersDeltaLabel: '7.5 mo vs 10 mo peer median · below typical range',
    drivingFactors: [
      DrivingFactor(
        title: 'Walk-in compressor replacement',
        subtitle: 'Capex',
        impact: '-0.3 mo',
        tone: ImpactTone.negative,
      ),
      DrivingFactor(
        title: 'Winter gas bills up \$310/mo',
        subtitle: 'Utilities',
        impact: '-0.1 mo',
        tone: ImpactTone.negative,
      ),
      DrivingFactor(
        title: 'Positive cash flow offset some',
        subtitle: 'Operations',
        impact: '+0.1 mo',
        tone: ImpactTone.positive,
      ),
    ],
    suggestedActions: [
      SuggestedAction(
        priority: 'HIGH',
        body:
            'Ring-fence the \$780/month cheese saving straight into the '
            'cash buffer to rebuild runway before summer.',
      ),
    ],
    askAiTranscript: [
      AskAiMessage(
        fromAi: true,
        text:
            'Scoped to Runway — ask anything and the answer uses '
            "Nonna Rosa's February numbers.",
      ),
    ],
  ),
  MetricDetail(
    label: 'Delivery-App Mix',
    value: '14%',
    statusLabel: 'Below avg',
    tone: MetricTone.bad,
    trendLabel: '↑ 4 pts since Oct',
    chartValues: [0.35, 0.45, 0.55, 0.65, 1.0],
    chartCaption: 'Delivery-App Mix · last 5 months',
    vsLastMonthBody:
        'Delivery apps now take 14% of orders at a ~24% average '
        'commission — meaning roughly \$7.40 of every \$31 app ticket '
        'goes to the platform, not the kitchen.',
    vsLastMonthDeltaLabel: 'Up 4 pts (10% → 14%)',
    vsPeersBody:
        '14% app mix is in line with the 12–16% typical range for '
        'delivery-adjacent slice shops.',
    vsPeersDeltaLabel: '14% vs 12–16% peer median · within typical range',
    drivingFactors: [
      DrivingFactor(
        title: 'App orders 14% of volume',
        subtitle: 'Channel mix',
        impact: '≈\$5,100/mo fees',
        tone: ImpactTone.negative,
      ),
      DrivingFactor(
        title: 'App ticket \$31 vs \$19 counter',
        subtitle: 'Ticket size',
        impact: 'partial offset',
        tone: ImpactTone.neutral,
      ),
      DrivingFactor(
        title: 'Commission mix shifting up',
        subtitle: 'Fee structure',
        impact: '-0.6 pts margin',
        tone: ImpactTone.negative,
      ),
    ],
    suggestedActions: [
      SuggestedAction(
        priority: 'MED',
        body:
            'Put a box-top QR on delivery orders nudging customers to '
            'order direct next time — keeps ~\$7 of a \$31 ticket.',
      ),
    ],
    askAiTranscript: [
      AskAiMessage(
        fromAi: true,
        text:
            'Scoped to Delivery-App Mix — ask anything and the answer '
            "uses Nonna Rosa's February numbers.",
      ),
    ],
  ),
  MetricDetail(
    label: 'Avg Ticket',
    value: '\$19',
    statusLabel: 'At avg',
    tone: MetricTone.neutral,
    trendLabel: 'counter · \$31 delivery',
    chartValues: [0.6, 0.62, 0.65, 0.68, 0.9],
    chartCaption: 'Avg Ticket · last 5 months',
    vsLastMonthBody:
        'The average counter ticket is \$19 (delivery runs \$31) — in '
        'line with the neighborhood, and your \$3.00 plain slice is '
        'under the \$3.50 norm on 5th Avenue.',
    vsLastMonthDeltaLabel: 'Up \$0.60 (\$18.4 → \$19.0)',
    vsPeersBody:
        '\$19 sits right on the \$18–20 typical range for '
        'counter-service slice shops your size.',
    vsPeersDeltaLabel: '\$19 vs \$18–20 peer median · within typical range',
    drivingFactors: [
      DrivingFactor(
        title: 'Plain slice \$3.00 vs \$3.50 street norm',
        subtitle: 'Pricing headroom',
        impact: '+50¢ open',
        tone: ImpactTone.positive,
      ),
      DrivingFactor(
        title: 'Whole-pie share of weekend orders',
        subtitle: 'Mix',
        impact: '+\$0.40',
        tone: ImpactTone.positive,
      ),
      DrivingFactor(
        title: 'School-lunch slices',
        subtitle: 'Weekday mix',
        impact: '-\$0.20',
        tone: ImpactTone.negative,
      ),
    ],
    suggestedActions: [
      SuggestedAction(
        priority: 'MED',
        body:
            'Keep the pre-order counter and QR live through the '
            'weekend to hold the mix shift.',
      ),
    ],
    askAiTranscript: [
      AskAiMessage(
        fromAi: true,
        text:
            'Scoped to Avg Ticket — ask anything and the answer uses '
            "Nonna Rosa's February numbers.",
      ),
    ],
  ),
];
