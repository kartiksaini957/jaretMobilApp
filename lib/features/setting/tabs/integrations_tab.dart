import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../provider/integrations_provider.dart';
import '../theme/settings_colors.dart';
import '../widgets/settings_row_controls.dart';
import '../widgets/settings_section_card.dart';

class IntegrationsTab extends ConsumerWidget {
  const IntegrationsTab({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final items = ref.watch(integrationsProvider);
    final controller = ref.read(integrationsProvider.notifier);

    final categories = <String>[];
    for (final item in items) {
      if (!categories.contains(item.category)) categories.add(item.category);
    }

    return SettingsSectionCard(
      title: 'Integrations',
      subtitle:
          'Your data sources. One card per connection — status, freshness, and where each read comes from.',
      children: [
        for (final category in categories) ...[
          SettingsGroupLabel(category, topPadding: category == categories.first ? 4 : 20),
          for (final item in items.where((i) => i.category == category))
            Padding(
              padding: const EdgeInsets.only(bottom: 10),
              child: _IntegrationCard(
                item: item,
                onToggle: () => controller.toggleConnection(item.id),
              ),
            ),
        ],
      ],
    );
  }
}

class _IntegrationCard extends StatelessWidget {
  const _IntegrationCard({required this.item, required this.onToggle});

  final IntegrationItem item;
  final VoidCallback onToggle;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: SettingsColors.cardFillStrong,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: SettingsColors.cardBorder),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            item.name,
            style: const TextStyle(
              color: SettingsColors.white,
              fontSize: 14.5,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 6),
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              SettingsStatusDot(
                color: item.connected
                    ? SettingsColors.statusConnected
                    : SettingsColors.statusNotConnected,
              ),
              const SizedBox(width: 6),
              Text(
                item.connected ? 'Connected' : 'Not connected',
                style: const TextStyle(
                  color: SettingsColors.white,
                  fontSize: 12,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),
          const SizedBox(height: 2),
          Text(
            item.subtitle,
            style: const TextStyle(color: SettingsColors.faintText, fontSize: 11.5),
          ),
          const SizedBox(height: 12),
          SettingsPillButton(
            label: item.connected ? 'Disconnect' : 'Connect',
            danger: item.connected,
            onPressed: onToggle,
          ),
        ],
      ),
    );
  }
}
