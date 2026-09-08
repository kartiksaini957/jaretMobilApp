class ConsentHistoryResponse {
  const ConsentHistoryResponse({required this.success, required this.data});

  factory ConsentHistoryResponse.fromJson(Map<String, dynamic> json) {
    final list = (json['data'] as List<dynamic>? ?? [])
        .map((e) => ConsentEntry.fromJson(e as Map<String, dynamic>))
        .toList();
    return ConsentHistoryResponse(
      success: json['success'] as bool? ?? false,
      data: list,
    );
  }

  final bool success;
  final List<ConsentEntry> data;
}

class ConsentEntry {
  const ConsentEntry({
    required this.userId,
    required this.action,
    required this.changes,
    required this.timestamp,
  });

  factory ConsentEntry.fromJson(Map<String, dynamic> json) {
    return ConsentEntry(
      userId: json['user_id'] as String? ?? '',
      action: json['action'] as String? ?? '',
      changes: json['changes'] as Map<String, dynamic>? ?? {},
      timestamp: json['timestamp'] as String? ?? '',
    );
  }

  final String userId;
  final String action;
  final Map<String, dynamic> changes; // dynamic keys — built into a summary at display time
  final String timestamp;

  /// Turns whatever fields are present in `changes` into readable lines,
  /// e.g. "Peer benchmarking: On", "Photo permissions: On (google, website)".
  List<String> get changeSummaryLines {
    final lines = <String>[];
    for (final entry in changes.entries) {
      final key = entry.key;
      final value = entry.value;
      if (key == 'updated_at') continue; // shown separately as the timestamp

      switch (key) {
        case 'peer_benchmarking':
          lines.add('Peer benchmarking: ${value == true ? 'On' : 'Off'}');
          break;
        case 'anonymized_ai_use':
          lines.add('Anonymized AI use: ${value == true ? 'On' : 'Off'}');
          break;
        case 'retention_days':
          lines.add('Data retention: $value days');
          break;
        case 'photo_permissions':
          if (value is Map<String, dynamic>) {
            final enabled = value['enabled'] == true;
            final sources = (value['sources'] as List<dynamic>? ?? [])
                .map((e) => e.toString())
                .join(', ');
            lines.add(
              'Photo permissions: ${enabled ? 'On' : 'Off'}'
              '${sources.isNotEmpty ? ' ($sources)' : ''}',
            );
          }
          break;
        default:
          lines.add('$key: $value');
      }
    }
    return lines;
  }
}