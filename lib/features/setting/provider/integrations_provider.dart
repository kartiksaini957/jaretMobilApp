import 'package:flutter_riverpod/flutter_riverpod.dart';

class IntegrationItem {
  const IntegrationItem({
    required this.id,
    required this.category,
    required this.name,
    required this.subtitle,
    this.connected = false,
  });

  final String id;
  final String category;
  final String name;
  final String subtitle;
  final bool connected;

  IntegrationItem copyWith({bool? connected}) {
    return IntegrationItem(
      id: id,
      category: category,
      name: name,
      subtitle: subtitle,
      connected: connected ?? this.connected,
    );
  }
}

/// Data-source connections grouped by category. Toggling `Connect` just
/// flips local state — the real OAuth/Apideck handshake is out of scope
/// for this mock.
class IntegrationsController extends Notifier<List<IntegrationItem>> {
  @override
  List<IntegrationItem> build() => const [
    IntegrationItem(
      id: 'quickbooks',
      category: 'Accounting',
      name: 'QuickBooks Online',
      subtitle: 'Direct connection · Accounting (read-only)',
    ),
    IntegrationItem(
      id: 'xero',
      category: 'Accounting',
      name: 'Xero',
      subtitle: 'Via Apideck',
    ),
    IntegrationItem(
      id: 'square',
      category: 'Point of Sale',
      name: 'Square',
      subtitle: 'Direct connection',
    ),
    IntegrationItem(
      id: 'omnivore',
      category: 'Point of Sale',
      name: 'Omnivore (restaurant POS)',
      subtitle: 'Via Apideck',
    ),
    IntegrationItem(
      id: 'shopify',
      category: 'Commerce & CRM',
      name: 'Shopify',
      subtitle: 'Via Apideck',
    ),
    IntegrationItem(
      id: 'hubspot',
      category: 'Commerce & CRM',
      name: 'HubSpot',
      subtitle: 'Via Apideck',
    ),
  ];

  void toggleConnection(String id) {
    state = [
      for (final item in state)
        if (item.id == id) item.copyWith(connected: !item.connected) else item,
    ];
  }
}

final integrationsProvider =
    NotifierProvider<IntegrationsController, List<IntegrationItem>>(
      IntegrationsController.new,
    );
