class dashboardNumberDetail {
  final bool success;
  final RevenueInsightData data;

  dashboardNumberDetail({required this.success, required this.data});

  factory dashboardNumberDetail.fromJson(Map<String, dynamic> json) {
    return dashboardNumberDetail(
      success: json['success'] ?? false,
      data: RevenueInsightData.fromJson(json['data'] ?? {}),
    );
  }

  Map<String, dynamic> toJson() => {'success': success, 'data': data.toJson()};
}

class RevenueInsightData {
  final String verdict;
  final String status;
  final Comparison comparison;
  final List<Driver> drivers;
  final List<ActionItem> actions;
  final DataConfidence dataConfidence;

  RevenueInsightData({
    required this.verdict,
    required this.status,
    required this.comparison,
    required this.drivers,
    required this.actions,
    required this.dataConfidence,
  });

  factory RevenueInsightData.fromJson(Map<String, dynamic> json) {
    return RevenueInsightData(
      verdict: json['verdict'] ?? '',
      status: json['status'] ?? '',
      comparison: Comparison.fromJson(json['comparison'] ?? {}),
      drivers: (json['drivers'] as List? ?? [])
          .map((e) => Driver.fromJson(e))
          .toList(),
      actions: (json['actions'] as List? ?? [])
          .map((e) => ActionItem.fromJson(e))
          .toList(),
      dataConfidence: DataConfidence.fromJson(json['data_confidence'] ?? {}),
    );
  }

  Map<String, dynamic> toJson() => {
    'verdict': verdict,
    'status': status,
    'comparison': comparison.toJson(),
    'drivers': drivers.map((e) => e.toJson()).toList(),
    'actions': actions.map((e) => e.toJson()).toList(),
    'data_confidence': dataConfidence.toJson(),
  };
}

class Comparison {
  final LastPeriodComparison vsLastPeriod;
  final PeerComparison vsPeers;
  final TargetComparison vsTarget;

  Comparison({
    required this.vsLastPeriod,
    required this.vsPeers,
    required this.vsTarget,
  });

  factory Comparison.fromJson(Map<String, dynamic> json) {
    return Comparison(
      vsLastPeriod: LastPeriodComparison.fromJson(json['vs_last_period'] ?? {}),
      vsPeers: PeerComparison.fromJson(json['vs_peers'] ?? {}),
      vsTarget: TargetComparison.fromJson(json['vs_target'] ?? {}),
    );
  }

  Map<String, dynamic> toJson() => {
    'vs_last_period': vsLastPeriod.toJson(),
    'vs_peers': vsPeers.toJson(),
    'vs_target': vsTarget.toJson(),
  };
}

class LastPeriodComparison {
  final String changeText;
  final String direction;

  LastPeriodComparison({required this.changeText, required this.direction});

  factory LastPeriodComparison.fromJson(Map<String, dynamic> json) {
    return LastPeriodComparison(
      changeText: json['change_text'] ?? '',
      direction: json['direction'] ?? '',
    );
  }

  Map<String, dynamic> toJson() => {
    'change_text': changeText,
    'direction': direction,
  };
}

class PeerComparison {
  final dynamic benchmarkValue;
  final dynamic benchmarkSource;
  final dynamic position;
  final dynamic gapText;

  PeerComparison({
    this.benchmarkValue,
    this.benchmarkSource,
    this.position,
    this.gapText,
  });

  factory PeerComparison.fromJson(Map<String, dynamic> json) {
    return PeerComparison(
      benchmarkValue: json['benchmark_value'],
      benchmarkSource: json['benchmark_source'],
      position: json['position'],
      gapText: json['gap_text'],
    );
  }

  Map<String, dynamic> toJson() => {
    'benchmark_value': benchmarkValue,
    'benchmark_source': benchmarkSource,
    'position': position,
    'gap_text': gapText,
  };
}

class TargetComparison {
  final dynamic targetValue;
  final dynamic gapText;
  final dynamic onTrack;

  TargetComparison({this.targetValue, this.gapText, this.onTrack});

  factory TargetComparison.fromJson(Map<String, dynamic> json) {
    return TargetComparison(
      targetValue: json['target_value'],
      gapText: json['gap_text'],
      onTrack: json['on_track'],
    );
  }

  Map<String, dynamic> toJson() => {
    'target_value': targetValue,
    'gap_text': gapText,
    'on_track': onTrack,
  };
}

class Driver {
  final String description;
  final String impact;
  final String category;

  Driver({
    required this.description,
    required this.impact,
    required this.category,
  });

  factory Driver.fromJson(Map<String, dynamic> json) {
    return Driver(
      description: json['description'] ?? '',
      impact: json['impact'] ?? '',
      category: json['category'] ?? '',
    );
  }

  Map<String, dynamic> toJson() => {
    'description': description,
    'impact': impact,
    'category': category,
  };
}

class ActionItem {
  final String description;
  final String priority;
  final String effort;

  ActionItem({
    required this.description,
    required this.priority,
    required this.effort,
  });

  factory ActionItem.fromJson(Map<String, dynamic> json) {
    return ActionItem(
      description: json['description'] ?? '',
      priority: json['priority'] ?? '',
      effort: json['effort'] ?? '',
    );
  }

  Map<String, dynamic> toJson() => {
    'description': description,
    'priority': priority,
    'effort': effort,
  };
}

class DataConfidence {
  final int score;
  final String label;
  final List<String> factors;

  DataConfidence({
    required this.score,
    required this.label,
    required this.factors,
  });

  factory DataConfidence.fromJson(Map<String, dynamic> json) {
    return DataConfidence(
      score: json['score'] ?? 0,
      label: json['label'] ?? '',
      factors: List<String>.from(json['factors'] ?? []),
    );
  }

  Map<String, dynamic> toJson() => {
    'score': score,
    'label': label,
    'factors': factors,
  };
}
