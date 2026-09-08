class ScenarioResponse {
  final bool success;
  final ScenarioData? data;
  final String? createdAt;
  final String? threadId;
  final String? message;

  ScenarioResponse({
    required this.success,
    this.data,
    this.createdAt,
    this.threadId,
    this.message,
  });

  factory ScenarioResponse.fromJson(Map<String, dynamic> json) {
    return ScenarioResponse(
      success: json['success'] as bool? ?? false,
      data: json['data'] != null && json['data'] is Map<String, dynamic>
          ? ScenarioData.fromJson(json['data'] as Map<String, dynamic>)
          : null,
      createdAt: json['created_at'] as String?,
      threadId: json['thread_id'] as String?,
      message: json['message'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'success': success,
      if (data != null) 'data': data!.toJson(),
      if (createdAt != null) 'created_at': createdAt,
      if (threadId != null) 'thread_id': threadId,
      if (message != null) 'message': message,
    };
  }
}

class ScenarioData {
  final String? type;
  final ScenarioVerdict? verdict;
  final List<ScenarioKeyNumber> keyNumbers;
  final List<ScenarioAssumption> assumptionsTable;
  final List<ScenarioStep> steps;
  final List<ScenarioPro> pros;
  final List<ScenarioCon> cons;
  final List<String> thingsToKeepInMind;
  final String? peerContext;
  final List<ScenarioAlternative> alternatives;
  final ScenarioChartData? chartData;
  final String? closingLine;

  ScenarioData({
    this.type,
    this.verdict,
    this.keyNumbers = const [],
    this.assumptionsTable = const [],
    this.steps = const [],
    this.pros = const [],
    this.cons = const [],
    this.thingsToKeepInMind = const [],
    this.peerContext,
    this.alternatives = const [],
    this.chartData,
    this.closingLine,
  });

  factory ScenarioData.fromJson(Map<String, dynamic> json) {
    return ScenarioData(
      type: json['type'] as String?,
      verdict: json['verdict'] != null && json['verdict'] is Map<String, dynamic>
          ? ScenarioVerdict.fromJson(json['verdict'] as Map<String, dynamic>)
          : null,
      keyNumbers: (json['key_numbers'] as List<dynamic>? ?? [])
          .whereType<Map<String, dynamic>>()
          .map((e) => ScenarioKeyNumber.fromJson(e))
          .toList(),
      assumptionsTable: (json['assumptions_table'] as List<dynamic>? ?? [])
          .whereType<Map<String, dynamic>>()
          .map((e) => ScenarioAssumption.fromJson(e))
          .toList(),
      steps: (json['steps'] as List<dynamic>? ?? [])
          .whereType<Map<String, dynamic>>()
          .map((e) => ScenarioStep.fromJson(e))
          .toList(),
      pros: (json['pros'] as List<dynamic>? ?? [])
          .whereType<Map<String, dynamic>>()
          .map((e) => ScenarioPro.fromJson(e))
          .toList(),
      cons: (json['cons'] as List<dynamic>? ?? [])
          .whereType<Map<String, dynamic>>()
          .map((e) => ScenarioCon.fromJson(e))
          .toList(),
      thingsToKeepInMind: (json['things_to_keep_in_mind'] as List<dynamic>? ?? [])
          .map((e) => e.toString())
          .toList(),
      peerContext: json['peer_context'] as String?,
      alternatives: (json['alternatives'] as List<dynamic>? ?? [])
          .whereType<Map<String, dynamic>>()
          .map((e) => ScenarioAlternative.fromJson(e))
          .toList(),
      chartData: json['chart_data'] != null && json['chart_data'] is Map<String, dynamic>
          ? ScenarioChartData.fromJson(json['chart_data'] as Map<String, dynamic>)
          : null,
      closingLine: json['closing_line'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      if (type != null) 'type': type,
      if (verdict != null) 'verdict': verdict!.toJson(),
      'key_numbers': keyNumbers.map((e) => e.toJson()).toList(),
      'assumptions_table': assumptionsTable.map((e) => e.toJson()).toList(),
      'steps': steps.map((e) => e.toJson()).toList(),
      'pros': pros.map((e) => e.toJson()).toList(),
      'cons': cons.map((e) => e.toJson()).toList(),
      'things_to_keep_in_mind': thingsToKeepInMind,
      if (peerContext != null) 'peer_context': peerContext,
      'alternatives': alternatives.map((e) => e.toJson()).toList(),
      if (chartData != null) 'chart_data': chartData!.toJson(),
      if (closingLine != null) 'closing_line': closingLine,
    };
  }
}

class ScenarioVerdict {
  final String? category;
  final String? label;
  final String? summary;
  final String? confidence;
  final String? risk;
  final String? reserveWarning;
  final String? confidenceReason;
  final String? riskReason;

  ScenarioVerdict({
    this.category,
    this.label,
    this.summary,
    this.confidence,
    this.risk,
    this.reserveWarning,
    this.confidenceReason,
    this.riskReason,
  });

  factory ScenarioVerdict.fromJson(Map<String, dynamic> json) {
    return ScenarioVerdict(
      category: json['category'] as String?,
      label: json['label'] as String?,
      summary: json['summary'] as String?,
      confidence: json['confidence'] as String?,
      risk: json['risk'] as String?,
      reserveWarning: json['reserve_warning'] as String?,
      confidenceReason: json['confidence_reason'] as String?,
      riskReason: json['risk_reason'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      if (category != null) 'category': category,
      if (label != null) 'label': label,
      if (summary != null) 'summary': summary,
      if (confidence != null) 'confidence': confidence,
      if (risk != null) 'risk': risk,
      if (reserveWarning != null) 'reserve_warning': reserveWarning,
      if (confidenceReason != null) 'confidence_reason': confidenceReason,
      if (riskReason != null) 'risk_reason': riskReason,
    };
  }
}

class ScenarioKeyNumber {
  final String label;
  final String value;
  final String? colorFlag;
  final String? severity;
  final String? source;

  ScenarioKeyNumber({
    required this.label,
    required this.value,
    this.colorFlag,
    this.severity,
    this.source,
  });

  factory ScenarioKeyNumber.fromJson(Map<String, dynamic> json) {
    return ScenarioKeyNumber(
      label: json['label'] as String? ?? '',
      value: json['value'] as String? ?? '',
      colorFlag: json['color_flag'] as String?,
      severity: json['severity'] as String?,
      source: json['source'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'label': label,
      'value': value,
      if (colorFlag != null) 'color_flag': colorFlag,
      if (severity != null) 'severity': severity,
      if (source != null) 'source': source,
    };
  }
}

class ScenarioAssumption {
  final String item;
  final String value;
  final String? source;
  final String? note;
  final String? what;

  ScenarioAssumption({
    required this.item,
    required this.value,
    this.source,
    this.note,
    this.what,
  });

  factory ScenarioAssumption.fromJson(Map<String, dynamic> json) {
    return ScenarioAssumption(
      item: json['item'] as String? ?? '',
      value: json['value'] as String? ?? '',
      source: json['source'] as String?,
      note: json['note'] as String?,
      what: json['what'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'item': item,
      'value': value,
      if (source != null) 'source': source,
      if (note != null) 'note': note,
      if (what != null) 'what': what,
    };
  }
}

class ScenarioStep {
  final String title;
  final String? what;
  final String? how;
  final String? why;
  final String? decisionGate;
  final String? customerExperienceElement;

  ScenarioStep({
    required this.title,
    this.what,
    this.how,
    this.why,
    this.decisionGate,
    this.customerExperienceElement,
  });

  factory ScenarioStep.fromJson(Map<String, dynamic> json) {
    return ScenarioStep(
      title: json['title'] as String? ?? '',
      what: json['what'] as String?,
      how: json['how'] as String?,
      why: json['why'] as String?,
      decisionGate: json['decision_gate'] as String?,
      customerExperienceElement: json['customer_experience_element'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'title': title,
      if (what != null) 'what': what,
      if (how != null) 'how': how,
      if (why != null) 'why': why,
      if (decisionGate != null) 'decision_gate': decisionGate,
      if (customerExperienceElement != null)
        'customer_experience_element': customerExperienceElement,
    };
  }
}

class ScenarioPro {
  final String pro;
  final String? detail;
  final String? timeDimension;
  final String? meaning;
  final String? actionToCapture;
  final double? dollarImpact;
  final String? impactText;
  final String? plainLanguage;

  ScenarioPro({
    required this.pro,
    this.detail,
    this.timeDimension,
    this.meaning,
    this.actionToCapture,
    this.dollarImpact,
    this.impactText,
    this.plainLanguage,
  });

  factory ScenarioPro.fromJson(Map<String, dynamic> json) {
    return ScenarioPro(
      pro: json['pro'] as String? ?? '',
      detail: json['detail'] as String?,
      timeDimension: json['time_dimension'] as String?,
      meaning: json['meaning'] as String?,
      actionToCapture: json['action_to_capture'] as String?,
      dollarImpact: (json['dollar_impact'] as num?)?.toDouble(),
      impactText: json['impact_text'] as String?,
      plainLanguage: json['plain_language'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'pro': pro,
      if (detail != null) 'detail': detail,
      if (timeDimension != null) 'time_dimension': timeDimension,
      if (meaning != null) 'meaning': meaning,
      if (actionToCapture != null) 'action_to_capture': actionToCapture,
      if (dollarImpact != null) 'dollar_impact': dollarImpact,
      if (impactText != null) 'impact_text': impactText,
      if (plainLanguage != null) 'plain_language': plainLanguage,
    };
  }
}

class ScenarioCon {
  final String con;
  final String? detail;
  final String? timeDimension;
  final String? consequence;
  final String? mitigation;
  final double? dollarImpact;
  final String? impactText;
  final String? plainLanguage;

  ScenarioCon({
    required this.con,
    this.detail,
    this.timeDimension,
    this.consequence,
    this.mitigation,
    this.dollarImpact,
    this.impactText,
    this.plainLanguage,
  });

  factory ScenarioCon.fromJson(Map<String, dynamic> json) {
    return ScenarioCon(
      con: json['con'] as String? ?? '',
      detail: json['detail'] as String?,
      timeDimension: json['time_dimension'] as String?,
      consequence: json['consequence'] as String?,
      mitigation: json['mitigation'] as String?,
      dollarImpact: (json['dollar_impact'] as num?)?.toDouble(),
      impactText: json['impact_text'] as String?,
      plainLanguage: json['plain_language'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'con': con,
      if (detail != null) 'detail': detail,
      if (timeDimension != null) 'time_dimension': timeDimension,
      if (consequence != null) 'consequence': consequence,
      if (mitigation != null) 'mitigation': mitigation,
      if (dollarImpact != null) 'dollar_impact': dollarImpact,
      if (impactText != null) 'impact_text': impactText,
      if (plainLanguage != null) 'plain_language': plainLanguage,
    };
  }
}

class ScenarioAlternative {
  final String? description;
  final String? costImpact;
  final String? riskComparison;
  final String? bestFor;

  ScenarioAlternative({
    this.description,
    this.costImpact,
    this.riskComparison,
    this.bestFor,
  });

  factory ScenarioAlternative.fromJson(Map<String, dynamic> json) {
    return ScenarioAlternative(
      description: json['description'] as String?,
      costImpact: json['cost_impact'] as String?,
      riskComparison: json['risk_comparison'] as String?,
      bestFor: json['best_for'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      if (description != null) 'description': description,
      if (costImpact != null) 'cost_impact': costImpact,
      if (riskComparison != null) 'risk_comparison': riskComparison,
      if (bestFor != null) 'best_for': bestFor,
    };
  }
}

class ScenarioChartData {
  final String? chartType;
  final String? xAxisLabel;
  final String? yAxisLabel;
  final List<String> labels;
  final List<ScenarioChartSeries> series;
  final List<ScenarioChartMarker> markers;
  final ScenarioChartSeries? worstCaseSeries;

  ScenarioChartData({
    this.chartType,
    this.xAxisLabel,
    this.yAxisLabel,
    this.labels = const [],
    this.series = const [],
    this.markers = const [],
    this.worstCaseSeries,
  });

  factory ScenarioChartData.fromJson(Map<String, dynamic> json) {
    return ScenarioChartData(
      chartType: json['chart_type'] as String?,
      xAxisLabel: json['x_axis_label'] as String?,
      yAxisLabel: json['y_axis_label'] as String?,
      labels: (json['labels'] as List<dynamic>? ?? [])
          .map((e) => e.toString())
          .toList(),
      series: (json['series'] as List<dynamic>? ?? [])
          .whereType<Map<String, dynamic>>()
          .map((e) => ScenarioChartSeries.fromJson(e))
          .toList(),
      markers: (json['markers'] as List<dynamic>? ?? [])
          .whereType<Map<String, dynamic>>()
          .map((e) => ScenarioChartMarker.fromJson(e))
          .toList(),
      worstCaseSeries: json['worst_case_series'] != null &&
              json['worst_case_series'] is Map<String, dynamic>
          ? ScenarioChartSeries.fromJson(
              json['worst_case_series'] as Map<String, dynamic>,
            )
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      if (chartType != null) 'chart_type': chartType,
      if (xAxisLabel != null) 'x_axis_label': xAxisLabel,
      if (yAxisLabel != null) 'y_axis_label': yAxisLabel,
      'labels': labels,
      'series': series.map((e) => e.toJson()).toList(),
      'markers': markers.map((e) => e.toJson()).toList(),
      if (worstCaseSeries != null)
        'worst_case_series': worstCaseSeries!.toJson(),
    };
  }
}

class ScenarioChartSeries {
  final String? name;
  final List<double> data;
  final String? color;

  ScenarioChartSeries({
    this.name,
    this.data = const [],
    this.color,
  });

  factory ScenarioChartSeries.fromJson(Map<String, dynamic> json) {
    return ScenarioChartSeries(
      name: json['name'] as String?,
      data: (json['data'] as List<dynamic>? ?? [])
          .map((e) => (e as num).toDouble())
          .toList(),
      color: json['color'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      if (name != null) 'name': name,
      'data': data,
      if (color != null) 'color': color,
    };
  }
}

class ScenarioChartMarker {
  final String? type;
  final String? label;
  final double? value;
  final int? monthIndex;

  ScenarioChartMarker({
    this.type,
    this.label,
    this.value,
    this.monthIndex,
  });

  factory ScenarioChartMarker.fromJson(Map<String, dynamic> json) {
    return ScenarioChartMarker(
      type: json['type'] as String?,
      label: json['label'] as String?,
      value: (json['value'] as num?)?.toDouble(),
      monthIndex: json['month_index'] as int?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      if (type != null) 'type': type,
      if (label != null) 'label': label,
      if (value != null) 'value': value,
      if (monthIndex != null) 'month_index': monthIndex,
    };
  }
}
