class BusinessHealthResponse {
  final bool success;
  final BusinessHealthData data;

  BusinessHealthResponse({required this.success, required this.data});

  factory BusinessHealthResponse.fromJson(Map<String, dynamic> json) {
    return BusinessHealthResponse(
      success: json['success'] ?? false,
      data: BusinessHealthData.fromJson(json['data'] ?? {}),
    );
  }

  Map<String, dynamic> toJson() {
    return {'success': success, 'data': data.toJson()};
  }
}

class BusinessHealthData {
  final String summary;
  final List<AlertModel> alerts;
  final List<InsightPair> insightPairs;
  final List<String> opportunities;
  final List<String> whatChanged;

  BusinessHealthData({
    required this.summary,
    required this.alerts,
    required this.insightPairs,
    required this.opportunities,
    required this.whatChanged,
  });

  factory BusinessHealthData.fromJson(Map<String, dynamic> json) {
    return BusinessHealthData(
      summary: json['summary'] ?? '',
      alerts: (json['alerts'] as List? ?? [])
          .map((e) => AlertModel.fromJson(e))
          .toList(),
      insightPairs: (json['insight_pairs'] as List? ?? [])
          .map((e) => InsightPair.fromJson(e))
          .toList(),
      opportunities: List<String>.from(json['opportunities'] ?? const []),
      whatChanged: List<String>.from(json['what_changed'] ?? const []),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'summary': summary,
      'alerts': alerts.map((e) => e.toJson()).toList(),
      'insight_pairs': insightPairs.map((e) => e.toJson()).toList(),
      'opportunities': opportunities,
      'what_changed': whatChanged,
    };
  }
}

class AlertModel {
  final String severity;
  final String message;
  final String icon;
  final String type;

  AlertModel({
    required this.severity,
    required this.message,
    required this.icon,
    required this.type,
  });

  factory AlertModel.fromJson(Map<String, dynamic> json) {
    return AlertModel(
      severity: json['severity'] ?? '',
      message: json['message'] ?? '',
      icon: json['icon'] ?? '',
      type: json['type'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'severity': severity,
      'message': message,
      'icon': icon,
      'type': type,
    };
  }
}

class InsightPair {
  final String problem;
  final String solution;

  InsightPair({required this.problem, required this.solution});

  factory InsightPair.fromJson(Map<String, dynamic> json) {
    return InsightPair(
      problem: json['problem'] ?? '',
      solution: json['solution'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {'problem': problem, 'solution': solution};
  }
}
