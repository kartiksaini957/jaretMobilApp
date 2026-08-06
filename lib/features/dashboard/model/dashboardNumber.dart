class DashboardKpiResponse {
  final bool success;
  final DashboardKpiData data;

  DashboardKpiResponse({required this.success, required this.data});

  factory DashboardKpiResponse.fromJson(Map<String, dynamic> json) {
    return DashboardKpiResponse(
      success: json['success'] ?? false,
      data: DashboardKpiData.fromJson(json['data'] ?? {}),
    );
  }

  Map<String, dynamic> toJson() => {'success': success, 'data': data.toJson()};
}

class DashboardKpiData {
  final DashboardKpis kpis;

  DashboardKpiData({required this.kpis});

  factory DashboardKpiData.fromJson(Map<String, dynamic> json) {
    return DashboardKpiData(kpis: DashboardKpis.fromJson(json['kpis'] ?? {}));
  }

  Map<String, dynamic> toJson() => {'kpis': kpis.toJson()};
}

class DashboardKpis {
  final KpiValue revenueMtd;
  final KpiValue netMarginPct;
  final KpiValue cash;
  final KpiValue runwayMonths;
  final KpiValue aiHealthScore;

  DashboardKpis({
    required this.revenueMtd,
    required this.netMarginPct,
    required this.cash,
    required this.runwayMonths,
    required this.aiHealthScore,
  });

  factory DashboardKpis.fromJson(Map<String, dynamic> json) {
    return DashboardKpis(
      revenueMtd: KpiValue.fromJson(json['revenue_mtd'] ?? {}),
      netMarginPct: KpiValue.fromJson(json['net_margin_pct'] ?? {}),
      cash: KpiValue.fromJson(json['cash'] ?? {}),
      runwayMonths: KpiValue.fromJson(json['runway_months'] ?? {}),
      aiHealthScore: KpiValue.fromJson(json['ai_health_score'] ?? {}),
    );
  }

  Map<String, dynamic> toJson() => {
    'revenue_mtd': revenueMtd.toJson(),
    'net_margin_pct': netMarginPct.toJson(),
    'cash': cash.toJson(),
    'runway_months': runwayMonths.toJson(),
    'ai_health_score': aiHealthScore.toJson(),
  };
}

class KpiValue {
  final num value;
  final num priorValue;

  KpiValue({required this.value, required this.priorValue});

  factory KpiValue.fromJson(Map<String, dynamic> json) {
    return KpiValue(
      value: json['value'] ?? 0,
      priorValue: json['prior_value'] ?? 0,
    );
  }

  Map<String, dynamic> toJson() => {'value': value, 'prior_value': priorValue};
}
