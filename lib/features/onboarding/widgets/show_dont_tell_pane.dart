import 'package:flutter/material.dart';

import '../../../theme/app_theme.dart';
import '../../../widgets/tag_chip.dart';

class ShowDontTellPane extends StatelessWidget {
  const ShowDontTellPane({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,

      children: [
        Text('THIS IS WHAT A READ LOOKS LIKE', style: AppTextStyles.eyebrow),
        const SizedBox(height: 10),
        Text.rich(
          TextSpan(
            children: [
              TextSpan(
                text: 'No dashboards to decode.\n',
                style: AppTextStyles.headline,
              ),
              TextSpan(
                text: 'Just the answer.',
                style: AppTextStyles.headlineAccent,
              ),
            ],
          ),
        ),
        const SizedBox(height: 24),
        const _InsightCard(),
      ],
    );
  }
}

class _InsightCard extends StatelessWidget {
  const _InsightCard();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.glassDark,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.glassBorder),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Padding(
                padding: const EdgeInsets.only(top: 0),
                child: Container(
                  width: 34,
                  height: 34,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: AppColors.blobCyan.withValues(alpha: 0.50),
                    borderRadius: BorderRadius.circular(9),
                  ),
                  child: Text(
                    'RO',
                    style: AppTextStyles.headlineAccent.copyWith(
                      color: const Color(0xFF04303F),
                      fontSize: 11,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Text(
                  'Rowan & Oak Coffee',
                  style: AppTextStyles.body.copyWith(
                    color: AppColors.white,
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
              Text(
                'This week',
                style: AppTextStyles.small.copyWith(fontSize: 10.5),
              ),
            ],
          ),
          const SizedBox(height: 2),
          Padding(
            padding: const EdgeInsets.only(left: 44),
            child: Text(
              'Café · 2 locations',
              style: AppTextStyles.small.copyWith(
                color: AppColors.faintText,
                fontSize: 11.5,
              ),
            ),
          ),
          const SizedBox(height: 14),
          Text.rich(
            TextSpan(
              style: AppTextStyles.body,
              children: [
                TextSpan(
                  text: 'Your second location is ',
                  style: AppTextStyles.body.copyWith(color: AppColors.white),
                ),
                TextSpan(
                  text: 'outpacing the first by 30%',
                  style: AppTextStyles.body.copyWith(
                    color: AppColors.goodText,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                TextSpan(
                  text:
                      ' on weekday mornings, but it runs out of pastries by '
                      '9am twice a week. ',
                  style: AppTextStyles.body.copyWith(color: AppColors.white),
                ),
                TextSpan(
                  text: 'Bump the morning bake order;',
                  style: AppTextStyles.body.copyWith(
                    color: AppColors.yellow,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                TextSpan(
                  text: ' you\'re turning away your best customers.',
                  style: AppTextStyles.body.copyWith(color: AppColors.white),
                ),
              ],
            ),
          ),
          const SizedBox(height: 14),
          const Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              TagChip(label: 'Demand: rising'),
              TagChip(label: 'Supply: short'),
              TagChip(label: '1 thing to fix'),
            ],
          ),
          const SizedBox(height: 14),
          Text(
            "Illustrative example. Sample read, not a real customer.",
            style: AppTextStyles.small.copyWith(
              color: AppColors.faintText,
              fontSize: 10.5,
            ),
          ),
        ],
      ),
    );
  }
}
