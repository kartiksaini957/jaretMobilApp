class ClassifierRunResponse {
  const ClassifierRunResponse({
    required this.userId,
    required this.status,
    required this.startedAt,
  });

  factory ClassifierRunResponse.fromJson(Map<String, dynamic> json) {
    final data = json['data'] as Map<String, dynamic>? ?? {};
    return ClassifierRunResponse(
      userId: data['user_id'] as String? ?? '',
      status: data['status'] as String? ?? '',
      startedAt: data['started_at'] as String? ?? '',
    );
  }

  final String userId;
  final String status; // "triggered"
  final String startedAt;
}

class CorrectionUndoResponse {
  const CorrectionUndoResponse({
    required this.correctionId,
    required this.status,
  });

  factory CorrectionUndoResponse.fromJson(Map<String, dynamic> json) {
    final data = json['data'] as Map<String, dynamic>? ?? {};
    return CorrectionUndoResponse(
      correctionId: data['correction_id'] as String? ?? '',
      status: data['status'] as String? ?? '', // "undone"
    );
  }

  final String correctionId;
  final String status;
}