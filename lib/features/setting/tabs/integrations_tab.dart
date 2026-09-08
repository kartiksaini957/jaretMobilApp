import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/api_services.dart';
import '../../../theme/app_theme.dart';
import '../../../widgets/customToast.dart';
import '../../../widgets/in_app_webview_screen.dart';
import '../provider/integrations_provider.dart';
import '../theme/settings_colors.dart';
import '../widgets/settings_row_controls.dart';
import '../widgets/settings_section_card.dart';

class IntegrationsTab extends ConsumerWidget {
  const IntegrationsTab({super.key});
  static const double _twoColumnBreakpoint = 720;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(integrationsProvider);
    final items = state.items;
    final categories = ref.watch(integrationCategoriesProvider);
    final controller = ref.read(integrationsProvider.notifier);

    return SettingsSectionCard(
      title: 'Integrations',
      subtitle:
          'Your data sources. One card per connection — status, freshness, '
          'and where each read comes from.',
      children: [
        if (state.isLoading)
          const Padding(
            padding: EdgeInsets.only(bottom: 12),
            child: ClipRRect(
              borderRadius: BorderRadius.all(Radius.circular(4)),
              child: LinearProgressIndicator(
                minHeight: 2.5,
                backgroundColor: Colors.transparent,
                valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF7FE3FF)),
              ),
            ),
          ),
        for (final category in categories) ...[
          SettingsGroupLabel(
            category,
            topPadding: category == categories.first ? 0 : 20,
          ),
          _ConnectorGrid(
            items: items.where((i) => i.category == category).toList(),
            controller: controller,
            connectingId: state.connectingId,
            disconnectingId: state.disconnectingId,
          ),
        ],
      ],
    );
  }
}

class _ConnectorGrid extends StatelessWidget {
  const _ConnectorGrid({
    required this.items,
    required this.controller,
    this.connectingId,
    this.disconnectingId,
  });

  final List<IntegrationItem> items;
  final IntegrationsController controller;
  final String? connectingId;
  final String? disconnectingId;

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
                child: _ConnectorCard(
                  item: item,
                  controller: controller,
                  isConnecting: connectingId == item.id,
                  isDisconnecting: disconnectingId == item.id,
                ),
              ),
          ],
        );
      },
    );
  }
}

class _ConnectorCard extends StatelessWidget {
  const _ConnectorCard({
    required this.item,
    required this.controller,
    this.isConnecting = false,
    this.isDisconnecting = false,
  });

  final IntegrationItem item;
  final IntegrationsController controller;
  final bool isConnecting;
  final bool isDisconnecting;

  Future<void> _handleConnect(BuildContext context) async {
    if (item.id.toLowerCase() == 'shopify') {
      final shop = await _showShopifyDialog(context);
      if (shop == null || shop.trim().isEmpty) return;
      if (!context.mounted) return;
      await _executeConnect(context, shop: shop.trim());
    } else {
      await _executeConnect(context);
    }
  }

  Future<void> _executeConnect(BuildContext context, {String? shop}) async {
    try {
      final redirectUrl = await controller.connect(item.id, shop: shop);
      if (context.mounted) {
        await Navigator.of(context).push(
          MaterialPageRoute(
            builder: (_) => InAppWebViewScreen(
              url: redirectUrl,
              title: 'Connect ${item.name}',
            ),
          ),
        );
        if (context.mounted) {
          controller.loadStatus();
        }
      }
    } catch (e) {
      if (context.mounted) {
        final msg = e is ApiException
            ? e.message
            : 'Could not connect ${item.name}.';
        CustomToast.showError(context, msg);
      }
    }
  }

