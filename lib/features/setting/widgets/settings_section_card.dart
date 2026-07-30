import 'package:flutter/material.dart';

import '../theme/settings_colors.dart';

/// Frosted glass card used as the single content panel for each settings
/// tab: a title, an optional subtitle, then a column of rows.
class SettingsSectionCard extends StatelessWidget {
  const SettingsSectionCard({
    super.key,
    required this.title,
    this.subtitle,
    required this.children,
  });

  final String title;
  final String? subtitle;
  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: SettingsColors.cardFill,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: SettingsColors.cardBorder),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(
              color: SettingsColors.white,
              fontSize: 20,
              fontWeight: FontWeight.w800,
            ),
          ),
          if (subtitle != null) ...[
            const SizedBox(height: 4),
            Text(
              subtitle!,
              style: const TextStyle(
                color: SettingsColors.faintText,
                fontSize: 12.5,
                height: 1.4,
              ),
            ),
          ],
          const SizedBox(height: 16),
          ...children,
        ],
      ),
    );
  }
}

/// Small uppercase section label used to break a card into sub-groups
/// (e.g. "CHANNELS", "ACCOUNTING", "ACTIVE SESSIONS").
class SettingsGroupLabel extends StatelessWidget {
  const SettingsGroupLabel(this.text, {super.key, this.topPadding = 20});

  final String text;
  final double topPadding;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(top: topPadding, bottom: 8),
      child: Text(
        text.toUpperCase(),
        style: const TextStyle(
          color: SettingsColors.faintText,
          fontSize: 11,
          fontWeight: FontWeight.w700,
          letterSpacing: 1.0,
        ),
      ),
    );
  }
}

/// Thin translucent divider between rows within a card.
class SettingsDivider extends StatelessWidget {
  const SettingsDivider({super.key});

  @override
  Widget build(BuildContext context) {
    return const Padding(
      padding: EdgeInsets.symmetric(vertical: 12),
      child: Divider(height: 1, color: SettingsColors.cardBorder),
    );
  }
}
