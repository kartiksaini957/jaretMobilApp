class BusinessHealthOverviewResponse {
  BusinessHealthOverviewResponse({required this.success, required this.data});

  final bool success;
  final BusinessHealthOverviewData data;

  factory BusinessHealthOverviewResponse.fromJson(Map<String, dynamic> json) {
    final data = json['data'] as Map<String, dynamic>? ?? {};
    return BusinessHealthOverviewResponse(
      success: json['success'] as bool? ?? false,
      data: BusinessHealthOverviewData.fromJson(data),
    );
  }
}

class BusinessHealthOverviewData {
  BusinessHealthOverviewData({
    required this.overall,
    required this.categories,
    required this.benchmarks,
    required this.aiSummary,
    required this.driversDisplay,
    required this.watchAreas,
    required this.activeAlerts,
    required this.dataCoverageNote,
  });

  final OverallHealth overall;
  final CategoryScores categories;
  final Benchmarks benchmarks;
  final String aiSummary;
  final DriversDisplay driversDisplay;
  final List<WatchArea> watchAreas;
  final List<ActiveAlert> activeAlerts;
  final String dataCoverageNote;

  factory BusinessHealthOverviewData.fromJson(Map<String, dynamic> j) {
    return BusinessHealthOverviewData(
      overall: OverallHealth.fromJson(
        j['overall'] as Map<String, dynamic>? ?? {},
      ),
      categories: CategoryScores.fromJson(
        j['categories'] as Map<String, dynamic>? ?? {},
      ),
      benchmarks: Benchmarks.fromJson(
        j['benchmarks'] as Map<String, dynamic>? ?? {},
      ),
      aiSummary: j['ai_summary'] ?? '',
      driversDisplay: DriversDisplay.fromJson(
        j['drivers_display'] as Map<String, dynamic>? ?? {},
      ),
      watchAreas: (j['watch_areas'] as List<dynamic>? ?? [])
          .map((e) => WatchArea.fromJson(e as Map<String, dynamic>))
          .toList(),
      activeAlerts: (j['active_alerts'] as List<dynamic>? ?? [])
          .map((e) => ActiveAlert.fromJson(e as Map<String, dynamic>))
          .toList(),
      dataCoverageNote: j['data_coverage_note'] ?? '',
    );
  }
}

class OverallHealth {
  OverallHealth({
    required this.score,
    required this.label,
    required this.priorScore,
    required this.peerAvg,
    required this.aiConfidence,
    required this.dataCompleteness,
    required this.incompleteData,
    required this.asOf,
  });

  final int score;
  final String label;
  final int priorScore;
  final int peerAvg;
  final double aiConfidence;
  final int dataCompleteness;
  final bool incompleteData;
  final String asOf;

  int get delta => score - priorScore;

  factory OverallHealth.fromJson(Map<String, dynamic> j) {
    return OverallHealth(
      score: j['score'] ?? 0,
      label: j['label'] ?? '',
      priorScore: j['prior_score'] ?? 0,
      peerAvg: j['peer_avg'] ?? 0,
      aiConfidence: (j['ai_confidence'] as num?)?.toDouble() ?? 0.0,
      dataCompleteness: j['data_completeness'] ?? 0,
      incompleteData: j['incomplete_data'] as bool? ?? false,
      asOf: j['as_of'] ?? '',
    );
  }
}

class CategoryScore {
  CategoryScore({
    required this.score,
    required this.label,
    required this.priorScore,
    required this.peerAvg,
    required this.missing,
  });

  final int score;
  final String label;
  final int priorScore;
  final int peerAvg;
  final List<String> missing;

  int get delta => score - priorScore;
  double get progress => score / 100.0;

  factory CategoryScore.fromJson(Map<String, dynamic> j) {
    return CategoryScore(
      score: j['score'] ?? 0,
      label: j['label'] ?? '',
      priorScore: j['prior_score'] ?? 0,
      peerAvg: j['peer_avg'] ?? 0,
      missing: (j['missing'] as List<dynamic>? ?? [])
          .map((e) => e.toString())
          .toList(),
    );
  }

  static CategoryScore empty() => CategoryScore(
        score: 0,
        label: '',
        priorScore: 0,
        peerAvg: 0,
        missing: const [],
      );
}

class CategoryScores {
  CategoryScores({
    required this.financial,
    required this.operational,
    required this.customer,
    required this.risk,
    required this.growth,
  });

