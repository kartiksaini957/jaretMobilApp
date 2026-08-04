import 'package:flutter/material.dart';

import '../../../theme/app_theme.dart';
import '../data/demand_forecast_data.dart';
import 'forecast_breakdown_panel.dart';
import 'forecast_do_this_panel.dart';
import 'forecast_moving_panel.dart';
import 'forecast_track_record_panel.dart';
import 'forecast_world_scan_panel.dart';

class _Category {
  const _Category({
    required this.label,
    required this.tone,
    this.count,
    required this.summary,
    required this.builder,
  });

  final String label;
  final StatusTone tone;
  final String? count;
  final String summary;
  final WidgetBuilder builder;
}

/// "THE FULL READ" section: a stacked list of summary cards (Do this /
/// What's moving / The breakdown / Track record / World scan). Tapping a
/// card opens a bottom sheet with its full detail.
class ForecastFullReadSection extends StatelessWidget {
  const ForecastFullReadSection({super.key, required this.data});

  final ForecastTabData data;

  List<_Category> get _categories => [
    _Category(
      label: 'Do this',
      tone: data.doThisTone,
      count: '${data.doThisItems.length} actions',
      summary: data.doThisSummary,
      builder: (_) =>
          ForecastDoThisPanel(intro: data.doThisIntro, items: data.doThisItems),
    ),
    _Category(
      label: "What's moving",
      tone: data.movingTone,
      count: '${data.movingItems.length} forces',
      summary: data.movingSummary,
      builder: (_) => ForecastMovingPanel(items: data.movingItems),
    ),
    _Category(
      label: 'The breakdown',
      tone: data.breakdownTone,
      count: 'the math',
      summary: data.breakdownSummary,
      builder: (_) => ForecastBreakdownPanel(data: data.breakdown),
    ),
    _Category(
      label: 'Track record',
      tone: data.trackRecordTone,
      summary: data.trackRecordSummary,
      builder: (_) => ForecastTrackRecordPanel(
        body: data.trackRecordBody,
        footer: data.trackRecordFooter,
      ),
    ),
    _Category(
      label: 'World scan',
      tone: data.worldScanTone,
      count: data.worldScanCount,
      summary: data.worldScan.title,
      builder: (_) => ForecastWorldScanPanel(data: data.worldScan),
    ),
  ];

  void _open(BuildContext context, _Category category) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (sheetContext) => _CategorySheet(category: category),
    );
  }

  @override
  Widget build(BuildContext context) {
    final categories = _categories;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('THE FULL READ', style: AppTextStyles.eyebrow),
        const SizedBox(height: 10),
        for (var i = 0; i < categories.length; i++)
          Padding(
            padding: EdgeInsets.only(
              bottom: i == categories.length - 1 ? 0 : 12,
            ),
            child: _CategoryCard(
              category: categories[i],
              onTap: () => _open(context, categories[i]),
            ),
          ),
      ],
    );
  }
}

class _CategoryCard extends StatelessWidget {
  const _CategoryCard({required this.category, required this.onTap});

  final _Category category;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: AppColors.glassDark,
      borderRadius: BorderRadius.circular(16),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: AppColors.glassBorder),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 3,
                    ),
                    decoration: BoxDecoration(
                      color: category.tone.color.withValues(alpha: 0.18),
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: Text(
                      category.tone.badgeText,
                      style: AppTextStyles.body.copyWith(
                        color: category.tone.color,
                        fontSize: 11,
                      ),
                      // TextStyle(
                      //   color: category.tone.color,
                      //   fontSize: 10,
                      //   fontWeight: FontWeight.w800,
                      //   letterSpacing: 0.4,
                      // ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      category.label,
                      style: AppTextStyles.headlineAccent.copyWith(
                        fontSize: 14.5,
                        color: Colors.white,
                      ),
                    ),
                  ),
                  if (category.count != null)
                    Text(
                      category.count!,
                      style: AppTextStyles.small.copyWith(fontSize: 11),
                    ),
                ],
              ),
              const SizedBox(height: 8),
              Text(
                category.summary,
                style: AppTextStyles.small.copyWith(height: 1.45),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _CategorySheet extends StatelessWidget {
  const _CategorySheet({required this.category});

  final _Category category;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: false,
      child: Container(
        constraints: BoxConstraints(
          maxHeight: MediaQuery.of(context).size.height * 0.85,
        ),
        padding: const EdgeInsets.fromLTRB(20, 12, 20, 20),
        decoration: const BoxDecoration(
          color: AppColors.sheetSurface,
          borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Container(
                width: 36,
                height: 4,
                decoration: BoxDecoration(
                  color: AppColors.glassBorder,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 3,
                  ),
                  decoration: BoxDecoration(
                    color: category.tone.color.withValues(alpha: 0.18),
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: Text(
                    category.tone.badgeText,
                    style: AppTextStyles.body.copyWith(
                      color: category.tone.color,
                      fontSize: 11,
                    ),
                    // TextStyle(
                    //   color: category.tone.color,
                    //   fontSize: 10,
                    //   fontWeight: FontWeight.w800,
                    //   letterSpacing: 0.4,
                    // ),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    category.label,
                    style: AppTextStyles.headlineAccent.copyWith(
                      fontSize: 18,
                      color: Colors.white,
                    ),
                  ),
                ),
                if (category.count != null)
                  Text(
                    category.count!,
                    style: AppTextStyles.small.copyWith(fontSize: 12),
                  ),
              ],
            ),
            const SizedBox(height: 16),
            Flexible(
              child: SingleChildScrollView(child: category.builder(context)),
            ),
          ],
        ),
      ),
    );
  }
}
