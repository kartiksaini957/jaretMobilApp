class UnifiedSnapshotsResponse {
  final bool success;
  final List<UnifiedSnapshotItem> data;

  const UnifiedSnapshotsResponse({
    this.success = false,
    this.data = const [],
  });

  factory UnifiedSnapshotsResponse.fromJson(Map<String, dynamic> json) {
    final list = json['data'] as List<dynamic>? ?? [];
    return UnifiedSnapshotsResponse(
      success: json['success'] as bool? ?? false,
      data: list
          .whereType<Map<String, dynamic>>()
          .map((item) => UnifiedSnapshotItem.fromJson(item))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() => {
        'success': success,
        'data': data.map((e) => e.toJson()).toList(),
      };
}

class UnifiedSnapshotItem {
  final String snapshotId;
  final String date;
  final int healthScore;

  const UnifiedSnapshotItem({
    required this.snapshotId,
    required this.date,
    required this.healthScore,
  });

  factory UnifiedSnapshotItem.fromJson(Map<String, dynamic> json) {
    return UnifiedSnapshotItem(
      snapshotId: json['snapshot_id']?.toString() ?? '',
      date: json['date']?.toString() ?? '',
      healthScore: (json['health_score'] as num?)?.toInt() ?? 0,
    );
  }

  Map<String, dynamic> toJson() => {
        'snapshot_id': snapshotId,
        'date': date,
        'health_score': healthScore,
      };

  String get formattedDate {
    if (date.isEmpty) return 'Recent Snapshot';
    try {
      final parsed = DateTime.parse(date);
      const months = [
        'Jan',
        'Feb',
        'Mar',
        'Apr',
        'May',
        'Jun',
        'Jul',
        'Aug',
        'Sep',
        'Oct',
        'Nov',
        'Dec',
      ];
      return '${months[parsed.month - 1]} ${parsed.day}, ${parsed.year}';
    } catch (_) {
      return date;
    }
  }

  String get label => 'Health Score: $healthScore';
}
