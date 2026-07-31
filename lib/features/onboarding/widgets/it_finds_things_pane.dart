import 'package:flutter/material.dart';

import '../../../theme/app_theme.dart';

class ItFindsThingsPane extends StatelessWidget {
  const ItFindsThingsPane({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text.rich(
          TextSpan(
            children: [
              TextSpan(text: 'It finds things ', style: AppTextStyles.headline),
              TextSpan(
                text: 'before\nyou\'d think to look.',
                style: AppTextStyles.headlineAccent.copyWith(
                  color: AppColors.accent,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 16),
         Text(
          'Real alerts when something needs you. A weekly note in plain '
          'words. You run the business; it keeps watch.',
          style: AppTextStyles.body,
        ),
        const SizedBox(height: 22),
        const _AlertCard(
          icon: Icons.bolt,
          title: 'Cash drops under your \$10,000 floor Thursday',
          detail:
              'Rent (\$4,100) and the Sysco invoice (\$3,850) both clear '
              'Thursday, the same week two receivables slipped past 45 '
              'days. Cash lands near \$7,200, about 18 days of runway. Ask '
              'Westland Catering (\$3,200, now 48 days) to clear by '
              'Wednesday and you stay above the floor.',
          footer: 'LightSignal · now',
        ),
        const SizedBox(height: 12),
        const _AlertCard(
          icon: Icons.access_time,
          title: 'Your week at Rowan & Oak',
          detail:
              'Margin held at 61%. One thing to act on: Sysco produce is '
              'up a third week. Full note inside.',
          footer: 'Weekly note',
        ),
      ],
    );
  }
}

class _AlertCard extends StatelessWidget {
  const _AlertCard({
    required this.icon,
    required this.title,
    required this.detail,
    required this.footer,
  });

  final IconData icon;
  final String title;
  final String detail;
  final String footer;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppColors.glassDark,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.glassBorder),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.all(4.0),
                child: Container(
                  width: 24,
                  height: 24,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: AppColors.blobCyan.withValues(alpha: 0.50),
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: Icon(icon, size: 16, color: AppColors.accent),
                ),
              ),
              const SizedBox(width: 6),
              Expanded(
                child: Text(
                  title,
                  style: const TextStyle(
                    color: AppColors.white,
                    fontSize: 13.5,
                    fontWeight: FontWeight.w700,
                    height: 1.3,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Padding(
            padding: const EdgeInsets.only(left: 45),
            child: Text(
              detail,
              style: AppTextStyles.small.copyWith(
                color: AppColors.mutedText,
                height: 1.5,
              ),
            ),
          ),
          const SizedBox(height: 8),
          Padding(
            padding: const EdgeInsets.only(left: 45),
            child: Text(footer, style: AppTextStyles.small),
          ),
        ],
      ),
    );
  }
}
