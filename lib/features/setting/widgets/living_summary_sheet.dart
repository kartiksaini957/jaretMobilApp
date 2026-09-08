import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../theme/app_theme.dart';
import '../model/living_summary_model.dart';
import '../provider/living_summary_provider.dart';
import '../theme/settings_colors.dart';

String _formatTimestamp(String iso) {
  try {
    final dt = DateTime.parse(iso).toLocal();
    const months = [
      'Jan',
      'Feb',
      'Mar',
      'Apr',
      'May',
      'Jun',
      'Jul',
      'Aug',
      'Sep',
      'Oct',
      'Nov',
      'Dec',
    ];
    final hour12 = dt.hour % 12 == 0 ? 12 : dt.hour % 12;
    final minute = dt.minute.toString().padLeft(2, '0');
    final ampm = dt.hour >= 12 ? 'PM' : 'AM';
    return '${months[dt.month - 1]} ${dt.day}, ${dt.year} · $hour12:$minute $ampm';
  } catch (_) {
    return iso;
  }
}

Future<void> showLivingSummarySheet(BuildContext context) {
  return showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    builder: (context) => const _LivingSummarySheet(),
  );
}

class _LivingSummarySheet extends ConsumerWidget {
  const _LivingSummarySheet();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final summaryAsync = ref.watch(livingSummaryProvider);

