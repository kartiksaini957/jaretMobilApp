class DemandForecastResponse {
  const DemandForecastResponse({
    required this.metrics,
    required this.flags,
    required this.historicalRevenue,
    required this.agentOutput,
  });

  factory DemandForecastResponse.fromJson(Map<String, dynamic> json) {
    final metricsJson = json['metrics'] as Map<String, dynamic>? ?? {};
    final dataJson = json['data'] as Map<String, dynamic>? ?? {};
    final historyList = dataJson['historical_revenue'] as List? ?? [];

    return DemandForecastResponse(
      metrics: DemandForecastMetrics.fromJson(metricsJson),
      flags: (json['flags'] as List? ?? [])
          .map((e) => DemandForecastFlag.fromJson(e as Map<String, dynamic>))
          .toList(),
      historicalRevenue: historyList
          .map((e) => HistoricalRevenuePoint.fromJson(e as Map<String, dynamic>))
          .toList(),
      agentOutput: AgentOutput.fromJson(
        json['agentOutput'] as Map<String, dynamic>? ?? {},
      ),
    );
  }

  final DemandForecastMetrics metrics;
  final List<DemandForecastFlag> flags;
  final List<HistoricalRevenuePoint> historicalRevenue;
  final AgentOutput agentOutput;
}

class DemandForecastMetrics {
  const DemandForecastMetrics({required this.forecastSeries});

  factory DemandForecastMetrics.fromJson(Map<String, dynamic> json) {
    return DemandForecastMetrics(
      forecastSeries: (json['forecast_series'] as List? ?? [])
          .map((e) => (e as num).toDouble())
          .toList(),
    );
  }

  final List<double> forecastSeries;
}

class DemandForecastFlag {
  const DemandForecastFlag({required this.severity, required this.title});

  factory DemandForecastFlag.fromJson(Map<String, dynamic> json) {
    return DemandForecastFlag(
      severity: json['severity'] as String? ?? '',
      title: json['title'] as String? ?? '',
    );
  }

  final String severity;
  final String title;
}

class HistoricalRevenuePoint {
  const HistoricalRevenuePoint({required this.date, required this.amount});

  factory HistoricalRevenuePoint.fromJson(Map<String, dynamic> json) {
    return HistoricalRevenuePoint(
      date: json['date'] as String? ?? '',
      amount: (json['amount'] as num?)?.toDouble() ?? 0,
    );
  }

  final String date;
  final double amount;
}

class AgentOutput {
  const AgentOutput({
    required this.tabLabel,
    required this.demandUnit,
    required this.windows,
  });

  factory AgentOutput.fromJson(Map<String, dynamic> json) {
    return AgentOutput(
      tabLabel: json['tab_label'] as String? ?? '',
      demandUnit: json['demand_unit'] as String? ?? '',
      windows: (json['windows'] as List? ?? [])
          .map((e) => ForecastWindow.fromJson(e as Map<String, dynamic>))
          .toList(),
    );
  }

  final String tabLabel;
  final String demandUnit;
  final List<ForecastWindow> windows;
}

class ForecastWindow {
  const ForecastWindow({
    required this.window,
    required this.severity,
    required this.hero,
    required this.swingFactor,
    required this.sectionSummaries,
    required this.actions,
    required this.drivers,
    required this.breakdown,
    required this.trackRecord,
    required this.worldScan,
  });

factory ForecastWindow.fromJson(Map<String, dynamic> json) {
    return ForecastWindow(
      window: json['window'] as String? ?? '',
      severity: json['severity'] as String? ?? 'steady',
      hero: WindowHero.fromJson(json['hero'] as Map<String, dynamic>? ?? {}),
      swingFactor: SwingFactor.fromJson(
        json['swing_factor'] as Map<String, dynamic>? ?? {},
      ),
      sectionSummaries: SectionSummaries.fromJson(
        json['section_summaries'] as Map<String, dynamic>? ?? {},
      ),
      actions: (json['actions'] as List? ?? [])
          .map((e) => ForecastAction.fromJson(e as Map<String, dynamic>))
          .toList(),

      // 🔧 FIX: "Next 30 Days" me list ka naam 'drivers' hai,
      //         "This Weekend" me list ka naam 'whats_moving' hai.
      // Pehle 'drivers' try karo, na mile to 'whats_moving' use karo.
      drivers: ((json['drivers'] as List?) ??
              (json['whats_moving'] as List?) ??
              [])
          .map((e) => ForecastDriver.fromJson(e as Map<String, dynamic>))
          .toList(),

      breakdown: ForecastBreakdown.fromJson(
        json['breakdown'] as Map<String, dynamic>? ?? {},
      ),
      trackRecord: TrackRecordInfo.fromJson(
        json['track_record'] as Map<String, dynamic>? ?? {},
      ),
      worldScan: (json['world_scan'] as List? ?? [])
          .map((e) => WorldScanFlag.fromJson(e as Map<String, dynamic>))
          .toList(),
    );
  }
  final String window;
  final String severity;
  final WindowHero hero;
  final SwingFactor swingFactor;
  final SectionSummaries sectionSummaries;
  final List<ForecastAction> actions;
  final List<ForecastDriver> drivers;
  final ForecastBreakdown breakdown;
  final TrackRecordInfo trackRecord;
  final List<WorldScanFlag> worldScan;
}

