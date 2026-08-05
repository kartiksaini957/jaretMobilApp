import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../theme/app_theme.dart';
import '../provider/integrations_provider.dart';
import '../theme/settings_colors.dart';
import '../widgets/settings_row_controls.dart';
import '../widgets/settings_section_card.dart';

class IntegrationsTab extends ConsumerWidget {
  const IntegrationsTab({super.key});

  /// `@media(max-width:1100px){ .congrid{ grid-template-columns:1fr } }` —
  /// two connector columns only once there's room for them.
  static const double _twoColumnBreakpoint = 720;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final items = ref.watch(integrationsProvider);
    final categories = ref.watch(integrationCategoriesProvider);
    final controller = ref.read(integrationsProvider.notifier);

    return SettingsSectionCard(
      title: 'Integrations',
      subtitle:
          'Your data sources. One card per connection — status, freshness, '
          'and where each read comes from.',
      children: [
        for (final category in categories) ...[
          SettingsGroupLabel(
            category,
            topPadding: category == categories.first ? 0 : 20,
          ),
          _ConnectorGrid(
            items: items.where((i) => i.category == category).toList(),
            controller: controller,
          ),
        ],
      ],
    );
  }
}

/// `.congrid` — one column on phones, two once the panel is wide enough.
class _ConnectorGrid extends StatelessWidget {
  const _ConnectorGrid({required this.items, required this.controller});

  final List<IntegrationItem> items;
  final IntegrationsController controller;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final columns =
            constraints.maxWidth >= IntegrationsTab._twoColumnBreakpoint
            ? 2
            : 1;
        const gap = 14.0;
        final cardWidth = columns == 1
            ? constraints.maxWidth
            : (constraints.maxWidth - gap) / 2;

        return Wrap(
          spacing: gap,
          runSpacing: gap,
          children: [
            for (final item in items)
              SizedBox(
                width: cardWidth,
                child: _ConnectorCard(item: item, controller: controller),
              ),
          ],
        );
      },
    );
  }
}

/// `.concard` — name, status dot + freshness, provenance line, then the
/// actions the connector's state allows.
class _ConnectorCard extends StatelessWidget {
  const _ConnectorCard({required this.item, required this.controller});

  final IntegrationItem item;
  final IntegrationsController controller;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 18),
      decoration: BoxDecoration(
        color: SettingsColors.cardFill,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: SettingsColors.connectorBorder),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            item.name,
            style: AppTextStyles.body.copyWith(
              color: SettingsColors.white,
              fontSize: 14.5,
              fontWeight: FontWeight.w800,
            ),
          ),
          const SizedBox(height: 6),
          Row(
            children: [
              SettingsStatusDot(
                color: item.connected
                    ? SettingsColors.statusConnected
                    : SettingsColors.statusNotConnected,
              ),
              const SizedBox(width: 7),
              Expanded(
                child: Text(
                  item.statusLabel,
                  style: AppTextStyles.body.copyWith(
                    color: SettingsColors.soft,
                    fontSize: 11.5,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 4),
          Text(
            item.provenance,
            style: AppTextStyles.body.copyWith(
              color: SettingsColors.soft.withValues(alpha: 0.8),
              fontSize: 11,
              height: 1.4,
            ),
          ),
          const SizedBox(height: 14),
          if (item.connected)
            Wrap(
              spacing: 8,
              runSpacing: 8,
              crossAxisAlignment: WrapCrossAlignment.center,
              children: [
                SizedBox(
                  width: 140,
                  child: SettingsDropdown<String>(
                    value: item.syncFrequency,
                    options: IntegrationItem.frequencies,
                    compact: true,
                    onChanged: (v) => controller.setSyncFrequency(item.id, v),
                  ),
                ),
                SettingsPillButton(
                  label: 'Run sync now',
                  compact: true,
                  onPressed: () => controller.runSyncNow(item.id),
                ),
                SettingsPillButton(
                  label: 'Disconnect',
                  tone: SettingsButtonTone.danger,
                  compact: true,
                  onPressed: () => controller.disconnect(item.id),
                ),
              ],
            )
          else
            SettingsPillButton(
              label: 'Connect',
              tone: SettingsButtonTone.primary,
              onPressed: () => controller.connect(item.id),
            ),
        ],
      ),
    );
  }
}