  final CategoryScore financial;
  final CategoryScore operational;
  final CategoryScore customer;
  final CategoryScore risk;
  final CategoryScore growth;

  factory CategoryScores.fromJson(Map<String, dynamic> j) {
    return CategoryScores(
      financial: CategoryScore.fromJson(
        j['financial'] as Map<String, dynamic>? ?? {},
      ),
      operational: CategoryScore.fromJson(
        j['operational'] as Map<String, dynamic>? ?? {},
      ),
      customer: CategoryScore.fromJson(
        j['customer'] as Map<String, dynamic>? ?? {},
      ),
      risk: CategoryScore.fromJson(j['risk'] as Map<String, dynamic>? ?? {}),
      growth: CategoryScore.fromJson(
        j['growth'] as Map<String, dynamic>? ?? {},
      ),
    );
  }
}

class Benchmarks {
  Benchmarks({required this.peerPool, required this.peerAvg});

  final String peerPool;
  final int peerAvg;

  factory Benchmarks.fromJson(Map<String, dynamic> j) {
    return Benchmarks(
      peerPool: j['peer_pool'] ?? '',
      peerAvg: j['peer_avg'] ?? 0,
    );
  }
}

class DriverItem {
  DriverItem({
    required this.headline,
    required this.description,
    required this.recommendedAction,
  });

  final String headline;
  final String description;
  final String recommendedAction;

  factory DriverItem.fromJson(Map<String, dynamic> j) {
    return DriverItem(
      headline: j['headline'] ?? '',
      description: j['description'] ?? '',
      recommendedAction: j['recommended_action'] ?? '',
    );
  }
}

class DriversDisplay {
  DriversDisplay({required this.positives, required this.drags});

  final List<DriverItem> positives;
  final List<DriverItem> drags;

  factory DriversDisplay.fromJson(Map<String, dynamic> j) {
    return DriversDisplay(
      positives: (j['positives'] as List<dynamic>? ?? [])
          .map((e) => DriverItem.fromJson(e as Map<String, dynamic>))
          .toList(),
      drags: (j['drags'] as List<dynamic>? ?? [])
          .map((e) => DriverItem.fromJson(e as Map<String, dynamic>))
          .toList(),
    );
  }
}

class PossibleCause {
  PossibleCause({required this.cause, required this.evidence});

  final String cause;
  final String evidence;

  factory PossibleCause.fromJson(Map<String, dynamic> j) {
    return PossibleCause(cause: j['cause'] ?? '', evidence: j['evidence'] ?? '');
  }
}

class WatchArea {
  WatchArea({
    required this.title,
    required this.description,
    required this.possibleCauses,
    required this.recommendedAction,
    required this.ownerConfirmationPrompt,
    required this.learningId,
  });

  final String title;
  final String description;
  final List<PossibleCause> possibleCauses;
  final String recommendedAction;
  final String ownerConfirmationPrompt;
  final String learningId;

  factory WatchArea.fromJson(Map<String, dynamic> j) {
    return WatchArea(
      title: j['title'] ?? '',
      description: j['description'] ?? '',
      possibleCauses: (j['possible_causes'] as List<dynamic>? ?? [])
          .map((e) => PossibleCause.fromJson(e as Map<String, dynamic>))
          .toList(),
      recommendedAction: j['recommended_action'] ?? '',
      ownerConfirmationPrompt: j['owner_confirmation_prompt'] ?? '',
      learningId: j['learning_id'] ?? '',
    );
  }
}

class ActiveAlert {
  ActiveAlert({
    required this.description,
    required this.urgencyContext,
    required this.recommendedAction,
  });

  final String description;
  final String urgencyContext;
  final String recommendedAction;

  factory ActiveAlert.fromJson(Map<String, dynamic> j) {
    return ActiveAlert(
      description: j['description'] ?? '',
      urgencyContext: j['urgency_context'] ?? '',
      recommendedAction: j['recommended_action'] ?? '',
    );
  }
}
class HealthRefreshResponse {
  HealthRefreshResponse({
    required this.success,
    required this.mode,
    required this.status,
  });

  final bool success;
  final String mode;
  final Map<String, dynamic> status;

  factory HealthRefreshResponse.fromJson(Map<String, dynamic> j) {
    return HealthRefreshResponse(
      success: j['success'] as bool? ?? false,
      mode: j['mode'] ?? '',
      status: j['status'] as Map<String, dynamic>? ?? {},
    );
  }
}