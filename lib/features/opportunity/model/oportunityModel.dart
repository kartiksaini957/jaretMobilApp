class OpportunitiesOverviewResponse {
  OpportunitiesOverviewResponse({required this.success, required this.data});

  final bool success;
  final OpportunitiesOverviewData data;

  factory OpportunitiesOverviewResponse.fromJson(Map<String, dynamic> json) {
    return OpportunitiesOverviewResponse(
      success: json['success'] as bool? ?? false,
      data: OpportunitiesOverviewData.fromJson(
        json['data'] as Map<String, dynamic>? ?? {},
      ),
    );
  }
}

class OpportunitiesOverviewData {
  OpportunitiesOverviewData({
    required this.kpis,
    required this.recommendedHero,
    required this.moreMatches,
    required this.portfolioSummary,
  });

  final OpportunityKpis kpis;
  final OpportunityCard? recommendedHero;
  final List<OpportunityCard> moreMatches;
  final PortfolioSummary portfolioSummary;

  factory OpportunitiesOverviewData.fromJson(Map<String, dynamic> j) {
    final heroJson = j['recommended_hero'] as Map<String, dynamic>?;
    return OpportunitiesOverviewData(
      kpis: OpportunityKpis.fromJson(j['kpis'] as Map<String, dynamic>? ?? {}),
      recommendedHero: heroJson != null
          ? OpportunityCard.fromJson(heroJson)
          : null,
      moreMatches: (j['more_matches'] as List<dynamic>? ?? [])
          .map((e) => OpportunityCard.fromJson(e as Map<String, dynamic>))
          .toList(),
      portfolioSummary: PortfolioSummary.fromJson(
        j['portfolio_summary'] as Map<String, dynamic>? ?? {},
      ),
    );
  }
}

class OpportunityKpis {
  OpportunityKpis({
    required this.activeOpportunitiesCount,
    required this.activeOpportunitiesDescriptor,
    required this.newThisWeekCount,
    required this.newThisWeekLabel,
    required this.totalPotentialValue,
    required this.avgFitScore,
    required this.eventReadinessIndex,
    this.historicalRoiMultiplier,
    this.historicalRoiSampleSize,
  });

  final int activeOpportunitiesCount;
  final String activeOpportunitiesDescriptor;
  final int newThisWeekCount;
  final String newThisWeekLabel;
  final String totalPotentialValue;
  final int avgFitScore;
  final int eventReadinessIndex;
  final String? historicalRoiMultiplier;
  final int? historicalRoiSampleSize;

  factory OpportunityKpis.fromJson(Map<String, dynamic> j) {
    final active = j['active_opportunities'] as Map<String, dynamic>? ?? {};
    final newWeek = j['new_this_week'] as Map<String, dynamic>? ?? {};
    final roi = j['historical_roi'] as Map<String, dynamic>?;
    return OpportunityKpis(
      activeOpportunitiesCount: active['count'] ?? 0,
      activeOpportunitiesDescriptor: active['descriptor'] ?? '',
      newThisWeekCount: newWeek['count'] ?? 0,
      newThisWeekLabel: newWeek['label'] ?? '',
      totalPotentialValue: j['total_potential_value'] ?? '',
      avgFitScore: j['avg_fit_score'] ?? 0,
      eventReadinessIndex: j['event_readiness_index'] ?? 0,
      historicalRoiMultiplier: roi?['multiplier'],
      historicalRoiSampleSize: roi?['sample_size'],
    );
  }
}

class OpportunityCard {
  OpportunityCard({
    required this.id,
    required this.type,
    required this.boxType,
    required this.outBox,
    required this.title,
    required this.source,
    required this.matchScore,
    required this.readinessScore,
    required this.dataTrustIndicator,
    required this.riskLevel,
    required this.driveTimeMinutes,
    required this.distanceMiles,
    required this.expiresAt,
    required this.estimatedRevenue,
    required this.listedFee,
    required this.whyReasonCodes,
    required this.riskSignals,
    required this.verifyFlag,
    this.verifyFlagMessage,
    required this.registrationUrl,
    required this.sourceUrl,
  });

  final String id;
  final String type;
  final String boxType;
  final bool outBox;
  final String title;
  final String source;
  final int matchScore;
  final int readinessScore;
  final String dataTrustIndicator;
  final String riskLevel;
  final int driveTimeMinutes;
  final double distanceMiles;
  final String expiresAt;
  final String estimatedRevenue;
  final String listedFee;
  final List<String> whyReasonCodes;
  final List<String> riskSignals;
  final bool verifyFlag;
  final String? verifyFlagMessage;
  final String registrationUrl;
  final String sourceUrl;

  String get distanceLabel => '⌖ ~$driveTimeMinutes min · $distanceMiles mi';

  factory OpportunityCard.fromJson(Map<String, dynamic> j) {
    return OpportunityCard(
      id: j['id'] ?? '',
      type: j['type'] ?? '',
      boxType: j['box_type'] ?? '',
      outBox: j['out_box'] as bool? ?? false,
      title: j['title'] ?? '',
      source: j['source'] ?? '',
      matchScore: j['match_score'] ?? 0,
      readinessScore: j['readiness_score'] ?? 0,
      dataTrustIndicator: j['data_trust_indicator'] ?? '',
      riskLevel: j['risk_level'] ?? '',
      driveTimeMinutes: j['drive_time_minutes'] ?? 0,
      distanceMiles: (j['distance_miles'] as num?)?.toDouble() ?? 0.0,
      expiresAt: j['expires_at'] ?? '',
      estimatedRevenue: j['estimated_revenue'] ?? '',
      listedFee: j['listed_fee'] ?? '',
      whyReasonCodes: (j['why_reason_codes'] as List<dynamic>? ?? [])
          .map((e) => e.toString())
          .toList(),
      riskSignals: (j['risk_signals'] as List<dynamic>? ?? [])
          .map((e) => e.toString())
          .toList(),
      verifyFlag: j['verify_flag'] as bool? ?? false,
      verifyFlagMessage: j['verify_flag_message'],
      registrationUrl: j['registration_url'] ?? '',
      sourceUrl: j['source_url'] ?? '',
    );
  }
}

class PortfolioSummary {
  PortfolioSummary({
    required this.activeCount,
    required this.pastCount,
    required this.totalCommittedDollars,
  });

  final int activeCount;
  final int pastCount;
  final String totalCommittedDollars;

  factory PortfolioSummary.fromJson(Map<String, dynamic> j) {
    return PortfolioSummary(
      activeCount: j['active_count'] ?? 0,
      pastCount: j['past_count'] ?? 0,
      totalCommittedDollars: j['total_committed_dollars'] ?? '',
    );
  }
}