    return DraggableScrollableSheet(
      initialChildSize: 0.75,
      minChildSize: 0.4,
      maxChildSize: 0.95,
      expand: false,
      builder: (context, scrollController) {
        return Container(
          decoration: const BoxDecoration(
            color: Color(0xFF08364C),
            borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
          ),
          padding: const EdgeInsets.fromLTRB(20, 14, 20, 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Container(
                  width: 38,
                  height: 4.5,
                  decoration: BoxDecoration(
                    color: SettingsColors.faintText.withValues(alpha: 0.4),
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
                      vertical: 3.5,
                    ),
                    decoration: BoxDecoration(
                      color: AppColors.accent.withValues(alpha: 0.15),
                      borderRadius: BorderRadius.circular(6),
                      border: Border.all(
                        color: AppColors.accent.withValues(alpha: 0.35),
                      ),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(
                          Icons.auto_awesome,
                          size: 13,
                          color: AppColors.accent,
                        ),
                        const SizedBox(width: 5),
                        Text(
                          'LIVING SUMMARY',
                          style: AppTextStyles.eyebrow.copyWith(
                            color: AppColors.accent,
                            fontSize: 10.5,
                            fontWeight: FontWeight.w700,
                            letterSpacing: 1.1,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const Spacer(),
                  // IconButton(
                  //   onPressed: () => ref.invalidate(livingSummaryProvider),
                  //   icon: const Icon(
                  //     Icons.refresh_rounded,
                  //     color: SettingsColors.soft,
                  //     size: 20,
                  //   ),
                  //   tooltip: 'Refresh',
                  //   visualDensity: VisualDensity.compact,
                  // ),
                  IconButton(
                    onPressed: () => Navigator.of(context).pop(),
                    icon: const Icon(
                      Icons.close_rounded,
                      color: SettingsColors.soft,
                      size: 20,
                    ),
                    tooltip: 'Close',
                    visualDensity: VisualDensity.compact,
                  ),
                ],
              ),
              const SizedBox(height: 10),
              Text(
                'What LightSignal has learned about your business',
                style: AppTextStyles.headline.copyWith(
                  color: SettingsColors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                'The living summary every agent reads before answering.',
                style: AppTextStyles.body.copyWith(
                  color: SettingsColors.faintText,
                  fontSize: 12.5,
                ),
              ),
              const SizedBox(height: 16),
              Expanded(
                child: summaryAsync.when(
                  loading: () => const Center(
                    child: CircularProgressIndicator(color: AppColors.accent),
                  ),
                  error: (error, _) => Center(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(
                          Icons.error_outline_rounded,
                          color: AppColors.crit,
                          size: 38,
                        ),
                        const SizedBox(height: 10),
                        Text(
                          'Could not load living summary.',
                          style: AppTextStyles.body.copyWith(
                            color: SettingsColors.white,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          error.toString(),
                          textAlign: TextAlign.center,
                          style: AppTextStyles.body.copyWith(
                            color: SettingsColors.faintText,
                            fontSize: 12,
                          ),
                        ),
                        const SizedBox(height: 14),
                        OutlinedButton.icon(
                          onPressed: () =>
                              ref.invalidate(livingSummaryProvider),
                          icon: const Icon(Icons.refresh, size: 16),
                          label: const Text('Retry'),
                          style: OutlinedButton.styleFrom(
                            foregroundColor: AppColors.accent,
                            side: const BorderSide(color: AppColors.accent),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  data: (data) => _SummaryContent(
                    data: data,
                    scrollController: scrollController,
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

class _SummaryContent extends StatelessWidget {
  const _SummaryContent({required this.data, required this.scrollController});

  final LivingSummaryData data;
  final ScrollController scrollController;

  @override
  Widget build(BuildContext context) {
    return ListView(
      controller: scrollController,
      padding: EdgeInsets.zero,
      children: [
        // Meta header chips
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: [
            if (data.updatedAt.isNotEmpty)
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 6,
                ),
                decoration: BoxDecoration(
                  color: SettingsColors.white.withValues(alpha: 0.05),
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(
                    color: SettingsColors.white.withValues(alpha: 0.1),
                  ),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(
                      Icons.schedule_rounded,
                      size: 14,
                      color: AppColors.soft,
                    ),
                    const SizedBox(width: 6),
                    Text(
                      'Updated ${_formatTimestamp(data.updatedAt)}',
                      style: AppTextStyles.body.copyWith(
                        color: SettingsColors.soft,
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ),
          ],
        ),
        const SizedBox(height: 18),
        Row(
          children: [
            Text(
              'OBSERVATIONS',
              style: AppTextStyles.eyebrow.copyWith(
                color: SettingsColors.soft,
                letterSpacing: 1.1,
              ),
            ),
            const SizedBox(width: 8),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 2),
              decoration: BoxDecoration(
                color: AppColors.accent.withValues(alpha: 0.2),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Text(
                '${data.observations.length}',
                style: const TextStyle(
                  color: AppColors.accent,
                  fontSize: 11,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        if (data.observations.isEmpty)
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
            decoration: BoxDecoration(
              color: SettingsColors.white.withValues(alpha: 0.04),
              borderRadius: BorderRadius.circular(14),
              border: Border.all(
                color: SettingsColors.white.withValues(alpha: 0.08),
              ),
            ),
            child: Center(
              child: Text(
                'No observations recorded yet.',
                style: AppTextStyles.body.copyWith(
                  color: SettingsColors.faintText,
                  fontSize: 13,
                ),
              ),
            ),
          )
        else
          ...data.observations.asMap().entries.map((entry) {
            final index = entry.key;
            final observation = entry.value;
            return Container(
              margin: const EdgeInsets.only(bottom: 10),
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: SettingsColors.white.withValues(alpha: 0.04),
                borderRadius: BorderRadius.circular(14),
                border: Border.all(
                  color: SettingsColors.white.withValues(alpha: 0.08),
                ),
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: 26,
                    height: 26,
                    margin: const EdgeInsets.only(right: 12, top: 1),
                    decoration: BoxDecoration(
                      color: AppColors.accent.withValues(alpha: 0.15),
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: AppColors.accent.withValues(alpha: 0.3),
                      ),
                    ),
                    alignment: Alignment.center,
                    child: Text(
                      '${index + 1}',
                      style: const TextStyle(
                        color: AppColors.accent,
                        fontSize: 11.5,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                  Expanded(
                    child: Text(
                      observation,
                      style: AppTextStyles.body.copyWith(
                        color: SettingsColors.white,
                        fontSize: 13.5,
                        height: 1.45,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ],
              ),
            );
          }),
        const SizedBox(height: 10),
      ],
    );
  }
}