  Future<String?> _showShopifyDialog(BuildContext context) {
    final textController = TextEditingController();
    return showDialog<String>(
      context: context,
      builder: (ctx) => Dialog(
        backgroundColor: const Color(0xFF072C3D),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
          side: const BorderSide(color: Color.fromRGBO(127, 227, 255, 0.3)),
        ),
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Connect Shopify',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(height: 8),
              const Text(
                'Enter your Shopify store\'s subdomain to connect it.',
                style: TextStyle(
                  color: Color(0xFFCFEFFB),
                  fontSize: 13,
                  height: 1.4,
                ),
              ),
              const SizedBox(height: 18),
              const Text(
                'Store subdomain',
                style: TextStyle(
                  color: Color(0xFFCFEFFB),
                  fontSize: 12.5,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 8),
              Container(
                decoration: BoxDecoration(
                  color: const Color(0xFF04202D),
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(
                    color: const Color(0xFF3FBFE0),
                    width: 1.2,
                  ),
                ),
                padding: const EdgeInsets.symmetric(horizontal: 14),
                child: TextField(
                  controller: textController,
                  autofocus: true,
                  style: const TextStyle(color: Colors.white, fontSize: 14),
                  decoration: const InputDecoration(
                    hintText: 'your-store',
                    hintStyle: TextStyle(color: Color(0x66FFFFFF), fontSize: 14),
                    border: InputBorder.none,
                    isDense: true,
                    contentPadding: EdgeInsets.symmetric(vertical: 12),
                  ),
                  onSubmitted: (value) {
                    final trimmed = value.trim();
                    if (trimmed.isNotEmpty) {
                      Navigator.of(ctx).pop(trimmed);
                    }
                  },
                ),
              ),
              const SizedBox(height: 24),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  OutlinedButton(
                    style: OutlinedButton.styleFrom(
                      foregroundColor: Colors.white,
                      side: const BorderSide(color: Color(0x59FFFFFF)),
                      backgroundColor: const Color(0x1AFFFFFF),
                      padding: const EdgeInsets.symmetric(
                        horizontal: 20,
                        vertical: 10,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(24),
                      ),
                    ),
                    onPressed: () => Navigator.of(ctx).pop(null),
                    child: const Text(
                      'Cancel',
                      style: TextStyle(
                        fontSize: 13.5,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      foregroundColor: const Color(0xFFEAF8FF),
                      backgroundColor: const Color(0x4D5FE0FF),
                      side: const BorderSide(color: Color(0x667FE3FF)),
                      padding: const EdgeInsets.symmetric(
                        horizontal: 22,
                        vertical: 10,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(24),
                      ),
                    ),
                    onPressed: () {
                      final val = textController.text.trim();
                      if (val.isEmpty) {
                        CustomToast.showError(
                          ctx,
                          'Please enter your Shopify store subdomain.',
                        );
                        return;
                      }
                      Navigator.of(ctx).pop(val);
                    },
                    child: const Text(
                      'Connect',
                      style: TextStyle(
                        fontSize: 13.5,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _confirmDisconnect(BuildContext context) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: const Color(0xFF072638),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
          side: const BorderSide(color: Color.fromRGBO(127, 227, 255, 0.3)),
        ),
        title: Row(
          children: [
            const Icon(
              Icons.warning_amber_rounded,
              color: Color(0xFFFF6B6B),
              size: 24,
            ),
            const SizedBox(width: 8),
            Expanded(
              child: Text(
                'Disconnect ${item.name}?',
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
          ],
        ),
        content: Text(
          'Are you sure you want to disconnect ${item.name}? LightSignal will stop syncing live data from this provider.',
          style: const TextStyle(
            color: Color.fromRGBO(207, 239, 251, 0.85),
            fontSize: 13,
            height: 1.4,
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(false),
            child: const Text(
              'Cancel',
              style: TextStyle(
                color: Colors.white70,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFFE04545),
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            onPressed: () => Navigator.of(ctx).pop(true),
            child: const Text(
              'Disconnect',
              style: TextStyle(fontWeight: FontWeight.w700),
            ),
          ),
        ],
      ),
    );

    if (confirmed == true && context.mounted) {
      try {
        await controller.disconnect(item.id);
        if (context.mounted) {
          CustomToast.showSuccess(
            context,
            '${item.name} disconnected successfully.',
          );
        }
      } catch (e) {
        if (context.mounted) {
          final msg = e is ApiException
              ? e.message
              : 'Could not disconnect ${item.name}.';
          CustomToast.showError(context, msg);
        }
      }
    }
  }

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
                  label: isDisconnecting ? 'Disconnecting...' : 'Disconnect',
                  tone: SettingsButtonTone.danger,
                  compact: true,
                  onPressed: isDisconnecting
                      ? null
                      : () => _confirmDisconnect(context),
                ),
              ],
            )
          else
            SettingsPillButton(
              label: isConnecting ? 'Connecting...' : 'Connect',
              tone: SettingsButtonTone.primary,
              onPressed: isConnecting ? null : () => _handleConnect(context),
            ),
        ],
      ),
    );
  }
}
