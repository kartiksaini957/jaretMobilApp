import 'package:flutter/material.dart';
import '../../../theme/app_theme.dart';
import '../../../widgets/glass_card.dart';
import '../theme/settings_colors.dart';
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
    return GlassCard(
      surface: GlassSurface.panel,
      borderRadius: const BorderRadius.all(Radius.circular(20)),
      padding: const EdgeInsets.symmetric(horizontal: 26, vertical: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: AppTextStyles.logo.copyWith(
              fontSize: 17,
              fontWeight: FontWeight.w800,
            ),
          ),
          if (subtitle != null) ...[
            const SizedBox(height: 4),
            Text(
              subtitle!,
              style: AppTextStyles.body.copyWith(
                color: SettingsColors.soft,
                fontSize: 12.5,
                height: 1.55,
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
class SettingsGroupLabel extends StatelessWidget {
  const SettingsGroupLabel(this.text, {super.key, this.topPadding = 20});
  final String text;
  final double topPadding;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(top: topPadding, bottom: 10),
      child: Text(
        text.toUpperCase(),
        style: AppTextStyles.eyebrow.copyWith(
          color: SettingsColors.soft,
          fontSize: 11.5,
          fontWeight: FontWeight.w800,
          letterSpacing: 1.4,
        ),
      ),
    );
  }
}

class SettingsDivider extends StatelessWidget {
  const SettingsDivider({super.key});
  @override
  Widget build(BuildContext context) {
    return const Padding(
      padding: EdgeInsets.symmetric(vertical: 4),
      child: Divider(height: 1, thickness: 1, color: SettingsColors.rowDivider),
    );
  }
}