class WindowHero {
  const WindowHero({
    required this.eyebrow,
    required this.headline,
    required this.expectedValue,
    required this.expectedUnit,
    required this.confidencePct,
    required this.confidenceLabel,
    required this.anchor,
        this.volumeForecast,   // 🔧 NEW: covers/units count, e.g. 185
    this.volumeUnit,     
  });

  factory WindowHero.fromJson(Map<String, dynamic> json) {
    return WindowHero(
      eyebrow: json['eyebrow'] as String? ?? '',
      headline: json['headline'] as String? ?? '',
      expectedValue: json['expected_value'] as String? ?? '',
      expectedUnit: json['expected_unit'] as String? ?? '',
      confidencePct: (json['confidence_pct'] as num?)?.toInt() ?? 0,
      confidenceLabel: json['confidence_label'] as String? ?? '',
      anchor: json['anchor'] as String? ?? '',
          volumeForecast: (json['volume_forecast'] as num?)?.toInt(),
      volumeUnit: json['demand_unit'] as String?,
    );
  }

  final String eyebrow;
  final String headline;
  final String expectedValue;
  final String expectedUnit;
  final int confidencePct;
  final String confidenceLabel;
  final String anchor;
    final int? volumeForecast; // 🔧 NEW
  final String? volumeUnit;
}

class SwingFactor {
  const SwingFactor({
    required this.headline,
    required this.deltaText,
    required this.direction,
    required this.reasoning,
  });

  factory SwingFactor.fromJson(Map<String, dynamic> json) {
    return SwingFactor(
      headline: json['headline'] as String? ?? '',
      deltaText: json['delta_text'] as String? ?? '',
      direction: json['direction'] as String? ?? 'down',
      reasoning: json['reasoning'] as String? ?? '',
    );
  }

  final String headline;
  final String deltaText;
  final String direction;
  final String reasoning;
}

class SectionSummary {
  const SectionSummary({required this.summary, required this.severity});

  factory SectionSummary.fromJson(Map<String, dynamic> json) {
    return SectionSummary(
      summary: json['summary'] as String? ?? '',
      severity: json['severity'] as String? ?? '',
    );
  }

  final String summary;
  final String severity;
}

class SectionSummaries {
  const SectionSummaries({
    required this.doThis,
    required this.whatsMoving,
    required this.breakdown,
    required this.trackRecord,
    required this.worldScan,
  });

  factory SectionSummaries.fromJson(Map<String, dynamic> json) {
    SectionSummary pick(String key) => SectionSummary.fromJson(
          json[key] as Map<String, dynamic>? ?? {},
        );
    return SectionSummaries(
      doThis: pick('do_this'),
      whatsMoving: pick('whats_moving'),
      breakdown: pick('breakdown'),
      trackRecord: pick('track_record'),
      worldScan: pick('world_scan'),
    );
  }

  final SectionSummary doThis;
  final SectionSummary whatsMoving;
  final SectionSummary breakdown;
  final SectionSummary trackRecord;
  final SectionSummary worldScan;
}

