class DiagnosticsExportResponse {
  const DiagnosticsExportResponse({required this.success, required this.data});

  factory DiagnosticsExportResponse.fromJson(Map<String, dynamic> json) {
    return DiagnosticsExportResponse(
      success: json['success'] as bool? ?? false,
      data: DiagnosticsExportData.fromJson(
        json['data'] as Map<String, dynamic>? ?? {},
      ),
    );
  }

  final bool success;
  final DiagnosticsExportData data;
}

class QuickbooksInfo {
  const QuickbooksInfo({required this.connected, required this.lastSync});

  factory QuickbooksInfo.fromJson(Map<String, dynamic> json) {
    return QuickbooksInfo(
      connected: json['connected'] as bool? ?? false,
      lastSync: json['last_sync'] as String? ?? '',
    );
  }

  final bool connected;
  final String lastSync;
}

class PosIntegration {
  const PosIntegration({
    required this.provider,
    required this.connected,
    required this.updatedAt,
  });

  factory PosIntegration.fromJson(Map<String, dynamic> json) {
    return PosIntegration(
      provider: json['provider'] as String? ?? '',
      connected: json['connected'] as bool? ?? false,
      updatedAt: json['updated_at'] as String? ?? '',
    );
  }

  final String provider;
  final bool connected;
  final String updatedAt;
}

class DiagnosticsExportData {
  const DiagnosticsExportData({
    required this.userId,
    required this.exportTimestamp,
    required this.quickbooks,
    required this.posIntegrations,
    required this.syncLogs,
  });

  factory DiagnosticsExportData.fromJson(Map<String, dynamic> json) {
    final connectors = json['connectors'] as Map<String, dynamic>? ?? {};
    final pos = (connectors['pos_integrations'] as List<dynamic>? ?? [])
        .map((e) => PosIntegration.fromJson(e as Map<String, dynamic>))
        .toList();
    final logs = (json['sync_logs'] as List<dynamic>? ?? [])
        .map((e) => e.toString())
        .toList();
    return DiagnosticsExportData(
      userId: json['user_id'] as String? ?? '',
      exportTimestamp: json['export_timestamp'] as String? ?? '',
      quickbooks: QuickbooksInfo.fromJson(
        connectors['quickbooks'] as Map<String, dynamic>? ?? {},
      ),
      posIntegrations: pos,
      syncLogs: logs,
    );
  }

  final String userId;
  final String exportTimestamp;
  final QuickbooksInfo quickbooks;
  final List<PosIntegration> posIntegrations;
  final List<String> syncLogs;
}