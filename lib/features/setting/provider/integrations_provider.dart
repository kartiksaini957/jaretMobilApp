import 'package:flutter_riverpod/flutter_riverpod.dart';

/// One connector card. `provenance` is the `.cv` line — where the read comes
/// from, how much we trust it, and (where known) what's missing from it.
class IntegrationItem {
  const IntegrationItem({
    required this.id,
    required this.category,
    required this.name,
    required this.provenance,
    this.connected = false,
    this.lastSynced,
    this.syncFrequency = IntegrationItem.defaultFrequency,
  });

  static const defaultFrequency = 'Sync hourly';
  static const frequencies = ['Sync hourly', 'Sync daily'];

  final String id;
  final String category;
  final String name;
  final String provenance;
  final bool connected;

  /// Human-readable freshness ("2h ago"), only set while connected.
  final String? lastSynced;
  final String syncFrequency;

  /// `.cs` — "Connected · synced 2h ago" / "Not connected".
  String get statusLabel {
    if (!connected) return 'Not connected';
    return lastSynced == null ? 'Connected' : 'Connected · synced $lastSynced';
  }

  IntegrationItem copyWith({
    bool? connected,
    String? lastSynced,
    bool clearLastSynced = false,
    String? syncFrequency,
  }) {
    return IntegrationItem(
      id: id,
      category: category,
      name: name,
      provenance: provenance,
      connected: connected ?? this.connected,
      lastSynced: clearLastSynced ? null : (lastSynced ?? this.lastSynced),
      syncFrequency: syncFrequency ?? this.syncFrequency,
    );
  }
}

/// The locked integration stack — QuickBooks and Square direct, everything
/// else through Apideck. Connecting just flips local state here; the real
/// OAuth/Apideck handshake is backend work.
class IntegrationsController extends Notifier<List<IntegrationItem>> {
  @override
  List<IntegrationItem> build() => const [
    IntegrationItem(
      id: 'quickbooks',
      category: 'Accounting',
      name: 'QuickBooks Online',
      connected: true,
      lastSynced: '2h ago',
      provenance:
          'Direct connection · Confidence: High · 94% of expected fields '
          '— missing invoice due dates (weakens DSO reads)',
    ),
    IntegrationItem(
      id: 'xero',
      category: 'Accounting',
      name: 'Xero',
      provenance: 'Via Apideck',
    ),
    IntegrationItem(
      id: 'square',
      category: 'Point of Sale',
      name: 'Square',
      connected: true,
      lastSynced: '25m ago',
      provenance: 'Direct connection · Confidence: High',
    ),
    IntegrationItem(
      id: 'omnivore',
      category: 'Point of Sale',
      name: 'Omnivore (restaurant POS)',
      provenance: 'Connects Toast, Micros, and more',
    ),
    IntegrationItem(
      id: 'shopify',
      category: 'Commerce & CRM',
      name: 'Shopify',
      provenance: 'Via Apideck',
    ),
    IntegrationItem(
      id: 'hubspot',
      category: 'Commerce & CRM',
      name: 'HubSpot',
      provenance: 'Via Apideck',
    ),
  ];

  void _update(String id, IntegrationItem Function(IntegrationItem) change) {
    state = [
      for (final item in state)
        if (item.id == id) change(item) else item,
    ];
  }

  void connect(String id) => _update(
    id,
    (item) => item.copyWith(connected: true, lastSynced: 'just now'),
  );

  void disconnect(String id) => _update(
    id,
    (item) => item.copyWith(connected: false, clearLastSynced: true),
  );

  void toggleConnection(String id) {
    final item = state.firstWhere((i) => i.id == id);
    item.connected ? disconnect(id) : connect(id);
  }

  void runSyncNow(String id) =>
      _update(id, (item) => item.copyWith(lastSynced: 'just now'));

  void setSyncFrequency(String id, String frequency) =>
      _update(id, (item) => item.copyWith(syncFrequency: frequency));
}

final integrationsProvider =
    NotifierProvider<IntegrationsController, List<IntegrationItem>>(
      IntegrationsController.new,
    );

/// The connector categories in reference order, each listed once.
final integrationCategoriesProvider = Provider<List<String>>((ref) {
  final seen = <String>{};
  return [
    for (final item in ref.watch(integrationsProvider))
      if (seen.add(item.category)) item.category,
  ];
});
