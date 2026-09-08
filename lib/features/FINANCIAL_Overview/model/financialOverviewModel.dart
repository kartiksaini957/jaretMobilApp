
class FinancialOverviewResponse {
  FinancialOverviewResponse({
    required this.insights,
    required this.kpiTiles,
    required this.expenseBreakdown,
    required this.kpis,
  });

  final FinancialInsights insights;
  final List<KpiTile> kpiTiles;
  final ExpenseBreakdown expenseBreakdown;
  final Kpis kpis;

  factory FinancialOverviewResponse.fromJson(Map<String, dynamic> json) {
    final data = json['data'] as Map<String, dynamic>? ?? {};

    final banner = ProfitabilityBanner.fromJson(
      data['profitability_banner'] as Map<String, dynamic>? ?? {},
    );

    final signals = data['financial_signals'] as Map<String, dynamic>? ?? {};

    final kpiTilesJson = (data['kpi_tiles'] as List<dynamic>? ?? []);
    final kpiTiles = kpiTilesJson
        .map((e) => KpiTile.fromJson(e as Map<String, dynamic>))
        .toList();

    return FinancialOverviewResponse(
      insights: FinancialInsights.fromJson(signals, banner),
      kpiTiles: kpiTiles,
      expenseBreakdown: ExpenseBreakdown.fromJson(
        data['expense_breakdown'] as Map<String, dynamic>? ?? {},
      ),
      kpis: Kpis.fromKpiTiles(kpiTiles),
    );
  }
}

// ---------------- Banner ----------------

class ProfitabilityBanner {
  ProfitabilityBanner({
    required this.status,
    required this.headline,
    required this.supportingText,
  });

  final String status;
  final String headline;
  final String supportingText;

  factory ProfitabilityBanner.fromJson(Map<String, dynamic> j) {
    return ProfitabilityBanner(
      status: j['status'] ?? '',
      headline: j['headline'] ?? '',
      supportingText: j['supporting_text'] ?? '',
    );
  }
}

// ---------------- Insights (financial_signals) ----------------

class FinancialInsights {
  FinancialInsights({
    required this.profitabilityBanner,
    required this.items,
  });

  final ProfitabilityBanner profitabilityBanner;
  final List<InsightItem> items;

  factory FinancialInsights.fromJson(
    Map<String, dynamic> signalsJson,
    ProfitabilityBanner banner,
  ) {
    final itemsJson = signalsJson['items'] as List<dynamic>? ?? [];
    return FinancialInsights(
      profitabilityBanner: banner,
      items: itemsJson
          .map((e) => InsightItem.fromJson(e as Map<String, dynamic>))
          .toList(),
    );
  }
}

class InsightItem {
  InsightItem({
    this.id = '',
    required this.pressingScore,
    required this.headline,
    required this.whatsGoingOn,
    required this.whyItMattersNow,
    required this.whatToDo,
    required this.expectedImpact,
    required this.effort,
    required this.confidence,
    this.status = '',
    this.isRead = false,
    this.isSnoozed = false,
    this.snoozeUntil = '',
    this.acknowledgedAt = '',
  });

  final String id;
  final int pressingScore;
  final String headline;
  final String whatsGoingOn;
  final String whyItMattersNow;
  final String whatToDo;
  final ExpectedImpact expectedImpact;
  final String effort;
  final String confidence;
  final String status;
  final bool isRead;
  final bool isSnoozed;
  final String snoozeUntil;
  final String acknowledgedAt;

  factory InsightItem.fromJson(Map<String, dynamic> j) {
    final statusStr = j['status']?.toString() ?? '';
    return InsightItem(
      id: j['id']?.toString() ?? j['insight_id']?.toString() ?? j['key']?.toString() ?? '',
      pressingScore: j['pressing_score'] ?? 0,
      headline: j['headline'] ?? '',
      whatsGoingOn: j['whats_going_on'] ?? '',
      whyItMattersNow: j['why_it_matters_now'] ?? '',
      whatToDo: j['what_to_do'] ?? '',
      expectedImpact: ExpectedImpact.fromJson(
        j['expected_impact'] as Map<String, dynamic>? ?? {},
      ),
      effort: j['effort'] ?? '',
      confidence: j['confidence'] ?? '',
      status: statusStr,
      isRead: j['is_read'] == true || statusStr == 'acknowledged',
      isSnoozed: j['is_snoozed'] == true || statusStr == 'snoozed',
      snoozeUntil: j['snooze_until']?.toString() ?? '',
      acknowledgedAt: j['acknowledged_at']?.toString() ?? '',
    );
  }
}

