class BusinessProfileRichness {
  const BusinessProfileRichness({
    this.score = 0.0,
    this.band = 'Building',
    this.everReachedSharp = false,
    this.sectionsComplete = 0,
    this.totalSections = 16,
  });

  final double score;
  final String band;
  final bool everReachedSharp;
  final int sectionsComplete;
  final int totalSections;

  factory BusinessProfileRichness.fromJson(Map<String, dynamic> json) {
    return BusinessProfileRichness(
      score: (json['score'] as num?)?.toDouble() ?? 0.0,
      band: json['band'] as String? ?? 'Building',
      everReachedSharp: json['ever_reached_sharp'] as bool? ?? false,
      sectionsComplete: json['sections_complete'] as int? ?? 0,
      totalSections: json['total_sections'] as int? ?? 16,
    );
  }
}
