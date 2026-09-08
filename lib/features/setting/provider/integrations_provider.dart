import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/api_services.dart';
import '../../../utils/pref_utils.dart';
import '../model/integrationsStatusModel.dart';

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
  final String? lastSynced;
  final String syncFrequency;
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

class IntegrationsState {
  const IntegrationsState({
    this.items = const [
      IntegrationItem(
        id: 'quickbooks',
        category: 'Accounting',
        name: 'QuickBooks Online',
        connected: false,
        lastSynced: '2h ago',
        provenance:
            'Direct connection · Confidence: High · 94% of expected fields '
            '— missing invoice due dates (weakens DSO reads)',
      ),
      IntegrationItem(
        id: 'xero',
        category: 'Accounting',
        name: 'Xero',
        connected: false,
        provenance: 'Via Apideck',
      ),
      IntegrationItem(
        id: 'square',
        category: 'Point of Sale',
        name: 'Square',
        connected: false,
        lastSynced: '25m ago',
        provenance: 'Direct connection · Confidence: High',
      ),
      IntegrationItem(
        id: 'omnivore',
        category: 'Point of Sale',
        name: 'Omnivore (restaurant POS)',
        connected: false,
        provenance: 'Connects Toast, Micros, and more',
      ),
      IntegrationItem(
        id: 'shopify',
        category: 'Commerce & CRM',
        name: 'Shopify',
        connected: false,
        provenance: 'Via Apideck',
      ),
      IntegrationItem(
        id: 'hubspot',
        category: 'Commerce & CRM',
        name: 'HubSpot',
        connected: false,
        provenance: 'Via Apideck',
      ),
    ],
    this.syncProgress,
    this.isLoading = false,
    this.connectingId,
    this.disconnectingId,
    this.error,
  });

  final List<IntegrationItem> items;
  final SyncProgressData? syncProgress;
  final bool isLoading;
  final String? connectingId;
  final String? disconnectingId;
  final String? error;

  IntegrationsState copyWith({
    List<IntegrationItem>? items,
    SyncProgressData? syncProgress,
    bool? isLoading,
    String? connectingId,
    bool clearConnectingId = false,
    String? disconnectingId,
    bool clearDisconnectingId = false,
    String? error,
  }) {
    return IntegrationsState(
      items: items ?? this.items,
      syncProgress: syncProgress ?? this.syncProgress,
      isLoading: isLoading ?? this.isLoading,
      connectingId: clearConnectingId
          ? null
          : (connectingId ?? this.connectingId),
      disconnectingId: clearDisconnectingId
          ? null
          : (disconnectingId ?? this.disconnectingId),
      error: error,
    );
  }
}

class IntegrationsController extends Notifier<IntegrationsState> {
  @override
  IntegrationsState build() {
    Future.microtask(() => loadStatus());
    return const IntegrationsState();
  }

  Future<void> loadStatus() async {
    state = state.copyWith(isLoading: true, error: null);
    try {
      final token = await PrefUtils.getAccessToken();
      if (token == null || token.isEmpty) {
        throw ApiException('Not signed in.');
      }
      final data = await ApiService().getIntegrationsStatus(accessToken: token);
      if (!ref.mounted) return;

      final updatedItems = state.items.map((item) {
        final isConn = data.isConnected(item.id);
        return item.copyWith(
          connected: isConn,
          lastSynced: isConn ? (item.lastSynced ?? 'synced') : null,
          clearLastSynced: !isConn,
        );
      }).toList();

      state = state.copyWith(
        items: updatedItems,
        syncProgress: data.syncProgress,
        isLoading: false,
      );
    } catch (e) {
      if (!ref.mounted) return;
      final message = e is ApiException ? e.message : 'Could not load integrations status.';
      debugPrint('[IntegrationsController] Error loading status: $e');
      state = state.copyWith(isLoading: false, error: message);
    }
  }

  void _update(String id, IntegrationItem Function(IntegrationItem) change) {
    state = state.copyWith(
      items: [
        for (final item in state.items)
          if (item.id == id) change(item) else item,
      ],
    );
  }

  Future<String> connect(String id, {String? shop}) async {
    state = state.copyWith(connectingId: id, error: null);
    try {
      final token = await PrefUtils.getAccessToken();
      if (token == null || token.isEmpty) {
        throw ApiException('Not signed in.');
      }
      final redirectUrl = await ApiService().connectIntegration(
        accessToken: token,
        provider: id,
        shop: shop,
      );
      if (!ref.mounted) return redirectUrl;
      state = state.copyWith(clearConnectingId: true);
      return redirectUrl;
    } catch (e) {
      if (!ref.mounted) rethrow;
      final message =
          e is ApiException ? e.message : 'Could not connect integration.';
      debugPrint('[IntegrationsController] Connect error: $e');
      state = state.copyWith(clearConnectingId: true, error: message);
      rethrow;
    }
  }

  Future<void> disconnect(String id) async {
    state = state.copyWith(disconnectingId: id, error: null);
    try {
      final token = await PrefUtils.getAccessToken();
      if (token == null || token.isEmpty) {
        throw ApiException('Not signed in.');
      }
      await ApiService().disconnectIntegration(
        accessToken: token,
        provider: id,
      );
      if (!ref.mounted) return;
      _update(
        id,
        (item) => item.copyWith(connected: false, clearLastSynced: true),
      );
      state = state.copyWith(clearDisconnectingId: true);
    } catch (e) {
      if (!ref.mounted) return;
      final message = e is ApiException ? e.message : 'Could not disconnect integration.';
      debugPrint('[IntegrationsController] Disconnect error: $e');
      state = state.copyWith(clearDisconnectingId: true, error: message);
      rethrow;
    }
  }

  void toggleConnection(String id) {
    final item = state.items.firstWhere((i) => i.id == id);
    item.connected ? disconnect(id) : connect(id);
  }

  void runSyncNow(String id) =>
      _update(id, (item) => item.copyWith(lastSynced: 'just now'));

  void setSyncFrequency(String id, String frequency) =>
      _update(id, (item) => item.copyWith(syncFrequency: frequency));
}

final integrationsProvider =
    NotifierProvider<IntegrationsController, IntegrationsState>(
      IntegrationsController.new,
    );

final integrationCategoriesProvider = Provider<List<String>>((ref) {
  final seen = <String>{};
  return [
    for (final item in ref.watch(integrationsProvider).items)
      if (seen.add(item.category)) item.category,
  ];
});