class ExpectedImpact {
  ExpectedImpact({required this.valueText, required this.calculationBasis});

  final String valueText;
  final String calculationBasis;

  factory ExpectedImpact.fromJson(Map<String, dynamic> j) {
    return ExpectedImpact(
      valueText: j['value_text'] ?? '',
      calculationBasis: j['calculation_basis'] ?? '',
    );
  }
}

// ---------------- KPI Tiles ----------------

class KpiTile {
  KpiTile({
    required this.metricId,
    required this.label,
    required this.value,
    required this.status,
    required this.changeIndicator,
    required this.trend,
    required this.verdict,
    required this.drivers,
  });

  final String metricId;
  final String label;
  final String value;
  final String status;
  final String changeIndicator;
  final List<double> trend;
  final String verdict;
  final List<Driver> drivers;

  factory KpiTile.fromJson(Map<String, dynamic> j) {
    return KpiTile(
      metricId: j['metric_id'] ?? '',
      label: j['label'] ?? '',
      value: j['value'] ?? '',
      status: j['status'] ?? '',
      changeIndicator: j['change_indicator'] ?? '',
      trend: (j['trend'] as List<dynamic>? ?? [])
          .map((e) => (e as num).toDouble())
          .toList(),
      verdict: j['verdict'] ?? '',
      drivers: (j['drivers'] as List<dynamic>? ?? [])
          .map((e) => Driver.fromJson(e as Map<String, dynamic>))
          .toList(),
    );
  }
}

class Driver {
  Driver({
    required this.headline,
    required this.category,
    required this.impactValue,
  });

  final String headline;
  final String category;
  final String impactValue;

  factory Driver.fromJson(Map<String, dynamic> j) {
    return Driver(
      headline: j['headline'] ?? '',
      category: j['category'] ?? '',
      impactValue: j['impact_value']?.toString() ?? '',
    );
  }
}

// ---------------- Expense Breakdown ----------------

class ExpenseBreakdown {
  ExpenseBreakdown({required this.totalAmount, required this.categories});

  final double totalAmount;
  final List<ExpenseCategoryData> categories;

  factory ExpenseBreakdown.fromJson(Map<String, dynamic> j) {
    return ExpenseBreakdown(
      totalAmount: (j['total_amount'] as num?)?.toDouble() ?? 0.0,
      categories: (j['categories'] as List<dynamic>? ?? [])
          .map((e) => ExpenseCategoryData.fromJson(e as Map<String, dynamic>))
          .toList(),
    );
  }
}

class ExpenseCategoryData {
  ExpenseCategoryData({
    required this.category,
    required this.amount,
    required this.percentage,
  });

  final String category;
  final double amount;
  final double percentage;

  factory ExpenseCategoryData.fromJson(Map<String, dynamic> j) {
    return ExpenseCategoryData(
      category: j['category'] ?? '',
      amount: (j['amount'] as num?)?.toDouble() ?? 0.0,
      percentage: (j['percentage'] as num?)?.toDouble() ?? 0.0,
    );
  }
}

// ---------------- Kpis (derived, revenueMtd fix) ----------------

class Kpis {
  Kpis({required this.revenueMtd});

  final double revenueMtd;

  factory Kpis.fromKpiTiles(List<KpiTile> tiles) {
    final revenueTile = tiles.where((t) => t.metricId == 'revenue_mtd');
    final rawValue = revenueTile.isNotEmpty ? revenueTile.first.value : '0';
    return Kpis(revenueMtd: _parseMoneyString(rawValue));
  }

  static double _parseMoneyString(String value) {
    final cleaned = value.replaceAll(RegExp(r'[^\d.-]'), '');
    return double.tryParse(cleaned) ?? 0.0;
  }
}