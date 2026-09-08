class IntegrationsStatusResponse {
  const IntegrationsStatusResponse({
    required this.success,
    required this.data,
  });

  factory IntegrationsStatusResponse.fromJson(Map<String, dynamic> json) {
    return IntegrationsStatusResponse(
      success: json['success'] as bool? ?? false,
      data: IntegrationsStatusData.fromJson(
        json['data'] as Map<String, dynamic>? ?? {},
      ),
    );
  }

  final bool success;
  final IntegrationsStatusData data;
}

class IntegrationsStatusData {
  const IntegrationsStatusData({
    required this.quickbooks,
    required this.xero,
    required this.square,
    required this.omnivore,
    required this.shopify,
    required this.hubspot,
    required this.syncProgress,
  });

  factory IntegrationsStatusData.fromJson(Map<String, dynamic> json) {
    return IntegrationsStatusData(
      quickbooks: json['quickbooks'] as bool? ?? false,
      xero: json['xero'] as bool? ?? false,
      square: json['square'] as bool? ?? false,
      omnivore: json['omnivore'] as bool? ?? false,
      shopify: json['shopify'] as bool? ?? false,
      hubspot: json['hubspot'] as bool? ?? false,
      syncProgress: SyncProgressData.fromJson(
        json['sync_progress'] as Map<String, dynamic>? ?? {},
      ),
    );
  }

  final bool quickbooks;
  final bool xero;
  final bool square;
  final bool omnivore;
  final bool shopify;
  final bool hubspot;
  final SyncProgressData syncProgress;

  bool isConnected(String id) {
    switch (id.toLowerCase().trim()) {
      case 'quickbooks':
      case 'quickbooks online':
        return quickbooks;
      case 'xero':
        return xero;
      case 'square':
        return square;
      case 'omnivore':
      case 'omnivore (restaurant pos)':
        return omnivore;
      case 'shopify':
        return shopify;
      case 'hubspot':
        return hubspot;
      default:
        return false;
    }
  }
}

class SyncProgressData {
  const SyncProgressData({
    required this.connected,
    required this.syncing,
    required this.firstRead,
  });

  factory SyncProgressData.fromJson(Map<String, dynamic> json) {
    return SyncProgressData(
      connected: json['connected'] as bool? ?? false,
      syncing: json['syncing'] as bool? ?? false,
      firstRead: json['first_read'] as bool? ?? false,
    );
  }

  final bool connected;
  final bool syncing;
  final bool firstRead;
}