class ForecastAction {
  const ForecastAction({
    required this.id,
    required this.title,
    required this.deadline,
    required this.priority,
    required this.tiedToDriver,
    required this.whyThisMuch,
    required this.dollarLogic,
  });

factory ForecastAction.fromJson(Map<String, dynamic> json) {
    return ForecastAction(
      id: json['id'] as String? ?? '',

      // 🔧 FIX: "Next 30 Days" me key hai 'title', 
      //         "This Weekend" me key hai 'action' — dono ko try karo.
      // Pehle 'title' dhoondo, agar null mila to 'action' use karo.
      title: (json['title'] ?? json['action']) as String? ?? '',

      deadline: json['deadline'] as String? ?? '',
      priority: json['priority'] as String? ?? 'medium',
      tiedToDriver: json['tied_to_driver'] as String? ?? '',
      whyThisMuch: json['why_this_much'] as String? ?? '',
      dollarLogic: json['dollar_logic'] as String? ?? '',
    );
  }

  final String id;
  final String title;
  final String deadline;
  final String priority;
  final String tiedToDriver;
  final String whyThisMuch;
  final String dollarLogic;
}

class ForecastDriver {
  const ForecastDriver({
    required this.name,
    required this.severity,
    required this.window,
    required this.impactText,
    required this.reasoning,
    required this.source,
    required this.confidence,
  });

 factory ForecastDriver.fromJson(Map<String, dynamic> json) {
    // 🔧 FIX: 'confidence' field kabhi String ("high") hota hai,
    //         kabhi number (88) hota hai — ye crash ki wajah tha
    //         kyunki purana code seedha `as String?` laga raha tha.
    final rawConfidence = json['confidence'];

    String confidenceStr;
    if (rawConfidence is String) {
      // "This Weekend" case — already string hai, seedha use karo
      confidenceStr = rawConfidence;
    } else if (json['confidence_label'] is String) {
      // "Next 30 Days" case — number hai, to uske sath aane wala
      // 'confidence_label' (jaise "High") use karo
      confidenceStr = (json['confidence_label'] as String).toLowerCase();
    } else {
      // kuch bhi na mile to safe default
      confidenceStr = 'medium';
    }

    return ForecastDriver(
      name: json['name'] as String? ?? '',
      severity: json['severity'] as String? ?? 'steady',
      window: json['window'] as String? ?? '',
      impactText: json['impact_text'] as String? ?? '',
      reasoning: json['reasoning'] as String? ?? '',
      source: json['source'] as String? ?? '',
      confidence: confidenceStr, // ✅ ab hamesha safe String hai
    );
  }

  final String name;
  final String severity;
  final String window;
  final String impactText;
  final String reasoning;
  final String source;
  final String confidence;
}

class ForecastBreakdown {
  const ForecastBreakdown({
    required this.committed,
    required this.expectedLosses,
    required this.unbookedDemand,
    required this.externalAdjustment,
  });

  factory ForecastBreakdown.fromJson(Map<String, dynamic> json) {
    double num_(String key) => (json[key] as num?)?.toDouble() ?? 0;
    return ForecastBreakdown(
      committed: num_('committed'),
      expectedLosses: num_('expected_losses'),
      unbookedDemand: num_('unbooked_demand'),
      externalAdjustment: num_('external_adjustment'),
    );
  }

  final double committed;
  final double expectedLosses;
  final double unbookedDemand;
  final double externalAdjustment;
}

class TrackRecordInfo {
  const TrackRecordInfo({
    required this.accuracyReceipt,
    required this.leanGuidance,
  });

  factory TrackRecordInfo.fromJson(Map<String, dynamic> json) {
    return TrackRecordInfo(
      accuracyReceipt: json['accuracy_receipt'] as String? ?? '',
      leanGuidance: json['lean_guidance'] as String? ?? '',
    );
  }

  final String accuracyReceipt;
  final String leanGuidance;
}

class WorldScanFlag {
  const WorldScanFlag({
    required this.flag,
    required this.horizon,
    required this.dependsOn,
    required this.actionYet,
    required this.source,
  });

  factory WorldScanFlag.fromJson(Map<String, dynamic> json) {
    return WorldScanFlag(
      flag: json['flag'] as String? ?? '',
      horizon: json['horizon'] as String? ?? '',
      dependsOn: json['depends_on'] as String? ?? '',
      actionYet: json['action_yet'] as String? ?? '',
      source: json['source'] as String? ?? '',
    );
  }

  final String flag;
  final String horizon;
  final String dependsOn;
  final String actionYet;
  final String source;
}