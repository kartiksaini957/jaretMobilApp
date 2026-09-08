import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../theme/app_theme.dart';
import '../model/consentHistoryModel.dart';
import '../provider/consent_history_provider.dart';
import '../theme/settings_colors.dart';

String _formatTimestamp(String iso) {
  try {
    final dt = DateTime.parse(iso).toLocal();
    const months = [
      'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
      'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec',
    ];
    final hour12 = dt.hour % 12 == 0 ? 12 : dt.hour % 12;
    final minute = dt.minute.toString().padLeft(2, '0');
    final ampm = dt.hour >= 12 ? 'PM' : 'AM';
    return '${months[dt.month - 1]} ${dt.day}, ${dt.year} · $hour12:$minute $ampm';
  } catch (_) {
    return iso;
  }
}

Future<void> showConsentHistorySheet(BuildContext context) {
  return showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    builder: (context) => const _ConsentHistorySheet(),
  );
}

class _ConsentHistorySheet extends ConsumerWidget {
  const _ConsentHistorySheet();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final historyAsync = ref.watch(consentHistoryProvider);

    return DraggableScrollableSheet(
      initialChildSize: 0.75,
      minChildSize: 0.4,
      maxChildSize: 0.95,
      expand: false,
      builder: (context, scrollController) {
        return Container(
          decoration: const BoxDecoration(
            color: Color(0xFF0A2E3F),
            borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
          ),
          padding: const EdgeInsets.fromLTRB(20, 14, 20, 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Container(
                  width: 36,
                  height: 4,
                  decoration: BoxDecoration(
                    color: SettingsColors.faintText,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              Text('CONSENT HISTORY', style: AppTextStyles.eyebrow),
              const SizedBox(height: 4),
              Text(
                'A dated log of everything you\'ve agreed to.',
                style: AppTextStyles.body.copyWith(
                  color: SettingsColors.faintText,
                  fontSize: 12,
                ),
              ),
              const SizedBox(height: 14),
              Expanded(
                child: historyAsync.when(
                  loading: () => const Center(child: CircularProgressIndicator()),
                  error: (error, _) => Center(
                    child: Text(
                      'Could not load consent history.',
                      style: AppTextStyles.body.copyWith(color: SettingsColors.faintText),
                    ),
                  ),
                  data: (entries) {
                    if (entries.isEmpty) {
                      return Center(
                        child: Text(
                          'No consent history yet.',
                          style: AppTextStyles.body.copyWith(color: SettingsColors.faintText),
                        ),
                      );
                    }
                    return ListView.separated(
                      controller: scrollController,
                      itemCount: entries.length,
                      separatorBuilder: (_, __) => const SizedBox(height: 10),
                      itemBuilder: (context, index) => _ConsentTile(entry: entries[index]),
                    );
                  },
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

class _ConsentTile extends StatelessWidget {
  const _ConsentTile({required this.entry});
  final ConsentEntry entry;

  @override
  Widget build(BuildContext context) {
    final lines = entry.changeSummaryLines;
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      decoration: BoxDecoration(
        color: SettingsColors.white.withValues(alpha: 0.04),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: SettingsColors.white.withValues(alpha: 0.08)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  entry.action.replaceAll('_', ' '),
                  style: AppTextStyles.body.copyWith(
                    color: SettingsColors.white,
                    fontWeight: FontWeight.w600,
                    fontSize: 13,
                  ),
                ),
              ),
              Text(
                _formatTimestamp(entry.timestamp),
                style: AppTextStyles.body.copyWith(
                  color: SettingsColors.faintText,
                  fontSize: 11,
                ),
              ),
            ],
          ),
          if (lines.isNotEmpty) ...[
            const SizedBox(height: 8),
            for (final line in lines)
              Padding(
                padding: const EdgeInsets.only(top: 2),
                child: Text(
                  '• $line',
                  style: AppTextStyles.body.copyWith(
                    color: SettingsColors.soft,
                    fontSize: 12,
                  ),
                ),
              ),
          ],
        ],
      ),
    );
  }
}